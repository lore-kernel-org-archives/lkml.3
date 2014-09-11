Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaIKNFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:05:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52303 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798AbaIKNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:05:32 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tony Lindgren" <tony@atomide.com>,
        "Jeremy Vial" <jvial@adeneo-embedded.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.38442834@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 042/131] ARM: OMAP3: Fix choice of omap3_restore_es
 function in OMAP34XX rev3.1.2 case.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Vial <jvial@adeneo-embedded.com>

commit 9b5f7428f8b16bd8980213f2b70baf1dd0b9e36c upstream.

According to the comment “restore_es3: applies to 34xx >= ES3.0" in
"arch/arm/mach-omap2/sleep34xx.S”, omap3_restore_es3 should be used
if the revision of an OMAP34xx is ES3.1.2.

Signed-off-by: Jeremy Vial <jvial@adeneo-embedded.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-omap2/control.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -282,7 +282,8 @@ void omap3_save_scratchpad_contents(void
 		scratchpad_contents.public_restore_ptr =
 			virt_to_phys(omap3_restore_3630);
 	else if (omap_rev() != OMAP3430_REV_ES3_0 &&
-					omap_rev() != OMAP3430_REV_ES3_1)
+					omap_rev() != OMAP3430_REV_ES3_1 &&
+					omap_rev() != OMAP3430_REV_ES3_1_2)
 		scratchpad_contents.public_restore_ptr =
 			virt_to_phys(omap3_restore);
 	else

