Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbaCUOuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:50:00 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:43053 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaCUOt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:49:56 -0400
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: grant.likely@secretlab.ca
Cc: devicetree@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v3 0/2] dt: platform driver: Fill the resources before probe and defer if needed
Date: Fri, 21 Mar 2014 15:46:23 +0100
Message-Id: <1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140320161118.B7075C4067A@trevor.secretlab.ca>
References: <20140320161118.B7075C4067A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

This is the 3rd version of the patch. It's been reworked to screen the devices
not created by of_device_alloc() and check the reason why an OF IRQ description
can't be translated into a resource.

Jean-Jacques

Changes since V2:
 * only fill the resources for devices created by of_device_alloc(). Note:
   this is done by adding a new flag in struct device {}.
 * use deferred probing only if the IRQ domain cannot be found. 
  
Jean-Jacques Hiblot (2):
  of: irq: Added of_find_irq_domain() to get the domain of an irq
  dt: platform driver: Fill the resources before probe and defer if
    needed

 drivers/base/platform.c     |   5 ++
 drivers/of/irq.c            |  20 ++++++++
 drivers/of/platform.c       | 114 ++++++++++++++++++++++++++++++++++----------
 include/linux/device.h      |   1 +
 include/linux/of_irq.h      |   2 +
 include/linux/of_platform.h |  10 ++++
 6 files changed, 127 insertions(+), 25 deletions(-)

-- 
1.9.0

