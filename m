Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3ENOtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:49:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:22295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab3ENOtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="337415968"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Olav Kongas <ok@artecdesign.ee>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 5/8] usb/isp116x-hcd: take msecs_to_jiffies_timeout into use
Date: Tue, 14 May 2013 17:48:35 +0300
Message-Id: <1368542918-8861-6-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_timeout instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/usb/host/isp116x-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index b64e661..de5807a 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -620,7 +620,7 @@ static irqreturn_t isp116x_irq(struct usb_hcd *hcd)
 			   to come out of suspend, it may take more
 			   than 10ms for status bits to stabilize. */
 			mod_timer(&hcd->rh_timer, jiffies
-				  + msecs_to_jiffies(20) + 1);
+				  + msecs_to_jiffies_timeout(20));
 		if (intstat & HCINT_RD) {
 			DBG("---- remote wakeup\n");
 			usb_hcd_resume_root_hub(hcd);
-- 
1.7.10.4

