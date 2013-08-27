Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3H0BLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:11:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3H0BHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kumar Amit Mehta <gmate.amit@gmail.com>,
        Kent Overstreet <koverstreet@google.com>
Subject: [ 73/74] md: bcache: io.c: fix a potential NULL pointer dereference
Date: Mon, 26 Aug 2013 18:09:11 -0700
Message-Id: <20130827010439.389338008@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Amit Mehta <gmate.amit@gmail.com>

commit 5c694129c8db6d89c9be109049a16510b2f70f6d upstream.

bio_alloc_bioset returns NULL on failure. This fix adds a missing check
for potential NULL pointer dereferencing.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -97,6 +97,8 @@ struct bio *bch_bio_split(struct bio *bi
 
 	if (bio->bi_rw & REQ_DISCARD) {
 		ret = bio_alloc_bioset(gfp, 1, bs);
+		if (!ret)
+			return NULL;
 		idx = 0;
 		goto out;
 	}


