Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192AbbAGCHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:07:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbbAGCHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 46/52] ncpfs: return proper error from NCP_IOC_SETROOT ioctl
Date: Tue,  6 Jan 2015 18:07:14 -0800
Message-Id: <20150107020602.499521556@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -448,7 +448,6 @@ static long __ncp_ioctl(struct inode *in
 						result = -EIO;
 					}
 				}
-				result = 0;
 			}
 			mutex_unlock(&server->root_setup_lock);
 


