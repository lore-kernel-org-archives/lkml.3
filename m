Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaGZQnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 12:43:42 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45530 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaGZQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 12:43:41 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: platforms: powermac: bootx_init.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 18:45:05 +0200
Message-Id: <1406393105-5222-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/platforms/powermac/bootx_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powermac/bootx_init.c b/arch/powerpc/platforms/powermac/bootx_init.c
index 3e91ef5..76f5013 100644
--- a/arch/powerpc/platforms/powermac/bootx_init.c
+++ b/arch/powerpc/platforms/powermac/bootx_init.c
@@ -246,7 +246,7 @@ static void __init bootx_scan_dt_build_strings(unsigned long base,
 		DBG(" detected display ! adding properties names !\n");
 		bootx_dt_add_string("linux,boot-display", mem_end);
 		bootx_dt_add_string("linux,opened", mem_end);
-		strncpy(bootx_disp_path, namep, 255);
+		strlcpy(bootx_disp_path, namep, sizeof(bootx_disp_path));
 	}
 
 	/* get and store all property names */
-- 
1.7.10.4

