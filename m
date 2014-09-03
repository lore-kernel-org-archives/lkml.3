Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaICJzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:55:50 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57303 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756008AbaICJzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:55:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeremy Vial <jvial@adeneo-embedded.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 28/56] ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX rev3.1.2 case.
Date: Wed,  3 Sep 2014 11:26:47 +0200
Message-Id: <3b663e168268f78ddec40117ebb6231e7cdab7ef.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Vial <jvial@adeneo-embedded.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9b5f7428f8b16bd8980213f2b70baf1dd0b9e36c upstream.

According to the comment “restore_es3: applies to 34xx >= ES3.0" in
"arch/arm/mach-omap2/sleep34xx.S”, omap3_restore_es3 should be used
if the revision of an OMAP34xx is ES3.1.2.

Signed-off-by: Jeremy Vial <jvial@adeneo-embedded.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-omap2/control.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index 31e0dfe4a4ea..62a392bd0b57 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -324,7 +324,8 @@ void omap3_save_scratchpad_contents(void)
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
2.1.0

