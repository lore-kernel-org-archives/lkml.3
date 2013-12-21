Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3LUKWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:22:46 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38716 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3LUKWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:22:45 -0500
Date: Sat, 21 Dec 2013 15:50:29 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        josh@joshtriplett.org
Subject: [PATCH] drivers: dwc2: Mark function as static in core.c
Message-ID: <20131221102029.GA3151@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function dwc2_set_param_uframe_sched() as static in core.c because
it is not used outside this file.

This eliminates the following warning in core.c:
drivers/staging/dwc2/core.c:2739:5: warning: no previous prototype for ‘dwc2_set_param_uframe_sched’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/dwc2/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/dwc2/core.c b/drivers/staging/dwc2/core.c
index 6d001b5..c029cb6 100644
--- a/drivers/staging/dwc2/core.c
+++ b/drivers/staging/dwc2/core.c
@@ -2736,7 +2736,7 @@ int dwc2_get_hwparams(struct dwc2_hsotg *hsotg)
 	return 0;
 }
 
-int dwc2_set_param_uframe_sched(struct dwc2_hsotg *hsotg, int val)
+static int dwc2_set_param_uframe_sched(struct dwc2_hsotg *hsotg, int val)
 {
 	int retval = 0;
 
-- 
1.7.9.5

