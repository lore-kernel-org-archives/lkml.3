Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaGZN6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 09:58:33 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64997 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaGZN6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 09:58:32 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        James Hogan <james.hogan@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mips: ralink: of.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 15:59:57 +0200
Message-Id: <1406383197-1219-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mips/ralink/of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index 2513952..7c4598c 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -81,7 +81,7 @@ static int __init plat_of_setup(void)
 		panic("device tree not present");
 
 	strlcpy(of_ids[0].compatible, soc_info.compatible, len);
-	strncpy(of_ids[1].compatible, "palmbus", len);
+	strlcpy(of_ids[1].compatible, "palmbus", len);
 
 	if (of_platform_populate(NULL, of_ids, NULL, NULL))
 		panic("failed to populate DT");
-- 
1.7.10.4

