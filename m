Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaG2QyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaG2QyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:54:15 -0400
Subject: [PATCH] AFS: Correctly assemble the client UUID
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: julia.lawall@lip6.fr, himangi774@gmail.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2014 17:53:23 +0100
Message-ID: <20140729165323.5926.47422.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly assemble the client UUID by OR'ing in the flags rather than
assigning them over the other components.

Reported-by: Himangi Saraogi <himangi774@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/afs/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/main.c b/fs/afs/main.c
index 42dd2e499ed8..35de0c04729f 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -55,13 +55,13 @@ static int __init afs_get_client_UUID(void)
 	afs_uuid.time_low = uuidtime;
 	afs_uuid.time_mid = uuidtime >> 32;
 	afs_uuid.time_hi_and_version = (uuidtime >> 48) & AFS_UUID_TIMEHI_MASK;
-	afs_uuid.time_hi_and_version = AFS_UUID_VERSION_TIME;
+	afs_uuid.time_hi_and_version |= AFS_UUID_VERSION_TIME;
 
 	get_random_bytes(&clockseq, 2);
 	afs_uuid.clock_seq_low = clockseq;
 	afs_uuid.clock_seq_hi_and_reserved =
 		(clockseq >> 8) & AFS_UUID_CLOCKHI_MASK;
-	afs_uuid.clock_seq_hi_and_reserved = AFS_UUID_VARIANT_STD;
+	afs_uuid.clock_seq_hi_and_reserved |= AFS_UUID_VARIANT_STD;
 
 	_debug("AFS UUID: %08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x",
 	       afs_uuid.time_low,

