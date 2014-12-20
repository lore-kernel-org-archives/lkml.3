Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaLTO5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 09:57:16 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40715 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaLTO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 09:57:15 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Geoff Levand <geoff@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: platforms: ps3: repository.c:  Remove unused function
Date: Sat, 20 Dec 2014 16:00:01 +0100
Message-Id: <1419087601-4889-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ps3_repository_write_highmem_info() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/platforms/ps3/platform.h   |    2 --
 arch/powerpc/platforms/ps3/repository.c |   10 ----------
 2 files changed, 12 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/platform.h b/arch/powerpc/platforms/ps3/platform.h
index d71329a..f15507c 100644
--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -201,8 +201,6 @@ int ps3_repository_write_highmem_base(unsigned int region_index,
 	u64 highmem_base);
 int ps3_repository_write_highmem_size(unsigned int region_index,
 	u64 highmem_size);
-int ps3_repository_write_highmem_info(unsigned int region_index,
-	u64 highmem_base, u64 highmem_size);
 int ps3_repository_delete_highmem_info(unsigned int region_index);
 
 /* repository pme info */
diff --git a/arch/powerpc/platforms/ps3/repository.c b/arch/powerpc/platforms/ps3/repository.c
index bfccdc7..2d5e56a 100644
--- a/arch/powerpc/platforms/ps3/repository.c
+++ b/arch/powerpc/platforms/ps3/repository.c
@@ -1160,16 +1160,6 @@ int ps3_repository_write_highmem_size(unsigned int region_index,
 		highmem_size, 0);
 }
 
-int ps3_repository_write_highmem_info(unsigned int region_index,
-	u64 highmem_base, u64 highmem_size)
-{
-	int result;
-
-	result = ps3_repository_write_highmem_base(region_index, highmem_base);
-	return result ? result
-		: ps3_repository_write_highmem_size(region_index, highmem_size);
-}
-
 static int ps3_repository_delete_highmem_base(unsigned int region_index)
 {
 	return delete_node(
-- 
1.7.10.4

