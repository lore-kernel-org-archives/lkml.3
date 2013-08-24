Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3HXPU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:20:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab3HXPU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:20:26 -0400
Date: Sat, 24 Aug 2013 17:14:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: kill the extra proc_readfd_common()->dir_emit_dots()
Message-ID: <20130824151434.GA28775@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_readfd_common() does dir_emit_dots() twice in a row,
we need to do this only once.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/fd.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 75f2890..0ff80f9 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -230,8 +230,6 @@ static int proc_readfd_common(struct file *file, struct dir_context *ctx,
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
-	if (!dir_emit_dots(file, ctx))
-		goto out;
 	files = get_files_struct(p);
 	if (!files)
 		goto out;
-- 
1.5.5.1


