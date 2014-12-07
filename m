Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaLGBOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 20:14:09 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45803 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaLGBOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 20:14:06 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-msm: vreg.c:  Remove unused function
Date: Sun,  7 Dec 2014 02:16:44 +0100
Message-Id: <1417915004-8574-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function vreg_put() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-msm/include/mach/vreg.h |    1 -
 arch/arm/mach-msm/vreg.c              |    4 ----
 2 files changed, 5 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/vreg.h b/arch/arm/mach-msm/include/mach/vreg.h
index 6626e78..28351ff 100644
--- a/arch/arm/mach-msm/include/mach/vreg.h
+++ b/arch/arm/mach-msm/include/mach/vreg.h
@@ -20,7 +20,6 @@
 struct vreg;
 
 struct vreg *vreg_get(struct device *dev, const char *id);
-void vreg_put(struct vreg *vreg);
 
 int vreg_enable(struct vreg *vreg);
 int vreg_disable(struct vreg *vreg);
diff --git a/arch/arm/mach-msm/vreg.c b/arch/arm/mach-msm/vreg.c
index bd66ed0..0bf891d 100644
--- a/arch/arm/mach-msm/vreg.c
+++ b/arch/arm/mach-msm/vreg.c
@@ -96,10 +96,6 @@ struct vreg *vreg_get(struct device *dev, const char *id)
 	return ERR_PTR(-ENOENT);
 }
 
-void vreg_put(struct vreg *vreg)
-{
-}
-
 int vreg_enable(struct vreg *vreg)
 {
 	unsigned id = vreg->id;
-- 
1.7.10.4

