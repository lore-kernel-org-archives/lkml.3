Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3EJMOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:14:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:12773 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab3EJMOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:14:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="334821439"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Olav Kongas <ok@artecdesign.ee>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 08/11] usb/isp116x-hcd: take msecs_to_jiffies_min into use
Date: Fri, 10 May 2013 15:13:26 +0300
Message-Id: <1368188011-23661-8-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_min instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/usb/host/isp116x-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index b64e661..6cc4660 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -620,7 +620,7 @@ static irqreturn_t isp116x_irq(struct usb_hcd *hcd)
 			   to come out of suspend, it may take more
 			   than 10ms for status bits to stabilize. */
 			mod_timer(&hcd->rh_timer, jiffies
-				  + msecs_to_jiffies(20) + 1);
+				  + msecs_to_jiffies_min(20));
 		if (intstat & HCINT_RD) {
 			DBG("---- remote wakeup\n");
 			usb_hcd_resume_root_hub(hcd);
-- 
1.7.10.4

