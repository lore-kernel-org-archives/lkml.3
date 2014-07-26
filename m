Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaGZN47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 09:56:59 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33187 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaGZN46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 09:56:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Steven Miao <realmz6@gmail.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sonic Zhang <sonic.zhang@analog.com>, Al Viro <viro@zeniv.linux.org.uk>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: blackfin: kernel: setup.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 15:58:22 +0200
Message-Id: <1406383102-1128-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/blackfin/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 4f424ae..ad82468 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -1464,5 +1464,5 @@ void __init cmdline_init(const char *r0)
 {
 	early_shadow_stamp();
 	if (r0)
-		strncpy(command_line, r0, COMMAND_LINE_SIZE);
+		strlcpy(command_line, r0, COMMAND_LINE_SIZE);
 }
-- 
1.7.10.4

