Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3AYWtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:49:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3AYWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Daney <david.daney@cavium.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 07/19] scripts/sortextable: silence script output
Date: Fri, 25 Jan 2013 22:44:06 +0000
Message-Id: <1359153858-31992-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:RD85eIXuScF+9KH+v/nrnKmF4PYSod7x6yRQiUuofJ+
 edJA8ALNnvukldAQZFVtXE33WTn+kMWPvVZPXskfVi1gkaS5o9
 yywFg8mqh1hr94mihnzZPReTwcrBOEKEF7iCwXWuv4IRK7Ax9e
 seuD7AXkPwOobYybveq6KO5legO1M7/2OP92VqjxW8KuZXrFjl
 vxydft4n38i3OW/UwAEOoDQrT8OE74E45lRztneTLxXMpE07Mn
 jZd20J/beMpzxTW2tLg09yr3oth69oovTeWCtYMiS4XrS+kLbh
 0EyOiSUCwN54vPcMQeKlqtdr+WeEmo562uzFqK+CiLA1k7us2h
 GQk3lWorJz/0Zxqu9GQWMIKAAOaurJGqPCP6wWW25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exception table sorter outputs one line every time
it gets called, e.g. 'sort done marker at 66dc00', which
is slightly annoying when doing 'make -s' which is otherwise
completely silent. Since that output is not helpful to
most people building the kernel, turn it off by default.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Daney <david.daney@cavium.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 scripts/sortextable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/sortextable.h b/scripts/sortextable.h
index e4fd45b..f5eb43d 100644
--- a/scripts/sortextable.h
+++ b/scripts/sortextable.h
@@ -182,7 +182,7 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
 		_r(&sort_needed_sym->st_value) -
 		_r(&sort_needed_sec->sh_addr);
 
-#if 1
+#if 0
 	printf("sort done marker at %lx\n",
 	       (unsigned long)((char *)sort_done_location - (char *)ehdr));
 #endif
-- 
1.8.0

