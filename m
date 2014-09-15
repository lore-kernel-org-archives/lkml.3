Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbaIOWUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51272 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaIOWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeremy Vial <jvial@adeneo-embedded.com>, Tony Lindgren <tony@atomide.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 126/187] ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX rev3.1.2 case.
Date: Mon, 15 Sep 2014 15:08:56 -0700
Message-Id: <1410818997-9432-127-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Vial <jvial@adeneo-embedded.com>

commit 9b5f7428f8b16bd8980213f2b70baf1dd0b9e36c upstream.

According to the comment “restore_es3: applies to 34xx >= ES3.0" in
"arch/arm/mach-omap2/sleep34xx.S”, omap3_restore_es3 should be used
if the revision of an OMAP34xx is ES3.1.2.

Signed-off-by: Jeremy Vial <jvial@adeneo-embedded.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-omap2/control.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index 44bb4d5..89cde07 100644
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
1.9.1

