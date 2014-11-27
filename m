Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaK0QWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:22:20 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43752 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbaK0QWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:22:19 -0500
X-Sasl-enc: UWsT6cIF57UU3Ch+zLuZ7KdlLQK3QU7me30Gc9dApwef 1417105338
Date: Thu, 27 Nov 2014 08:20:56 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the staging tree with the vfs tree
Message-ID: <20141127162056.GB30533@kroah.com>
References: <20141127201156.62487051@canb.auug.org.au>
 <20141127203101.346ea550@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127203101.346ea550@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 08:31:01PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> On Thu, 27 Nov 2014 20:11:56 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > diff --cc drivers/staging/lustre/lustre/llite/llite_lib.c
> > index 7b6b9e2e0102,3b0336029da3..000000000000
> > --- a/drivers/staging/lustre/lustre/llite/llite_lib.c
> > +++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
> > @@@ -698,8 -690,10 +690,8 @@@ void lustre_dump_dentry(struct dentry *
> >   	list_for_each(tmp, &dentry->d_subdirs)
> >   		subdirs++;
> >   
> > - 	CERROR("dentry %p dump: name=%pd parent=%p, inode=%p, count=%u,"
> > - 	       " flags=0x%x, fsdata=%p, %d subdirs\n", dentry, dentry,
> >  -	CERROR("dentry %p dump: name=%.*s parent=%.*s (%p), inode=%p, count=%u, flags=0x%x, fsdata=%p, %d subdirs\n",
> >  -	       dentry,
> >  -	       dentry->d_name.len, dentry->d_name.name,
> >  -	       dentry->d_parent->d_name.len, dentry->d_parent->d_name.name,
> > ++	CERROR("dentry %p dump: name=%pd parent=%p, inode=%p, count=%u, flags=0x%x, fsdata=%p, %d subdirs\n",
> > ++	       dentry, dentry,
> >   	       dentry->d_parent, dentry->d_inode, d_count(dentry),
> >   	       dentry->d_flags, dentry->d_fsdata, subdirs);
> >   	if (dentry->d_inode != NULL)
> 
> The actual resolution for this file ended up being this:
> 
> diff --cc drivers/staging/lustre/lustre/llite/llite_lib.c
> index 7b6b9e2e0102,3b0336029da3..52f0a7e40063
> --- a/drivers/staging/lustre/lustre/llite/llite_lib.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
> @@@ -698,8 -690,10 +690,8 @@@ void lustre_dump_dentry(struct dentry *
>   	list_for_each(tmp, &dentry->d_subdirs)
>   		subdirs++;
>   
> - 	CERROR("dentry %p dump: name=%pd parent=%p, inode=%p, count=%u,"
> - 	       " flags=0x%x, fsdata=%p, %d subdirs\n", dentry, dentry,
>  -	CERROR("dentry %p dump: name=%.*s parent=%.*s (%p), inode=%p, count=%u, flags=0x%x, fsdata=%p, %d subdirs\n",
>  -	       dentry,
>  -	       dentry->d_name.len, dentry->d_name.name,
>  -	       dentry->d_parent->d_name.len, dentry->d_parent->d_name.name,
> ++	CERROR("dentry %p dump: name=%pd parent=%p, inode=%p, count=%u, flags=0x%x, fsdata=%p, %d subdirs\n",
> ++	       dentry, dentry,
>   	       dentry->d_parent, dentry->d_inode, d_count(dentry),
>   	       dentry->d_flags, dentry->d_fsdata, subdirs);
>   	if (dentry->d_inode != NULL)
> @@@ -709,7 -703,8 +701,8 @@@
>   		return;
>   
>   	list_for_each(tmp, &dentry->d_subdirs) {
>  -		struct dentry *d = list_entry(tmp, struct dentry, d_u.d_child);
>  +		struct dentry *d = list_entry(tmp, struct dentry, d_child);
> + 
>   		lustre_dump_dentry(d, recur - 1);
>   	}
>   }

Looks good, thanks.

greg k-h
