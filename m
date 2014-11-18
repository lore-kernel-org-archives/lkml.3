Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaKRPtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:49:45 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:60759 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaKRPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:49:43 -0500
Date: Tue, 18 Nov 2014 16:49:35 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: VFS: Parallel unmounting of filesystems produces system call error
Message-ID: <20141118164935.19771a88@lilie>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111815-0021-0000-0000-000001D349B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

I just ran some tests involving many parallel mount and unmount
operations. I sometimes get EINVAL and the umount program says "not
mounted". Which is definitively wrong. It feels like a race condition
somewhere in the VFS code.

I use todays master branch (commit fc14f9c1272f62c3) on s390 with 1024
DASD devices.

In fs/namespace.c, sys_umount:

> 	retval = user_path_mountpoint_at(AT_FDCWD, name, 
> lookup_flags, &path);
...
> 	retval = -EINVAL;
> 	if (path.dentry != path.mnt->mnt_root)
> 		goto dput_and_out;
This seems to be erroneously true from time to time.


The script does something equivalent to:
> for n in $DEVNODES; do
>	umount $n &
> done

Do you have any idea what's wrong?


Kind regards

Philipp





