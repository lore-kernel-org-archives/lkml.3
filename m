Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaDMSrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 14:47:24 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:50956 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbaDMSqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:46:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] mm: Initialize error in shmem_file_aio_read()
Date: Sun, 13 Apr 2014 20:46:22 +0200
Message-Id: <1397414783-28098-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
References: <1397414783-28098-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/shmem.c: In function ‘shmem_file_aio_read’:
mm/shmem.c:1414: warning: ‘error’ may be used uninitialized in this function

If the loop is aborted during the first iteration by one of the two first
break statements, error will be uninitialized.

Introduced by commit 6e58e79db8a16222b31fc8da1ca2ac2dccfc4237
("introduce copy_page_to_iter, kill loop over iovec in
generic_file_aio_read()").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
The code is too complex to see if this is an obvious false positive.

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 8f1a95406bae..9f70e02111c6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1411,7 +1411,7 @@ static ssize_t shmem_file_aio_read(struct kiocb *iocb,
 	pgoff_t index;
 	unsigned long offset;
 	enum sgp_type sgp = SGP_READ;
-	int error;
+	int error = 0;
 	ssize_t retval;
 	size_t count;
 	loff_t *ppos = &iocb->ki_pos;
-- 
1.7.9.5

