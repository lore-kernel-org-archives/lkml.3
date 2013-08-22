Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3HVQWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:22:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3HVQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:22:17 -0400
Date: Thu, 22 Aug 2013 09:22:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anthony Foiani <tkil@scrye.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: add sysfs_create/remove_groups()
Message-ID: <20130822162215.GA29922@kroah.com>
References: <20130821203506.GA1663@kroah.com>
 <5215254B.7000000@infradead.org>
 <20130821204750.GB4546@kroah.com>
 <g38q2l3yg.fsf@dworkin.scrye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g38q2l3yg.fsf@dworkin.scrye.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:55:19PM -0600, Anthony Foiani wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
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
> > + * Returns 0 on success or error code from sysfs_create_groups on error.
> 
> "... from sysfs_create_group on error"
>                        ^^^^^ (note singular, not plural)
> 
> Otherwise it's a bit of a tautology...

Ah, thanks, will fix that up.

> Maybe rename to "sysfs_(create|remove)_multiple_groups" (or
> ..._many_groups) to avoid this kind of one-char difference?

Nah, terse is good :)

> > + * sysfs_remove_groups - remove a list of groups
> > + *
> > + * kobj:	The kobject for the groups to be removed from
> > + * groups:	NULL terminated list of groups to be removed
> > + *
> > + * If groups is not NULL, the all groups will be removed from the kobject
> 
> "If groups is not NULL, remove listed groups from the kobject"

Nice, will go fix it up now, thanks.

> (I also played around with using pointer arithmetic instead of array
> accesses for these two functions; it cut a few lines of code, but not
> enough to bother, I don't think.)

Yeah, it's better to not be "tricky" so that others can review the code
easier, and the end result would be the same.

thanks for the review.

greg k-h
