Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbaCQJl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:41:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40531 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaCQJl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:41:28 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-e2-5326c34605d7
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: fix incorrect parsing with option string
Date: Mon, 17 Mar 2014 17:40:40 +0800
Message-id: <000301cf41c5$10f247b0$32d6d710$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9BxKfihh5NbgESRsuNlE79aczaxw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAV23w2rBBre/allc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH82WvWgiVsFc27
	d7A3MP5m6WLk5JAQMJF4/HovO4QtJnHh3nq2LkYuDiGBRYwSc7snQzk/GCX+NEwB62ATUJFY
	3vGfCcQWEVCU2PB+A1g3s0CmxL2mGcwgtrCAl8TtS9PAbBYBVYnVu5oYQWxeAUuJvw8XsUDY
	ghI/Jt9jgejVkli/8zgThC0vsXnNW2aIixQkdpx9zQixS0/ibN8ZqF3iEhuP3GKZwCgwC8mo
	WUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgkP5mfQOxlUNFocYBTgY
	lXh4JyirBQuxJpYVV+YeYpTgYFYS4T19ACjEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQ
	QHpiSWp2ampBahFMlomDU6qBcbLOsaD/Zt3WgrXHlmrI17L9UtaTPz6nRU95zpIYhQwPz9kT
	Z+T0Lz/rUGXQK8mzw2rmqiTFVvkV12pM9+cr3u2dxsmyYcayaTUq+XIKkypv3VxVVJMsz6Vw
	5+7LBzySJe8v7dHoW1u3rLi10ETCe37wtCQJk1lvSs+Uvk24tPmAxc96N20DJZbijERDLeai
	4kQAXiH9gmECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously 'background_gc={on***,off***}' is being parsed as correct option,
with this patch we cloud fix the trivial bug in mount process.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 057a3ef..6597290 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -258,9 +258,9 @@ static int parse_options(struct super_block *sb, char *options)
 
 			if (!name)
 				return -ENOMEM;
-			if (!strncmp(name, "on", 2))
+			if (!strncmp(name, "on", strlen(name)))
 				set_opt(sbi, BG_GC);
-			else if (!strncmp(name, "off", 3))
+			else if (!strncmp(name, "off", strlen(name)))
 				clear_opt(sbi, BG_GC);
 			else {
 				kfree(name);
-- 
1.7.9.5


