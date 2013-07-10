Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3GJW5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:57:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3GJW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:57:31 -0400
Date: Wed, 10 Jul 2013 15:57:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, oliver+list@schinagl.nl, khali@linux-fr.org
Subject: Re: [PATCH 2/6] sysfs.h: add ATTRIBUTE_GROUPS() macro
Message-ID: <20130710225730.GA13441@kroah.com>
References: <20130710224856.GA21305@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710224856.GA21305@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 03:48:56PM -0700, Guenter Roeck wrote:
> On Wed, Jul 10, 2013 at 01:05:10PM -0700, Greg Kroah-Hartman wrote:
> > To make it easier for driver subsystems to work with attribute groups,
> > create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
> > typing for the most common use for attribute groups.
> > 
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  include/linux/sysfs.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> > index 9cd20c8..f62ff01 100644
> > --- a/include/linux/sysfs.h
> > +++ b/include/linux/sysfs.h
> > @@ -94,6 +94,15 @@ struct attribute_group {
> >  #define __ATTR_IGNORE_LOCKDEP	__ATTR
> >  #endif
> >  
> > +#define ATTRIBUTE_GROUPS(name)					\
> 
> Would it be possible to add is_visible as additional argument ?

I thought about the other options (multiple groups, is_visible, and
bin_attrs), but those are almost all not the "normal" usage, so I figure
it's worth the extra 6 lines of text if you want to support is_visible
or binary attributes.

After converting all of the class code to use groups, it seems to match
up with the defaults, but if in the future it's more popular than
expected, I'll gladly add it.

thanks,

greg k-h
