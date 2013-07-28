Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3G1S11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 14:27:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3G1S1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 14:27:22 -0400
Date: Sun, 28 Jul 2013 11:27:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 71/79] ext4: fix error handling in ext4_ext_truncate()
Message-ID: <20130728182721.GB16560@kroah.com>
References: <20130726204721.849052763@linuxfoundation.org>
 <20130726204730.256399621@linuxfoundation.org>
 <1374960811.3607.15.camel@deadeye.wl.decadent.org.uk>
 <20130728114053.GA19995@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130728114053.GA19995@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 07:40:53AM -0400, Theodore Ts'o wrote:
> On Sat, Jul 27, 2013 at 10:33:31PM +0100, Ben Hutchings wrote:
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -4386,9 +4386,20 @@ void ext4_ext_truncate(handle_t *handle,
> > >  
> > >  	last_block = (inode->i_size + sb->s_blocksize - 1)
> > >  			>> EXT4_BLOCK_SIZE_BITS(sb);
> > > +retry:
> > >  	err = ext4_es_remove_extent(inode, last_block,
> > >  				    EXT_MAX_BLOCKS - last_block);
> > > +	if (err == ENOMEM) {
> > 
> > Positive ENOMEM?!  It looks like this value is bubbled up from
> > __es_insert_extent() which returns the usual negative error codes.
> 
> Nice catch.  Yup, that's a problem.  I'll fix this upstream and mark
> it cc:stable.
> 
> Until this goes upstream stable kernel maintainers can either: (a) fix
> up this patch by making the line read "err == -ENOMEM", (b) hold back
> this patch until the companion patch to fix this goes upstream, or (c)
> apply this now, since it's otherwise harmless and it does add error
> checking to the ext4_ext_remove_space() call.

I'll take it as-is and expect to see the fix come through Linus's tree
soon.

thanks,

greg k-h
