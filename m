Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463Ab3BNNuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:50:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331Ab3BNNtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 11/11] scripts/sortextable: silence script output
Date: Thu, 14 Feb 2013 14:49:27 +0100
Message-Id: <1360849767-1463135-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0S27SaTbNVebV6IUdYj3DzNhEj0hKuaHCmIPoVgqKUi
 rgZ3DsaNmMJ2LUtkupbX6KdBpjUPcCfeSoB0adPaD7pR3FCW0S
 XMR1oYZz+K++GdYlnoFZutGWwWGvbdhrOdS3BnMLGU+yLozl3A
 qpWv8NE2LSvaFm6uThNlEZLa7q9Ogz6hQfvx9uot88+4bGrZ+L
 7nVAKNGcHGNBGOQPP4N1JEEnZueFuYfMmM6vi/UkErwM7caFG/
 PKbOHP56OmkfWyh7/4A8Kmwa50Ou/AzTmY5sEs+2amwbqqLPhy
 R3AtmudaO/uS6rVw+hZ+RhDzRVlbztLsPxc9nmUuv78B5kUg5b
 VVJXMguywDEkzVULO7qL64Y1ZZhpdIImePEcPmckD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exception table sorter outputs one line every time
it gets called, e.g. 'sort done marker at 66dc00', which
is slightly annoying when doing 'make -s' which is otherwise
completely silent. Since that output is not helpful to
most people building the kernel, turn it off by default.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Daney <david.daney@cavium.com>
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
1.8.1.2

