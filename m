Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaG3BuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:50:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaG3BuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 3.15 22/37] fuse: s_time_gran fix
Date: Tue, 29 Jul 2014 18:48:58 -0700
Message-Id: <20140730014828.768733315@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit a800bad36619ce47ac0222004635448e6c91ff72 upstream.

Default s_time_gran is 1, don't overwrite that if userspace didn't
explicitly specify one.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/inode.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -907,9 +907,6 @@ static void process_init_reply(struct fu
 				fc->writeback_cache = 1;
 			if (arg->time_gran && arg->time_gran <= 1000000000)
 				fc->sb->s_time_gran = arg->time_gran;
-			else
-				fc->sb->s_time_gran = 1000000000;
-
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;


