Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3H0GTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:19:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3H0GTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:19:18 -0400
Date: Mon, 26 Aug 2013 23:21:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rmk+kernel@arm.linux.org.uk
Subject: Re: [RFC PATCH v2 next]module: Fix mod->mkobj.kobj potentially freed
 too early
Message-ID: <20130827062135.GA3395@kroah.com>
References: <1377078598.2709.25.camel@ThinkPad-T5421>
 <20130821161819.GA14364@kroah.com>
 <1377138846.2633.25.camel@ThinkPad-T5421>
 <20130822040333.GB4821@kroah.com>
 <1377157075.2633.63.camel@ThinkPad-T5421>
 <20130825040734.GA18107@kroah.com>
 <87bo4jd9z0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo4jd9z0.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:08:27PM +0930, Rusty Russell wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> > On Thu, Aug 22, 2013 at 03:37:55PM +0800, Li Zhong wrote:
> >> DEBUG_KOBJECT_RELEASE helps to find the issue attached below.
> > People are starting to hit these types of issues, and I'd like to take
> > this one out of the picture.
> >
> > Rusty, any objection to me taking this through my driver-core tree,
> > where this new config option shows up?
> 
> The original fix was better.
> 
> Moving the module_kobject out and giving it its own lifetime solves this
> immediate issue, but it still means there's an accessible module_kobject
> around referring to a module which doesn't exist any more.

That's ok, it could happen before as well.  What's wrong with that?

> Original copied below, feel free to take it.

You are just sitting and sleeping until someone drops the last reference
to the module.  What if userspace grabs a reference from sysfs?  That
could never return, I don't think you want to stall that out.

I'd prefer not having 2 things determining the lifecycle of a single
object, that's messy, and not needed at all.

thanks,

greg k-h
