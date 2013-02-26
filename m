Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616Ab3B0Ac7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:32:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354Ab3BZX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [ 28/53] ext4: add missing kfree() on error return path in add_new_gdb()
Date: Tue, 26 Feb 2013 15:57:57 -0800
Message-Id: <20130226235622.760294630@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit c49bafa3842751b8955a962859f42d307673d75d upstream.

We added some more error handling in b40971426a "ext4: add error
checking to calls to ext4_handle_dirty_metadata()".  But we need to
call kfree() as well to avoid a memory leak.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/ext4/resize.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -499,6 +499,7 @@ static int add_new_gdb(handle_t *handle,
 	return err;
 
 exit_inode:
+	kfree(n_group_desc);
 	/* ext4_handle_release_buffer(handle, iloc.bh); */
 	brelse(iloc.bh);
 exit_dindj:


