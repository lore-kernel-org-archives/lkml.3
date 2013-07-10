Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3GJX7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:59:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3GJX73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:59:29 -0400
Date: Wed, 10 Jul 2013 16:59:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH 5/6] sysfs: add support for binary attributes in groups
Message-ID: <20130710235928.GA663@kroah.com>
References: <20130710230057.GA16510@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710230057.GA16510@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:00:57PM -0700, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 01:05:13PM -0700, Greg Kroah-Hartman wrote:
> > @@ -52,6 +55,17 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
> >  	}
> >  	if (error)
> >  		remove_files(dir_sd, kobj, grp);
> 
> You might want to abort here if there was an error.

Good point, I'll update it.

> > +
> > +	for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++) {
> 
> What happens here if grp->bin_attrs is NULL ? Doesn't that cause a NULL
> reference when accessing *bin_attr ?
> 
> [ The problem didn't exist before since attr was supposed to be non-NULL.
>   It may now be a problem if only bin_attr is provided, ie if there are
>   only binary attribute files.
>   Or maybe I am just tired and there is no problem... ]

I thought I tested this patch out, but I think you are right, let me go
do a rebuild and test it again...

thanks,

greg k-h
