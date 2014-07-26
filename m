Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaGZODP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:03:15 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52176 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaGZODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:03:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Chris Metcalf <cmetcalf@tilera.com>, Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Daniel Walter <dwalter@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: tile: kernel: setup.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:04:40 +0200
Message-Id: <1406383480-1485-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/tile/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 112abab..1af7d19 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1087,7 +1087,7 @@ static int __init setup_initramfs_file(char *str)
 {
 	if (str == NULL)
 		return -EINVAL;
-	strncpy(initramfs_file, str, sizeof(initramfs_file) - 1);
+	strlcpy(initramfs_file, str, sizeof(initramfs_file));
 	set_initramfs_file = 1;
 
 	return 0;
-- 
1.7.10.4

