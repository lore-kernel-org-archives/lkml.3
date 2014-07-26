Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaGZQmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 12:42:10 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57107 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaGZQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 12:42:08 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Chen Gang <gang.chen@asianux.com>, Cedric Le Goater <clg@fr.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: kernel: nvram_64.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 18:43:32 +0200
Message-Id: <1406393013-5138-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kernel/nvram_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
index 28b898e..5ed7b74 100644
--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -292,7 +292,7 @@ int __init nvram_remove_partition(const char *name, int sig,
 
 		/* Make partition a free partition */
 		part->header.signature = NVRAM_SIG_FREE;
-		strncpy(part->header.name, "wwwwwwwwwwww", 12);
+		strlcpy(part->header.name, "wwwwwwwwwwww", sizeof(part->header.name));
 		part->header.checksum = nvram_checksum(&part->header);
 		rc = nvram_write_header(part);
 		if (rc <= 0) {
@@ -395,7 +395,7 @@ loff_t __init nvram_create_partition(const char *name, int sig,
 	new_part->index = free_part->index;
 	new_part->header.signature = sig;
 	new_part->header.length = size;
-	strncpy(new_part->header.name, name, 12);
+	strlcpy(new_part->header.name, name, sizeof(new_part->header.name));
 	new_part->header.checksum = nvram_checksum(&new_part->header);
 
 	rc = nvram_write_header(new_part);
-- 
1.7.10.4

