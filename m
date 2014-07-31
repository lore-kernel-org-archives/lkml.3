Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaGaNWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:22:09 -0400
Received: from smtp.adetelgroup.com ([94.247.26.71]:44922 "EHLO
	hbg-pa71.hmc-pa.adm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbaGaNWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:22:08 -0400
From: Jeremy Vial <jvial@adeneo-embedded.com>
To: tony@atomide.com
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX rev3.1.2 case.
Date: Thu, 31 Jul 2014 15:10:33 +0200
Message-Id: <1406812234-23163-2-git-send-email-jvial@adeneo-embedded.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406812234-23163-1-git-send-email-jvial@adeneo-embedded.com>
References: <1406812234-23163-1-git-send-email-jvial@adeneo-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comment “restore_es3: applies to 34xx >= ES3.0" in
"arch/arm/mach-omap2/sleep34xx.S”, omap3_restore_es3 should be used
if the revision of an OMAP34xx is ES3.1.2.

Signed-off-by: Jeremy Vial <jvial@adeneo-embedded.com>
---
 arch/arm/mach-omap2/control.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index 751f354..acadac0 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -314,7 +314,8 @@ void omap3_save_scratchpad_contents(void)
 		scratchpad_contents.public_restore_ptr =
 			virt_to_phys(omap3_restore_3630);
 	else if (omap_rev() != OMAP3430_REV_ES3_0 &&
-					omap_rev() != OMAP3430_REV_ES3_1)
+					omap_rev() != OMAP3430_REV_ES3_1 &&
+					omap_rev() != OMAP3430_REV_ES3_1_2)
 		scratchpad_contents.public_restore_ptr =
 			virt_to_phys(omap3_restore);
 	else
-- 
1.7.9.5

