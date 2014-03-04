Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbaCDJLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:11:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57172 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818AbaCDJJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:09:05 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 0/5] drivers: bus: omap_l3: Conversion to devm_*
Date: Tue, 4 Mar 2014 11:08:25 +0200
Message-ID: <1393924110-11132-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
  drivers: bus: omap_l3: Convert to use devm_request_and_ioremap()
  drivers: bus: omap_l3: Convert to use devm_request_irq()
  drivers: bus: omap_l3: Remove the platform driver's remove function
  drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request
    fails

 drivers/bus/omap_l3_noc.c | 106 +++++++++++-----------------------------------
 1 file changed, 24 insertions(+), 82 deletions(-)

-- 
1.9.0

