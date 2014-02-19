Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaBTFty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 00:49:54 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:1912 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbaBTFtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 00:49:52 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswVAKCWBVNXQzWw/2dsb2JhbABZKIJewQUCAoEUF3SCJQEBBAEnExwjBQsIAw4KLjkeBhOHfQwBzh8XjmQHhDgBA4lGhHqJbwGSJIM6Lw
Date: Thu, 20 Feb 2014 05:51:15 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fs: xattr: Don't display attributes without read
 access
Message-Id: <20140220055115.9cf0cf8200efa03f1136b642@skynet.be>
In-Reply-To: <20140218151650.02fb2d6034deb2d3d11ccc7a@linux-foundation.org>
References: <20140216203101.bf432a8b7b40703197a91462@skynet.be>
	<20140218151650.02fb2d6034deb2d3d11ccc7a@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 15:16:50 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 16 Feb 2014 20:31:01 +0800 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > Any user can display extented attribute names without read
> > access.
> > 
> > eg: attr -l <filename>
> > 
> > This patch checks inode_permission in listxattr common
> > function before executing vfs_listxattr.
> > 
> > ...
> >
> > --- a/fs/xattr.c
> > +++ b/fs/xattr.c
> > @@ -543,6 +543,10 @@ listxattr(struct dentry *d, char __user *list, size_t size)
> >  	char *klist = NULL;
> >  	char *vlist = NULL;	/* If non-NULL, we used vmalloc() */
> >  
> > +	error = inode_permission(d->d_inode, MAY_READ);
> > +	if (error)
> > +		return error;
> > +
> >  	if (size) {
> >  		if (size > XATTR_LIST_MAX)
> >  			size = XATTR_LIST_MAX;
> 
> erk.  Doesn't this mean that if existing userspace is relying on the
> current behaviour, this patch will cause breakage?
> 
FYI, I just noticed FreeBSD was giving the expected result : no attribute name revealed
 without read access .... 
