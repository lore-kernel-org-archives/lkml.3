Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaHKCsy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 22:48:54 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56026 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaHKCsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:48:53 -0400
Date: Mon, 11 Aug 2014 11:47:20 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, ebiederm@xmission.com, eparis@redhat.com, rgb@redhat.com,
        tixxdz@opendz.org, adobriyan@gmail.com, bill.c.roberts@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] proc: potential ERR_PTR dereference on proc_fill_cache()
Message-ID: <20140811024720.GA11337@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The d_hash_and_lookup() returns NULL or ERR_PTR on lookup
failure.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/proc/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f50d4be..49bc09c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1673,7 +1673,7 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
 	ino_t ino;
 
 	child = d_hash_and_lookup(dir, &qname);
-	if (!child) {
+	if (IS_ERR_OR_NULL(child)) {
 		child = d_alloc(dir, &qname);
 		if (!child)
 			goto end_instantiate;
-- 
1.7.1

