Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966320AbaKLBwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:52:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965126AbaKLBwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:52:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3.10 064/123] jbd2: free bh when descriptor block checksum fails
Date: Wed, 12 Nov 2014 10:17:10 +0900
Message-Id: <20141112011721.926145392@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 064d83892e9ba547f7d4eae22cbca066d95210ce upstream.

Free the buffer head if the journal descriptor block fails checksum
verification.

This is the jbd2 port of the e2fsprogs patch "e2fsck: free bh on csum
verify error in do_one_pass".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/recovery.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -522,6 +522,7 @@ static int do_one_pass(journal_t *journa
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
 				err = -EIO;
+				brelse(bh);
 				goto failed;
 			}
 


