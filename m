Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaF1Nef (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:34:35 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59919 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaF1Nee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:34:34 -0400
Date: Sat, 28 Jun 2014 19:04:28 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] kernfs: Drop cast
Message-ID: <20140628133428.GA4751@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does away with cast on void * and the if as it is unnecessary.

The following Coccinelle semantic patch was used for making the change:

@r@
expression x;
void* e;
type T;
identifier f;
@@

(
  *((T *)e)
|
  ((T *)x)[...]
|
  ((T *)x)->f
|
- (T *)
  e
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 fs/kernfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1c77193..85738f4 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -188,7 +188,7 @@ static unsigned int kernfs_name_hash(const char *name, const void *ns)
 	unsigned int len = strlen(name);
 	while (len--)
 		hash = partial_name_hash(*name++, hash);
-	hash = (end_name_hash(hash) ^ hash_ptr((void *)ns, 31));
+	hash = (end_name_hash(hash) ^ hash_ptr(ns, 31));
 	hash &= 0x7fffffffU;
 	/* Reserve hash numbers 0, 1 and INT_MAX for magic directory entries */
 	if (hash < 2)
-- 
1.9.1

