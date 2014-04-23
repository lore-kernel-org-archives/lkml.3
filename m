Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaDWQOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:14:46 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:40603 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbaDWQOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:14:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcLAJ7mV1NXQ6tr/2dsb2JhbABagwarbpIyhzqBGRd0gi0CNxwjGHERJBOIRQHOfY5YhEABA45shy+CWQGKbIdpgzM7
Date: Wed, 23 Apr 2014 18:14:42 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm <akpm@linux-foundation.org>,
        fuse-devel@lists.sourceforge.net
Subject: [PATCH 1/1] FS/FUSE: add __exit to fuse_ctl_cleanup
Message-Id: <20140423181442.d4d07316c04a9a528a393ea1@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse_ctl_cleanup is only called by __exit fuse_exit

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/fuse/control.c | 2 +-
 fs/fuse/fuse_i.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index a0b0855..205e0d5 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -348,7 +348,7 @@ int __init fuse_ctl_init(void)
 	return register_filesystem(&fuse_ctl_fs_type);
 }
 
-void fuse_ctl_cleanup(void)
+void __exit fuse_ctl_cleanup(void)
 {
 	unregister_filesystem(&fuse_ctl_fs_type);
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a257ed8e..adfa2d5 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -725,7 +725,7 @@ int fuse_dev_init(void);
 void fuse_dev_cleanup(void);
 
 int fuse_ctl_init(void);
-void fuse_ctl_cleanup(void);
+void __exit fuse_ctl_cleanup(void);
 
 /**
  * Allocate a request
-- 
1.9.1
