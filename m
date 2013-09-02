Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3IBJHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:07:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425Ab3IBIzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>, Chris Zankel <chris@zankel.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 30/58] xtensa: fix linker script transformation for .text.unlikely
Date: Mon,  2 Sep 2013 09:54:15 +0100
Message-Id: <1378112083-9475-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit f6a03a12ecdbe0dd80a55f6df3b7206c5a403a49 upstream.

Now that binutils generate *.unlikely sections which don't follow
documented (info as) literal section naming rules, section name
transformation script doesn't work well resulting in the following
errors at vmlinux link time:

	main.c:(.text.unlikely+0x3): dangerous relocation: l32r: literal
				     placed after use: .literal.unlikely

Fix section name transformation script by adding specific rule for
.text.unlikely sections.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/xtensa/kernel/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/xtensa/kernel/Makefile b/arch/xtensa/kernel/Makefile
index 59fc3fe..0f9f35f 100644
--- a/arch/xtensa/kernel/Makefile
+++ b/arch/xtensa/kernel/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_MODULES) += xtensa_ksyms.o module.o
 # Replicate rules in scripts/Makefile.build
 
 sed-y = -e 's/\*(\(\.[a-z]*it\|\.ref\|\)\.text)/*(\1.literal \1.text)/g'    \
+	-e 's/\.text\.unlikely/.literal.unlikely .text.unlikely/g' \
 	-e 's/\*(\(\.text\.[a-z]*\))/*(\1.literal \1)/g'
 
 quiet_cmd__cpp_lds_S = LDS     $@
-- 
1.8.3.2

