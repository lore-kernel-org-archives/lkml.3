Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaFEA3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:29:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaFDXWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 100/228] fs/affs/super.c: bugfix / double free
Date: Wed,  4 Jun 2014 16:22:09 -0700
Message-Id: <20140604232351.257138624@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Frederick <fabf@skynet.be>

commit d353efd02357a74753cd45f367a2d3d357fd6904 upstream.

Commit 842a859db26b ("affs: use ->kill_sb() to simplify ->put_super()
and failure exits of ->mount()") adds .kill_sb which frees sbi but
doesn't remove sbi free in case of parse_options error causing double
free+random crash.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/affs/super.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -336,8 +336,6 @@ static int affs_fill_super(struct super_
 				&blocksize,&sbi->s_prefix,
 				sbi->s_volume, &mount_flags)) {
 		printk(KERN_ERR "AFFS: Error parsing options\n");
-		kfree(sbi->s_prefix);
-		kfree(sbi);
 		return -EINVAL;
 	}
 	/* N.B. after this point s_prefix must be released */


