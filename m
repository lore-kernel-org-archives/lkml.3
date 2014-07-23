Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbaGWOlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:41:23 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55851 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891AbaGWOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:41:21 -0400
Date: Wed, 23 Jul 2014 20:11:11 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ceph: convert comma to semicolon
Message-ID: <20140723144111.GA3190@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a comma between expression statements by a semicolon. This changes
the semantics of the code, but given the current indentation appears to be
what is intended.

A simplified version of the Coccinelle semantic patch that performs this
transformation is as follows:
// <smpl>
@r@
expression e1,e2;
@@

 e1
-,
+;
 e2;
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1fde164..6d1cd45 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3277,7 +3277,7 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
 			rel->ino = cpu_to_le64(ceph_ino(inode));
 			rel->cap_id = cpu_to_le64(cap->cap_id);
 			rel->seq = cpu_to_le32(cap->seq);
-			rel->issue_seq = cpu_to_le32(cap->issue_seq),
+			rel->issue_seq = cpu_to_le32(cap->issue_seq);
 			rel->mseq = cpu_to_le32(cap->mseq);
 			rel->caps = cpu_to_le32(cap->implemented);
 			rel->wanted = cpu_to_le32(cap->mds_wanted);
-- 
1.9.1

