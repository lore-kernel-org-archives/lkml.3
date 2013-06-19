Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841Ab3FSOhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:37:17 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57507 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934417Ab3FSOhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:37:15 -0400
X-Sasl-enc: 02/MOUFHEsmzVood9wrmR7jjNRdee6baEW4S9d701UbU 1371652632
Date: Wed, 19 Jun 2013 07:37:53 -0700
From: Greg KH <greg@kroah.com>
To: Peng Tao <bergwolf@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20130619143753.GA8413@kroah.com>
References: <20130619181031.8b53acc44466ba70a47e1fcd@canb.auug.org.au>
 <CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 05:26:57PM +0800, Peng Tao wrote:
> On Wed, Jun 19, 2013 at 4:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > In file included from drivers/staging/lustre/include/linux/libcfs/libcfs.h:203:0,
> >                  from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:67,
> >                  from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:41:
> > drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_dev_need_failover':
> > drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:215:16: error: implicit declaration of function 'NIPQUAD' [-Werror=implicit-function-declaration]
> >   static struct libcfs_debug_msg_data msgdata;      \
> >                 ^
> Thanks for reporting!
> 
> It is a bug in Lustre code that it is missing NIPQUAD definition on
> Linux platform. I will send fix later.
> 
> > drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:231:2: note: in expansion of macro '__CDEBUG'
> >   __CDEBUG(&cdls, mask, format, ## __VA_ARGS__);\
> >   ^
> > drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:238:30: note: in expansion of macro 'CDEBUG_LIMIT'
> >  #define CERROR(format, ...)  CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
> >                               ^
> > drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2577:3: note: in expansion of macro 'CERROR'
> >    CERROR("Failed to bind %s:%u.%u.%u.%u to device(%p): %d\n",
> >    ^
> >
> > I have once again disabled the building og the lustre client code.
> >
> Sorry that Lustre is mostly tested only on x86 platform (and sadly I
> don't have other architectures to test on.). We sincerely thank you
> for your continuous help.

You can always use a ppc cross compiler for just the kernel build tests
to catch things like this.

thanks,

greg k-h
