Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbaHZFYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:24:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29228 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaHZFYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:24:00 -0400
X-AuditID: cbfee61a-f79e46d00000134f-22-53fc19eeb29d
From: Chao Yu <chao2.yu@samsung.com>
To: "'Tyler Hicks'" <tyhicks@canonical.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <000001cfa721$57072880$05157980$@samsung.com>
 <20140725033353.GC8446@boyd>
In-reply-to: <20140725033353.GC8446@boyd>
Subject: RE: [PATCH] ecryptfs: avoid to access NULL pointer when write metadata
 in xattr
Date: Tue, 26 Aug 2014 13:23:12 +0800
Message-id: <008401cfc0ed$efd37ab0$cf7a7010$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQC/UCS5j8IuYAKTDmzJjAgW/WYZCwLtkhZYnevKKsA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jAd13kn+CDbas5bJ4e3c5u8XlXXPY
	LDbdbGFyYPaY1dDL5vF5k1wAUxSXTUpqTmZZapG+XQJXxp5LkQXntSsWz3rB3MB4T7mLkZND
	QsBEYuvGKawQtpjEhXvr2boYuTiEBBYxSpyfcBTK+cEocfbsUrAqNgEVieUd/5lAbBEBTYmP
	k16CxZkFrCSO717NDGILCURILPv1mh3E5gSqaew8wgJiCwtESbx8s5wRxGYRUJX4dWoxmM0r
	YCnx+esmNghbUOLH5HssEDO1JNbvPM4EYctLbF7zlhniUgWJHWdfM0LcYCWx6M0ZNogacYmN
	R26xTGAUmoVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFh/kxq
	B+PKBotDjAIcjEo8vDfifwcLsSaWFVfmHmKU4GBWEuFleAgU4k1JrKxKLcqPLyrNSS0+xCjN
	waIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwCjh9bCxrW1fgb3ZmmU/DnD1ckUpsP4/mvlT
	KWOBZEGzw8/zxydHsaa8Oq9mwfJJxU+ZJbXG+siZ9M3s83ukD3KktfcbiE3sf8h4a5GphFOm
	iXbP5pgZlcrGR/p3v+ZmnqInV2O5td7xfv/2JxnvV5ofl4+5eXbeJl/HmTdTOntO8781nKfZ
	o8RSnJFoqMVcVJwIAJRh8WtvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tyler,

Sorry to bother you!

I didn't see any progress of this patch, is there anything wrong
with this patch? If there is, please let me know.

Regards,
Yu

