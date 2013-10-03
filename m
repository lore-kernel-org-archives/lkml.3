Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3JCETD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:19:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3JCES6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:18:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 02/57] sysv: Add forgotten superblock lock init for v7 fs
Date: Wed,  2 Oct 2013 21:08:28 -0700
Message-Id: <20131003040636.772951254@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

commit 49475555848d396a0c78fb2f8ecceb3f3f263ef1 upstream.

Superblock lock was replaced with (un)lock_super() removal, but left
uninitialized for Seventh Edition UNIX filesystem in the following commit (3.7):
c07cb01 sysv: drop lock/unlock super

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/sysv/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -487,6 +487,7 @@ static int v7_fill_super(struct super_bl
 	sbi->s_sb = sb;
 	sbi->s_block_base = 0;
 	sbi->s_type = FSTYPE_V7;
+	mutex_init(&sbi->s_lock);
 	sb->s_fs_info = sbi;
 	
 	sb_set_blocksize(sb, 512);


