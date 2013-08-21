Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3HUUoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:44:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3HUUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:44:10 -0400
Date: Wed, 21 Aug 2013 13:44:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: add sysfs_create/remove_groups()
Message-ID: <20130821204408.GA4546@kroah.com>
References: <20130821203506.GA1663@kroah.com>
 <5215254B.7000000@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215254B.7000000@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 01:38:35PM -0700, Randy Dunlap wrote:
> On 08/21/13 13:35, Greg Kroah-Hartman wrote:
> > 
> > --- a/fs/sysfs/group.c
> > +++ b/fs/sysfs/group.c
> > @@ -131,6 +131,39 @@ int sysfs_create_group(struct kobject *k
> >  }
> >  
> >  /**
> > + * sysfs_create_groups - given a directory kobject, create a bunch of attribute groups
> > + * @kobj:	The kobject to create the group on
> > + * @groups:	The attribute groups to create, NULL terminated
> > + *
> > + * This function creates a bunch of attribute groups.  If an error occurs when
> > + * creating a group, all previously created groups will be removed, unwinding
> > + * everything back to the original state when this function was called.
> > + * It will explicitly warn and error if any of the attribute files being
> > + * created already exist.
> > + *
> > + * Returns 0 on success or error.
> 
> ambiguous.  How about:
>       Returns 0 on success or error code on error.

Ok, I also forgot to export these symbols, so I'll go do a v2 of the
patch, thanks for the review.

greg k-h
