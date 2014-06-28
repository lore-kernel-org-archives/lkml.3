Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaF1NfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:35:24 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47143 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaF1NfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:35:23 -0400
Date: Sat, 28 Jun 2014 19:05:17 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] procfs: Drop cast
Message-ID: <20140628133517.GA4786@himangi-Dell>
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
 fs/proc/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b7f268e..f599d43 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -372,7 +372,7 @@ struct proc_dir_entry *proc_symlink(const char *name,
 	if (ent) {
 		ent->data = kmalloc((ent->size=strlen(dest))+1, GFP_KERNEL);
 		if (ent->data) {
-			strcpy((char*)ent->data,dest);
+			strcpy(ent->data, dest);
 			if (proc_register(parent, ent) < 0) {
 				kfree(ent->data);
 				kfree(ent);
-- 
1.9.1

