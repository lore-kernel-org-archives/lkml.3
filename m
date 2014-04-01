Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaDANYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:24:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35652 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDANYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:24:22 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <arnd@arndb.de>,
        <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 0/5] drivers: bus: omap_l3: Conversion to devm_*
Date: Tue, 1 Apr 2014 16:23:45 +0300
Message-ID: <1396358630-32340-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v3:
- Tony's ack added

Changes since v2:
Comments from Alexander Shiyan addressed:
- Do not check the return of platform_get_resource() - no need to do that
- Use devm_ioremap_resource() instead devm_request_and_ioremap()

Changes since v1:
- Fixed Santosh's email address in the commit messages.

Cleanup of platform probe and remove (removing the remove function at the end)
with converting the driver to use the devm_* versions kzalloc, ioremap and
request_irq. 

This is a resend of an old series which I found when doing some spring cleanup
on my HDD:
http://www.spinics.net/lists/linux-omap/msg90531.html

Regards,
Peter
---
Peter Ujfalusi (5):
  drivers: bus: omap_l3: Convert to use devm_kzalloc
  drivers: bus: omap_l3: Convert to use devm_ioremap_resource()
  drivers: bus: omap_l3: Convert to use devm_request_irq()
  drivers: bus: omap_l3: Remove the platform driver's remove function
  drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request
    fails

 drivers/bus/omap_l3_noc.c | 102 +++++++++-------------------------------------
 1 file changed, 20 insertions(+), 82 deletions(-)

-- 
1.9.1

