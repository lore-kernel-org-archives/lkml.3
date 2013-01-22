Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3AVBLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:11:48 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:50392 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3AVBLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:11:47 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH loop_2013_01_04] fs: Fix a typo in aio_rw_vect_retry()
Date: Tue, 22 Jan 2013 02:11:20 +0100
Message-Id: <1358817080-20678-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave confirmed Jeff's suspicion in [1]:

> That wants to be rw_op = do_aio_write in the else clause.  How did you
> test this patch set?

Yep, that's certainly a bug. I concentrated on testing on loop mounts,
running some fio and ltp testcases, but I'm at a loss to explain how
things seem to work as well as they do. Let's see how where fixing this
leads.

This is a fixup to commit daf0f6142dd5 ("fs: use read_iter and write_iter
rather than aio_read and aio_write") from Dave Kleiklamp's GIT tree in [2].

[1] http://www.spinics.net/lists/linux-fsdevel/msg61587.html
[2] https://github.com/kleikamp/linux-shaggy/commits/loop_2013_01_04

Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 08f550a..9635e7a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1320,7 +1320,7 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb)
 		rw_op = do_aio_read;
 		opcode = IOCB_CMD_PREADV;
 	} else {
-		rw_op = do_aio_read;
+		rw_op = do_aio_write;
 		opcode = IOCB_CMD_PWRITEV;
 	}
 
-- 
1.8.1.1

