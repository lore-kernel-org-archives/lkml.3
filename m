Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaDVW54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:57:56 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58426 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDVW5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:57:54 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: bcrl@kvack.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] aio: Fix type of iterator variable in do_io_submit()
Date: Tue, 22 Apr 2014 17:57:03 -0500
Message-Id: <1398207423-21119-1-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_io_submit() iterated over the userspace iocb structure pointers using
a variable i of type 'int'.  This was wrong since 'nr', the number of
iocb structure pointers, could potentially be up to LONG_MAX /
sizeof(struct iocb *).  Fix it (and also remove the unnecessary
initialization to 0).

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 12a3de0e..4c96af7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1441,7 +1441,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 {
 	struct kioctx *ctx;
 	long ret = 0;
-	int i = 0;
+	long i;
 	struct blk_plug plug;
 
 	if (unlikely(nr < 0))
-- 
1.9.2

