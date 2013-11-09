Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796Ab3KIHa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:30:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3KIGuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 08/74] bcache: Fixed incorrect order of arguments to bio_alloc_bioset()
Date: Fri,  8 Nov 2013 22:51:13 -0800
Message-Id: <20131109065114.083757826@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit d4eddd42f592a0cf06818fae694a3d271f842e4d upstream.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/request.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1059,7 +1059,7 @@ static void request_write(struct cached_
 
 		if (bio->bi_rw & REQ_FLUSH) {
 			/* Also need to send a flush to the backing device */
-			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
+			struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
 							     dc->disk.bio_split);
 
 			flush->bi_rw	= WRITE_FLUSH;


