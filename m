Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab3JCEMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:12:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3JCEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:12:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 01/52] block: Fix bio_copy_data()
Date: Wed,  2 Oct 2013 21:05:19 -0700
Message-Id: <20131003040522.291012764@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 2f6cf0de0281d210061ce976f2d42d246adc75bb upstream.

The memcpy() in bio_copy_data() was using the wrong offset vars, leading
to data corruption in weird unusual setups.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/bio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/bio.c
+++ b/fs/bio.c
@@ -917,8 +917,8 @@ void bio_copy_data(struct bio *dst, stru
 		src_p = kmap_atomic(src_bv->bv_page);
 		dst_p = kmap_atomic(dst_bv->bv_page);
 
-		memcpy(dst_p + dst_bv->bv_offset,
-		       src_p + src_bv->bv_offset,
+		memcpy(dst_p + dst_offset,
+		       src_p + src_offset,
 		       bytes);
 
 		kunmap_atomic(dst_p);


