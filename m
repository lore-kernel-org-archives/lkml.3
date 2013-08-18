Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3HRUuC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:50:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3HRUdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, Chris Zankel <chris@zankel.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 29/34] xtensa: fix linker script transformation for .text.unlikely
Date: Sun, 18 Aug 2013 13:34:42 -0700
Message-Id: <20130818203301.674695286@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/kernel/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/xtensa/kernel/Makefile
+++ b/arch/xtensa/kernel/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_MODULES) += xtensa_ksyms.o
 # Replicate rules in scripts/Makefile.build
 
 sed-y = -e 's/\*(\(\.[a-z]*it\|\.ref\|\)\.text)/*(\1.literal \1.text)/g'    \
+	-e 's/\.text\.unlikely/.literal.unlikely .text.unlikely/g' \
 	-e 's/\*(\(\.text\.[a-z]*\))/*(\1.literal \1)/g'
 
 quiet_cmd__cpp_lds_S = LDS     $@


