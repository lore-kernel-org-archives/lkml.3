Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab3HORKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:10:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47422 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175Ab3HORKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:10:03 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux@openrisc.net,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH 0/4] DT: move of_get_cpu_node from PPC to DT core
Date: Thu, 15 Aug 2013 18:09:36 +0100
Message-Id: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 15 Aug 2013 17:09:58.0877 (UTC) FILETIME=[4587C8D0:01CE99DA]
X-MC-Unique: 113081518100000901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7FHB848017240

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Hi,

This series needs to be prepended with the original series[1][2][3]
Except the first patch in the original series(which is merged into this
as last patch), there is no other change(apart from function signature)
I am posting only this part for feedback separately for review as the
original series is already reviewed. Once this part is review and aknowledged
I will combine the complete series and post it.

Hi Rob,

Since the compatible 'ibm,ppc-interrupt-server#s' is one-off and for
historical reasons, if future architectures are adhering to ePAPR,
IMO having a weak definition of arch_of_cpu_get_node as you suggested
could lead to it's misuse in future. So I didn't take that approach.

Regards,
Sudeep

Sudeep KarkadaNagesha (4):
  microblaze: remove undefined of_get_cpu_node declaration
  openrisc: remove undefined of_get_cpu_node declaration
  powerpc: refactor of_get_cpu_node to support other architectures
  of: move of_get_cpu_node implementation to DT core library

 arch/microblaze/include/asm/prom.h |  3 --
 arch/openrisc/include/asm/prom.h   |  3 --
 arch/powerpc/include/asm/prom.h    |  3 --
 arch/powerpc/kernel/prom.c         | 43 +----------------
 drivers/of/base.c                  | 94 ++++++++++++++++++++++++++++++++++++++
 include/linux/cpu.h                |  1 +
 include/linux/of.h                 |  7 +++
 7 files changed, 104 insertions(+), 50 deletions(-)

-- 
1.8.1.2

[1] https://lkml.org/lkml/2013/7/15/128
[2] https://lkml.org/lkml/2013/7/17/341
[3] https://lkml.org/lkml/2013/7/22/219

