Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab3FTKwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:52:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51559 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3FTKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:52:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130619143753.GA8413@kroah.com>
References: <20130619181031.8b53acc44466ba70a47e1fcd@canb.auug.org.au>
 <CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com> <20130619143753.GA8413@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Thu, 20 Jun 2013 18:52:19 +0800
Message-ID: <CA+a=Yy77RmCDNZwxW4X_SbTWZKhssZ+nrCxSMCP3c1fkzLRqOw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:37 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Jun 19, 2013 at 05:26:57PM +0800, Peng Tao wrote:
>> On Wed, Jun 19, 2013 at 4:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi all,
>> >
>> > After merging the final tree, today's linux-next build (powerpc
>> > allyesconfig) failed like this:
>> >
>> > In file included from drivers/staging/lustre/include/linux/libcfs/libcfs.h:203:0,
>> >                  from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:67,
>> >                  from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:41:
>> > drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_dev_need_failover':
>> > drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:215:16: error: implicit declaration of function 'NIPQUAD' [-Werror=implicit-function-declaration]
>> >   static struct libcfs_debug_msg_data msgdata;      \
>> >                 ^
>> Thanks for reporting!
>>
>> It is a bug in Lustre code that it is missing NIPQUAD definition on
>> Linux platform. I will send fix later.
>>
>> > drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:231:2: note: in expansion of macro '__CDEBUG'
>> >   __CDEBUG(&cdls, mask, format, ## __VA_ARGS__);\
>> >   ^
>> > drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:238:30: note: in expansion of macro 'CDEBUG_LIMIT'
>> >  #define CERROR(format, ...)  CDEBUG_LIMIT(D_ERROR, format, ## __VA_ARGS__)
>> >                               ^
>> > drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:2577:3: note: in expansion of macro 'CERROR'
>> >    CERROR("Failed to bind %s:%u.%u.%u.%u to device(%p): %d\n",
>> >    ^
>> >
>> > I have once again disabled the building og the lustre client code.
>> >
>> Sorry that Lustre is mostly tested only on x86 platform (and sadly I
>> don't have other architectures to test on.). We sincerely thank you
>> for your continuous help.
>
> You can always use a ppc cross compiler for just the kernel build tests
> to catch things like this.
>
Thanks for the suggestion. I've set up cross compiler for powerpc and
found a few more bugs. Will send patches to fix them later.

Cheers,
Tao
