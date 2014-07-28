Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaG1PZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:25:10 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45222 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaG1PZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:25:05 -0400
Date: Mon, 28 Jul 2014 20:54:58 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] afs: delete double assignment
Message-ID: <20140728152457.GA2901@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simplified version of Coccinelle semantic match that finds this problem is as
follows:

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
Should the second assignment is each case be a |= ?
 fs/afs/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/afs/main.c b/fs/afs/main.c
index 42dd2e4..a2f5a16 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -54,13 +54,10 @@ static int __init afs_get_client_UUID(void)
 	uuidtime += AFS_UUID_TO_UNIX_TIME;
 	afs_uuid.time_low = uuidtime;
 	afs_uuid.time_mid = uuidtime >> 32;
-	afs_uuid.time_hi_and_version = (uuidtime >> 48) & AFS_UUID_TIMEHI_MASK;
 	afs_uuid.time_hi_and_version = AFS_UUID_VERSION_TIME;
 
 	get_random_bytes(&clockseq, 2);
 	afs_uuid.clock_seq_low = clockseq;
-	afs_uuid.clock_seq_hi_and_reserved =
-		(clockseq >> 8) & AFS_UUID_CLOCKHI_MASK;
 	afs_uuid.clock_seq_hi_and_reserved = AFS_UUID_VARIANT_STD;
 
 	_debug("AFS UUID: %08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x",
-- 
1.9.1

