Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3KIUDD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 15:03:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab3KIUC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 15:02:59 -0500
Date: Sat, 9 Nov 2013 21:04:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] fs: forbid to open anon-inode files via /proc
Message-ID: <20131109200424.GA4967@redhat.com>
References: <20131108183001.2564151a619f8f6df3db543a@canb.auug.org.au> <20131108125915.GA1000@redhat.com> <20131108134859.GA4461@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108134859.GA4461@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Oleg Nesterov wrote:
>
> On 11/08, Oleg Nesterov wrote:
> >
> > On 11/08, Stephen Rothwell wrote:
> > >
> > > Hi Andrew,
> > >
> > > Today's linux-next merge of the akpm-current tree got a conflict in
> > > fs/anon_inodes.c between commit 24b0303e9532 ("take anon inode allocation
> > > to libfs.c") from the vfs tree and commit 02f3ac4386d9 ("anon_inodefs:
> > > forbid open via /proc") from the akpm-current tree.
> > >
> > > I just dropped the akpm-current changes for today - they should probably
> > > be applied to fs/libfs.c.
> >
> > Well, this probably means that
> >
> > 	anon_inodefs-forbid-open-via-proc.patch
> >
> > should be dropped. I'll rediff this patch against vfs.git
>
> 24b0303e9532 also removes anon_inode_fops. It seems that it was not really
> needed anyway, inode_init_always() does inode->i_fop = empty_fops...
>
> So probably we can simply change empty_fops but I need to recheck.

Well. It looks "really obvious" that any user of inode_init_always()
either needs to change ->i_fop or this file should not be opened via
/proc...

So, Al, feel free to ignore, this is minor. Still I think this patch
makes sense. Based on vfs.git#for-next.

Oleg.

