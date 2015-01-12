Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbbALLu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:50:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42044 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbbALLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:50:47 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2015 06:50:47 EST
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH v2 9/9] Documentation: update notes in biovecs about arbitrarily sized bios
Date: Mon, 12 Jan 2015 12:49:48 +0100
Message-Id: <46ed4095bbdb89c9bbd1170cb403dffaac9dc13f.1421052746.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <3fc2ee4eedd3bc6ef515b14108942425afb733d3.1421052746.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
 <4e7cfbce77dcf72474e1b930ef017c9efaea36d7.1421052746.git.dongsu.park@profitbricks.com>
 <ed9c9f3b8190cd64cddbe58a753c811aee69471f.1421052746.git.dongsu.park@profitbricks.com>
 <641ab3a0eeb225316784b8a22a285eab911d48fd.1421052746.git.dongsu.park@profitbricks.com>
 <ca2dd738a2c26bba51acedae96ddb6cb65658268.1421052746.git.dongsu.park@profitbricks.com>
 <c98bf7a8cccb8a831566a72f87e8be9511d70e41.1421052746.git.dongsu.park@profitbricks.com>
 <5cfac9da1b2724050502c3fa6a00af25bae2e0a7.1421052746.git.dongsu.park@profitbricks.com>
 <b574939e25f9be0aacc631045bb507dcecab5f39.1421052746.git.dongsu.park@profitbricks.com>
 <3fc2ee4eedd3bc6ef515b14108942425afb733d3.1421052746.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052745.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update block/biovecs.txt so that it includes a note on what kind of
effects arbitrarily sized bios would bring to the block layer.
Also fix a trivial typo, bio_iter_iovec.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 Documentation/block/biovecs.txt | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
index 74a32ad..2568958 100644
--- a/Documentation/block/biovecs.txt
+++ b/Documentation/block/biovecs.txt
@@ -24,7 +24,7 @@ particular, presenting the illusion of partially completed biovecs so that
 normal code doesn't have to deal with bi_bvec_done.
 
  * Driver code should no longer refer to biovecs directly; we now have
-   bio_iovec() and bio_iovec_iter() macros that return literal struct biovecs,
+   bio_iovec() and bio_iter_iovec() macros that return literal struct biovecs,
    constructed from the raw biovecs but taking into account bi_bvec_done and
    bi_size.
 
@@ -109,3 +109,11 @@ Other implications:
    over all the biovecs in the new bio - which is silly as it's not needed.
 
    So, don't use bi_vcnt anymore.
+
+ * The current interface allows the block layer to split bios as needed, so we
+   could eliminate a lot of complexity particularly in stacked drivers. Code
+   that creates bios can then create whatever size bios are convenient, and
+   more importantly stacked drivers don't have to deal with both their own bio
+   size limitations and the limitations of the underlying devices. Thus
+   there's no need to define ->merge_bvec_fn() callbacks for individual block
+   drivers.
-- 
2.1.0

