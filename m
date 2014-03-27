Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbaC0TmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:42:13 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:55959 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaC0TmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:42:07 -0400
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>
Subject: [RFC PATCH 0/4] vmlinux.lds.h clean-ups
Date: Thu, 27 Mar 2014 14:41:53 -0500
Message-Id: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Several DeviceTree related sections have been added recently to enable
early DT initialization calls. I have the need to add yet another one
in order to do a DT based earlycon. Since each section follows the same
pattern, this seemed like a good opportunity for some clean-up. So
this series creates a common macro to define these sections. with this
adding any new OF table section is a 2 line change.

Each section ends with a zeroed struct of_device_id (except cpu_method).
Right now there is an end section and a dummy variable to create the end
marker. Really, we just need padding here, but I haven't come up with a
way for the linker script to get the struct size. 

The last patch extends the same concept to another common pattern for
section definitons. There's still others which could be easily converted
also, but I'm looking for feedback on this approach before proceeding
any further.

Rob

Rob Herring (4):
  irqchip: align irqchip OF match table section naming
  ARM: align cpu_method_of_table naming
  vmlinuz.lds: define OF table sections with macros
  vmlinux.lds: define conditional sections with macros

 arch/arm/kernel/devtree.c         |  11 +--
 drivers/irqchip/irqchip.c         |   6 +-
 include/asm-generic/vmlinux.lds.h | 142 +++++++++++---------------------------
 3 files changed, 52 insertions(+), 107 deletions(-)

-- 
1.8.3.2

