Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3IPX2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:28:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56720 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3IPX2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:28:15 -0400
Date: Tue, 17 Sep 2013 00:28:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        "M. Mohan Kumar" <mohan@in.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/11] 9p: fix dentry leak in v9fs_vfs_atomic_open_dotl()
Message-ID: <20130916232810.GG13318@ZenIV.linux.org.uk>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
 <1379335925-30858-3-git-send-email-miklos@szeredi.hu>
 <20130916181938.GD13318@ZenIV.linux.org.uk>
 <CAJfpegt3mAKVE7ToZbvPpFQCY1EAZ3tKfn__kfpGz4HeXWr8fw@mail.gmail.com>
 <20130916195003.GE13318@ZenIV.linux.org.uk>
 <CAJfpegsLeuw55Diw0yDmiFR+7qkSkOrW2fUbjmzFC9OxVsrAkQ@mail.gmail.com>
 <20130916220241.GF13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916220241.GF13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 11:02:41PM +0100, Al Viro wrote:
> On Mon, Sep 16, 2013 at 10:09:46PM +0200, Miklos Szeredi wrote:
> 
> > > I would definitely prefer EEXIST logics dealt with in fs/namei.c - if nothing
> > > else, it had been done wrong in too many instances...
> > 
> > Okay.
> 
> OK, so I'm taking 1, 5, 9, 10, 11, then add check to fs/namei.c:atomic_open(),
> leaving the rest of gfs2 ones for gfs2 tree...  Give me a few and I'll push
> that.

Pushed (head at d332c7).  That should cover 9p and fuse as well, AFAICS.
Do you have any problems with that variant?
