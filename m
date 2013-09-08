Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab3IHDTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56208 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756540Ab3IHDSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Vyacheslav Dubeyko" <slava@dubeyko.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.897425294@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [087/121] nilfs2: remove double bio_put() in nilfs_end_bio_write()
 for BIO_EOPNOTSUPP error
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vyacheslav Dubeyko <slava@dubeyko.com>

commit 2df37a19c686c2d7c4e9b4ce1505b5141e3e5552 upstream.

Remove double call of bio_put() in nilfs_end_bio_write() for the case of
BIO_EOPNOTSUPP error detection.  The issue was found by Dan Carpenter
and he suggests first version of the fix too.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nilfs2/segbuf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -345,8 +345,7 @@ static void nilfs_end_bio_write(struct b
 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		bio_put(bio);
-		/* to be detected by submit_seg_bio() */
+		/* to be detected by nilfs_segbuf_submit_bio() */
 	}
 
 	if (!uptodate)

