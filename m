Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaFSSPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:15:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbaFSSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:15:18 -0400
Date: Thu, 19 Jun 2014 11:19:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rob Clark <robdclark@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>, Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization
 (v17)
Message-ID: <20140619181918.GA24155@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
 <20140618103653.15728.4942.stgit@patser>
 <20140619011327.GC10921@kroah.com>
 <CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com>
 <20140619170059.GA1224@kroah.com>
 <CAF6AEGuXKw1w=outX+QgFE2XZxV8c6pyhORL+mRp4uZR8Jnq7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGuXKw1w=outX+QgFE2XZxV8c6pyhORL+mRp4uZR8Jnq7g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 01:45:30PM -0400, Rob Clark wrote:
> On Thu, Jun 19, 2014 at 1:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jun 19, 2014 at 10:00:18AM -0400, Rob Clark wrote:
> >> On Wed, Jun 18, 2014 at 9:13 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > On Wed, Jun 18, 2014 at 12:36:54PM +0200, Maarten Lankhorst wrote:
> >> >> +#define CREATE_TRACE_POINTS
> >> >> +#include <trace/events/fence.h>
> >> >> +
> >> >> +EXPORT_TRACEPOINT_SYMBOL(fence_annotate_wait_on);
> >> >> +EXPORT_TRACEPOINT_SYMBOL(fence_emit);
> >> >
> >> > Are you really willing to live with these as tracepoints for forever?
> >> > What is the use of them in debugging?  Was it just for debugging the
> >> > fence code, or for something else?
> >> >
> >> >> +/**
> >> >> + * fence_context_alloc - allocate an array of fence contexts
> >> >> + * @num:     [in]    amount of contexts to allocate
> >> >> + *
> >> >> + * This function will return the first index of the number of fences allocated.
> >> >> + * The fence context is used for setting fence->context to a unique number.
> >> >> + */
> >> >> +unsigned fence_context_alloc(unsigned num)
> >> >> +{
> >> >> +     BUG_ON(!num);
> >> >> +     return atomic_add_return(num, &fence_context_counter) - num;
> >> >> +}
> >> >> +EXPORT_SYMBOL(fence_context_alloc);
> >> >
> >> > EXPORT_SYMBOL_GPL()?  Same goes for all of the exports in here.
> >> > Traditionally all of the driver core exports have been with this
> >> > marking, any objection to making that change here as well?
> >>
> >> tbh, I prefer EXPORT_SYMBOL()..  well, I'd prefer even more if there
> >> wasn't even a need for EXPORT_SYMBOL_GPL(), but sadly it is a fact of
> >> life.  We already went through this debate once with dma-buf.  We
> >> aren't going to change $evil_vendor's mind about non-gpl modules.  The
> >> only result will be a more flugly convoluted solution (ie. use syncpt
> >> EXPORT_SYMBOL() on top of fence EXPORT_SYMBOL_GPL()) just as a
> >> workaround, with the result that no-one benefits.
> >
> > It has been proven that using _GPL() exports have caused companies to
> > release their code "properly" over the years, so as these really are
> > Linux-only apis, please change them to be marked this way, it helps
> > everyone out in the end.
> 
> Well, maybe that is the true in some cases.  But it certainly didn't
> work out that way for dma-buf.  And I think the end result is worse.
> 
> I don't really like coming down on the side of EXPORT_SYMBOL() instead
> of EXPORT_SYMBOL_GPL(), but if we do use EXPORT_SYMBOL_GPL() then the
> result will only be creative workarounds using the _GPL symbols
> indirectly by whatever is available via EXPORT_SYMBOL().  I don't
> really see how that will be better.

You are saying that you _know_ companies will violate our license, so
you should just "give up"?  And how do you know people aren't working on
preventing those "indirect" usages as well?  :)

Sorry, I'm not going to give up here, again, it has proven to work in
the past in changing the ways of _very_ large companies, why stop now?

thanks,

greg k-h
