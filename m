Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbbAIKef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:34:35 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44632 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757521AbbAIKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 69/78] ncpfs: return proper error from NCP_IOC_SETROOT ioctl
Date: Fri,  9 Jan 2015 11:32:18 +0100
Message-Id: <6186e5361e7cfdc13545f468fe65d195fcf08e5f.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a682e9c28cac152e6e54c39efcf046e0c8cfcf63 upstream.

If some error happens in NCP_IOC_SETROOT ioctl, the appropriate error
return value is then (in most cases) just overwritten before we return.
This can result in reporting success to userspace although error happened.

This bug was introduced by commit 2e54eb96e2c8 ("BKL: Remove BKL from
ncpfs").  Propagate the errors correctly.

Coverity id: 1226925.

Fixes: 2e54eb96e2c80 ("BKL: Remove BKL from ncpfs")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ncpfs/ioctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 60426ccb3b65..2f970de02b16 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -448,7 +448,6 @@ static long __ncp_ioctl(struct inode *inode, unsigned int cmd, unsigned long arg
 						result = -EIO;
 					}
 				}
-				result = 0;
 			}
 			mutex_unlock(&server->root_setup_lock);
 
-- 
2.2.1

