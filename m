Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3IPN4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:56:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab3IPN4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:56:22 -0400
Subject: Re: [PATCH 06/11] gfs2: d_splice_alias() cant return error
From: Steven Whitehouse <swhiteho@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz, stable@vger.kernel.org
In-Reply-To: <20130916133559.GB31733@tucsk.piliscsaba.szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
	 <1379335925-30858-7-git-send-email-miklos@szeredi.hu>
	 <1379337469.2718.18.camel@menhir>
	 <20130916133559.GB31733@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 16 Sep 2013 14:56:28 +0100
Message-ID: <1379339788.2718.23.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2013-09-16 at 15:35 +0200, Miklos Szeredi wrote:
> On Mon, Sep 16, 2013 at 02:17:49PM +0100, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Mon, 2013-09-16 at 14:52 +0200, Miklos Szeredi wrote:
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > unless it was given an IS_ERR(inode), which isn't the case here.  So clean
> > > up the unnecessary error handling in gfs2_create_inode().
> > > 
> > > This paves the way for real fixes (hence the stable Cc).
> > > 
> > That makes send to me:
> > 
> > Acked-by: Steven Whitehouse <swhiteho@redhat.com>
> > 
> > I can put this in the gfs2 tree if that makes sense to do,
> 
> Sure, please do.
> 
> Thanks,
> Miklos
> 
Ok. I'll add the patches shortly. I need to try and wrap my brain around
patch 8 too,

Steve.

> 
> > Steve.
> > 
> > > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > > Cc: Steven Whitehouse <swhiteho@redhat.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  fs/gfs2/inode.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> > > index 64915ee..6d7f976 100644
> > > --- a/fs/gfs2/inode.c
> > > +++ b/fs/gfs2/inode.c
> > > @@ -584,7 +584,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
> > >  	if (!IS_ERR(inode)) {
> > >  		d = d_splice_alias(inode, dentry);
> > >  		error = 0;
> > > -		if (file && !IS_ERR(d)) {
> > > +		if (file) {
> > >  			if (d == NULL)
> > >  				d = dentry;
> > >  			if (S_ISREG(inode->i_mode))
> > > @@ -593,8 +593,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
> > >  				error = finish_no_open(file, d);
> > >  		}
> > >  		gfs2_glock_dq_uninit(ghs);
> > > -		if (IS_ERR(d))
> > > -			return PTR_ERR(d);
> > >  		return error;
> > >  	} else if (error != -ENOENT) {
> > >  		goto fail_gunlock;
> > 
> > 


