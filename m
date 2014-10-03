Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaJCVhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:37:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaJCVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:35:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.16 106/357] locks: pass correct "before" pointer to locks_unlink_lock in generic_add_lease
Date: Fri,  3 Oct 2014 14:28:12 -0700
Message-Id: <20141003212936.661808096@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@primarydata.com>

commit e0b760ff71be168d4e623f7c3612e98902ab93e9 upstream.

The argument to locks_unlink_lock can't be just any pointer to a
pointer. It must be a pointer to the fl_next field in the previous
lock in the list.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1595,7 +1595,7 @@ static int generic_add_lease(struct file
 	smp_mb();
 	error = check_conflicting_open(dentry, arg);
 	if (error)
-		locks_unlink_lock(flp);
+		locks_unlink_lock(before);
 out:
 	if (is_deleg)
 		mutex_unlock(&inode->i_mutex);


