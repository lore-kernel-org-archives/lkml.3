Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023Ab3GPUkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:40:53 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33449 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab3GPUkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:40:25 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 5/6] kconfig: don't allocate n+1 elements in temporary array
Date: Tue, 16 Jul 2013 22:40:01 +0200
Message-Id: <1407f97aeda5720d6327d69f6058537c0fd469e3.1374006854.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

The temporary array that stores the search results is not NULL-terminated,
so there is no reason to allocate n+1 elements.

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
---
 scripts/kconfig/symbol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index b664d6e..08d4401 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -1010,7 +1010,7 @@ struct symbol **sym_re_search(const char *pattern)
 			continue;
 		if (regexec(&re, sym->name, 1, match, 0))
 			continue;
-		if (cnt + 1 >= size) {
+		if (cnt >= size) {
 			void *tmp;
 			size += 16;
 			tmp = realloc(sym_match_arr, size * sizeof(struct sym_match *));
-- 
1.8.1.2