> -----Original Message-----
> From: Tyler Hicks [mailto:tyhicks@canonical.com]
> Sent: Friday, July 25, 2014 11:34 AM
> To: Chao Yu
> Cc: ecryptfs@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ecryptfs: avoid to access NULL pointer when write metadata in xattr
> 
> Hello and thanks for the patch!
> 
> On 2014-07-24 17:25:42, Chao Yu wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=41692
> 
> This actually isn't the bug that this patch fixes. It is a different bug
> (that I don't think exists anymore) and someone happened to test for the
> bug on a newer kernel and hit the oops that you're fixing here.
> 
> >
> > Christopher Head 2014-06-28 05:26:20 UTC described:
> > "I tried to reproduce this on 3.12.21. Instead, when I do "echo hello > foo"
> > in an ecryptfs mount with ecryptfs_xattr specified, I get a kernel crash:
> >
> > BUG: unable to handle kernel NULL pointer dereference at           (null)
> > IP: [<ffffffff8110eb39>] fsstack_copy_attr_all+0x2/0x61
> > PGD d7840067 PUD b2c3c067 PMD 0
> > Oops: 0002 [#1] SMP
> > Modules linked in: nvidia(PO)
> > CPU: 3 PID: 3566 Comm: bash Tainted: P           O 3.12.21-gentoo-r1 #2
> > Hardware name: ASUSTek Computer Inc. G60JX/G60JX, BIOS 206 03/15/2010
> > task: ffff8801948944c0 ti: ffff8800bad70000 task.ti: ffff8800bad70000
> > RIP: 0010:[<ffffffff8110eb39>]  [<ffffffff8110eb39>] fsstack_copy_attr_all+0x2/0x61
> > RSP: 0018:ffff8800bad71c10  EFLAGS: 00010246
> > RAX: 00000000000181a4 RBX: ffff880198648480 RCX: 0000000000000000
> > RDX: 0000000000000004 RSI: ffff880172010450 RDI: 0000000000000000
> > RBP: ffff880198490e40 R08: 0000000000000000 R09: 0000000000000000
> > R10: ffff880172010450 R11: ffffea0002c51e80 R12: 0000000000002000
> > R13: 000000000000001a R14: 0000000000000000 R15: ffff880198490e40
> > FS:  00007ff224caa700(0000) GS:ffff88019fcc0000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000000 CR3: 00000000bb07f000 CR4: 00000000000007e0
> > Stack:
> > ffffffff811826e8 ffff8800a39d8000 0000000000000000 000000000000001a
> > ffff8800a01d0000 ffff8800a39d8000 ffffffff81185fd5 ffffffff81082c2c
> > 00000001a39d8000 53d0abbc98490e40 0000000000000037 ffff8800a39d8220
> > Call Trace:
> > [<ffffffff811826e8>] ? ecryptfs_setxattr+0x40/0x52
> > [<ffffffff81185fd5>] ? ecryptfs_write_metadata+0x1b3/0x223
> > [<ffffffff81082c2c>] ? should_resched+0x5/0x23
> > [<ffffffff8118322b>] ? ecryptfs_initialize_file+0xaf/0xd4
> > [<ffffffff81183344>] ? ecryptfs_create+0xf4/0x142
> > [<ffffffff810f8c0d>] ? vfs_create+0x48/0x71
> > [<ffffffff810f9c86>] ? do_last.isra.68+0x559/0x952
> > [<ffffffff810f7ce7>] ? link_path_walk+0xbd/0x458
> > [<ffffffff810fa2a3>] ? path_openat+0x224/0x472
> > [<ffffffff810fa7bd>] ? do_filp_open+0x2b/0x6f
> > [<ffffffff81103606>] ? __alloc_fd+0xd6/0xe7
> > [<ffffffff810ee6ab>] ? do_sys_open+0x65/0xe9
> > [<ffffffff8157d022>] ? system_call_fastpath+0x16/0x1b
> > RIP  [<ffffffff8110eb39>] fsstack_copy_attr_all+0x2/0x61
> > RSP <ffff8800bad71c10>
> > CR2: 0000000000000000
> > ---[ end trace df9dba5f1ddb8565 ]---"
> >
> > If we create a file when we mount with ecryptfs_xattr_metadata option, we will
> > encounter a crash in this path:
> > ->ecryptfs_create
> >   ->ecryptfs_initialize_file
> >     ->ecryptfs_write_metadata
> >       ->ecryptfs_write_metadata_to_xattr
> >         ->ecryptfs_setxattr
> >           ->fsstack_copy_attr_all
> > It's because our dentry->d_inode used in fsstack_copy_attr_all is NULL, and it
> > will be initialized when ecryptfs_initialize_file finish.
> >
> > So we should skip copying attr from lower inode when the value of ->d_inode is
> > invalid.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> 
> I wrote a patch to fix this bug last week, made the changes necessary to
> run through all of the eCryptfs tests with the ecryptfs_xattr_metadata
> mount option, tested the fix, and then forgot to send out the patch.
> (doh!) But it worked out well because I think I like your patch better.
> 
> I moved the innards of ecryptfs_setxattr() into a new function that
> accepts the lower_dentry and ecryptfs inode as separate arguments. That
> way it can work regardless of the eCryptfs dentry not yet being
> d_initialized().
> 
> After looking at your patch, I don't think that's necessary. Skipping
> the fsstack_copy_attr_all() should be fine for brand new eCryptfs
> inodes since the attr copy just happened in ecryptfs_inode_set().
> 
> I'll test your patch and then push it to the eCryptfs -next branch. I'll
> also update the bug link to point to the specific comment rather than
> the unrelated bug itself. Thanks!
> 
> Tyler
> 
> >  fs/ecryptfs/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> > index e67f9f0..436b7d8 100644
> > --- a/fs/ecryptfs/inode.c
> > +++ b/fs/ecryptfs/inode.c
> > @@ -1037,7 +1037,7 @@ ecryptfs_setxattr(struct dentry *dentry, const char *name, const void
> *value,
> >  	}
> >
> >  	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
> > -	if (!rc)
> > +	if (!rc && dentry->d_inode)
> >  		fsstack_copy_attr_all(dentry->d_inode, lower_dentry->d_inode);
> >  out:
> >  	return rc;
> > --
> > 2.0.1.474.g72c7794
> >
> >

