Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3GKAPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:15:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GKAPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:15:30 -0400
Date: Wed, 10 Jul 2013 17:15:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH 5/6] sysfs: add support for binary attributes in groups
Message-ID: <20130711001529.GA1578@kroah.com>
References: <20130710230057.GA16510@roeck-us.net>
 <20130710235928.GA663@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710235928.GA663@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:59:28PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Jul 10, 2013 at 04:00:57PM -0700, Guenter Roeck wrote:
> > > +	for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++) {
> > 
> > What happens here if grp->bin_attrs is NULL ? Doesn't that cause a NULL
> > reference when accessing *bin_attr ?
> > 
> > [ The problem didn't exist before since attr was supposed to be non-NULL.
> >   It may now be a problem if only bin_attr is provided, ie if there are
> >   only binary attribute files.
> >   Or maybe I am just tired and there is no problem... ]
> 
> I thought I tested this patch out, but I think you are right, let me go
> do a rebuild and test it again...

You were right, good catch, as-is, the kernel dies at boot, I've fixed
this and will resend the series, thanks so much for the review.

greg k-h
