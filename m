Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbbAGC0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:26:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685AbbAGCSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 60/73] ncpfs: return proper error from NCP_IOC_SETROOT ioctl
Date: Tue,  6 Jan 2015 18:16:21 -0800
Message-Id: <20150107021559.352953926@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ncpfs/ioctl.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -447,7 +447,6 @@ static long __ncp_ioctl(struct inode *in
 						result = -EIO;
 					}
 				}
-				result = 0;
 			}
 			mutex_unlock(&server->root_setup_lock);
 


