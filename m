Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab3KOK5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:57:47 -0500
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:55837 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199Ab3KOK5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:57:38 -0500
From: Julien DELACOU <julien.delacou@st.com>
To: Paul Zimmerman <paulz@synopsys.com>, Matthijs Kooijman <matthijs@stdin.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, Julien Delacou <julien.delacou@st.com>
Subject: [PATCH] staging: dwc2: do not clear pending interrupts twice
Date: Fri, 15 Nov 2013 11:39:38 +0100
Message-Id: <1384511978-18770-1-git-send-email-julien.delacou@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pending interrupts clearing is done in dwc2_enable_common_interrupts
so we don't need to do it twice.

Signed-off-by: Julien Delacou <julien.delacou@st.com>
---
 drivers/staging/dwc2/core.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/dwc2/core.c b/drivers/staging/dwc2/core.c
index c8ff668..8374ec3 100644
--- a/drivers/staging/dwc2/core.c
+++ b/drivers/staging/dwc2/core.c
@@ -533,9 +533,6 @@ void dwc2_enable_host_interrupts(struct dwc2_hsotg *hsotg)
 	writel(0, hsotg->regs + GINTMSK);
 	writel(0, hsotg->regs + HAINTMSK);
 
-	/* Clear any pending interrupts */
-	writel(0xffffffff, hsotg->regs + GINTSTS);
-
 	/* Enable the common interrupts */
 	dwc2_enable_common_interrupts(hsotg);
 
-- 
1.7.9.5

