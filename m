Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3D2SAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:00:31 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53780 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab3D2R7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:59:11 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Benjamin Poirier <bpoirier@suse.de>
Subject: [PATCH 1/1] kconfig: fix lists definition for C++
Date: Mon, 29 Apr 2013 19:59:02 +0200
Message-Id: <21ca352b71ca252e1933b1538fe89da8a04395c3.1367258255.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1367258255.git.yann.morin.1998@free.fr>
References: <cover.1367258255.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1367258255.git.yann.morin.1998@free.fr>
References: <cover.1367258255.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

The C++ compiler is more strict in that it refuses to assign
a void* to a struct list_head*.

Fix that by explicitly casting the poisonning constants.

(Tested with all 5 frontends, now.)

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/list.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/list.h b/scripts/kconfig/list.h
index ea1d581..685d80e 100644
--- a/scripts/kconfig/list.h
+++ b/scripts/kconfig/list.h
@@ -125,7 +125,7 @@ static inline void __list_del(struct list_head *prev, struct list_head *next)
 static inline void list_del(struct list_head *entry)
 {
 	__list_del(entry->prev, entry->next);
-	entry->next = LIST_POISON1;
-	entry->prev = LIST_POISON2;
+	entry->next = (struct list_head*)LIST_POISON1;
+	entry->prev = (struct list_head*)LIST_POISON2;
 }
 #endif
-- 
1.8.1.2

