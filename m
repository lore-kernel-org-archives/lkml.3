Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbbAHUDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:03:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47310 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbbAHUDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:03:42 -0500
Date: Thu, 8 Jan 2015 12:03:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] jbd2: complain about descriptor block checksum errors
Message-ID: <20150108200334.GB9976@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should complain in dmesg when journal recovery fails on account of
the descriptor block being corrupt, so that the diagnostic data can
be recovered.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/recovery.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index bcbef08..b5128c6 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -524,6 +524,9 @@ static int do_one_pass(journal_t *journal,
 			if (descr_csum_size > 0 &&
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
+				printk(KERN_ERR "JBD2: Invalid checksum "
+				       "recovering block %lu in log\n",
+				       next_log_block);
 				err = -EIO;
 				brelse(bh);
 				goto failed;
