Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaFEV4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:56:20 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56239 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFEV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:56:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140605154831.GA23993@kroah.com>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
	<20140528205145.GB10468@kroah.com>
	<20140530081504.GA16669@ulmo>
	<20140530160831.GA11182@kroah.com>
	<CAO_48GE_Y7DQj_nCZ=0gb_AY26_vtPsQybf9zuhsLW1nnaOuQw@mail.gmail.com>
	<20140604132831.GC28484@ulmo>
	<20140604174902.GC20812@kroah.com>
	<CAF6AEGuaURm-AHHh6G=HnJYFLUWBhPOxKaBQCqn-=-9CQdKe8w@mail.gmail.com>
	<20140605154831.GA23993@kroah.com>
Date: Thu, 5 Jun 2014 17:56:16 -0400
Message-ID: <CAF6AEGvhQfwz90vh9tsz4wHR9WGA1Bg1D5mpT8YkY0Cf172Dqw@mail.gmail.com>
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
From: Rob Clark <robdclark@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 11:48 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 05, 2014 at 07:51:10AM -0400, Rob Clark wrote:
>> On Wed, Jun 4, 2014 at 1:49 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Wed, Jun 04, 2014 at 03:28:33PM +0200, Thierry Reding wrote:
>> >> On Wed, Jun 04, 2014 at 04:57:07PM +0530, Sumit Semwal wrote:
>> >> > Hi Greg,
>> >> >
>> >> >
>> >> > On 30 May 2014 21:38, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>> >> > > On Fri, May 30, 2014 at 10:15:05AM +0200, Thierry Reding wrote:
>> >> > >> On Wed, May 28, 2014 at 01:51:45PM -0700, Greg Kroah-Hartman wrote:
>> >> > >> > On Wed, May 28, 2014 at 04:26:32PM +0200, Thierry Reding wrote:
>> >> > >> > > From: Thierry Reding <treding@nvidia.com>
>> >> > >> > >
>> >> > >> > > Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
>> >> > >> > > deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
>> >> > >> > > functions in favour of the unified smp_mb__{before,after}_atomic().
>> >> > >> > >
>> >> > >> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
>> >> > >> > > ---
>> >> > >> > >  drivers/base/fence.c | 4 ++--
>> >> > >> >
>> >> > >> > Where does this file come from?  I've not seen it before, and it's not
>> >> > >> > in my tree.
>> >> > >>
>> >> > >> I think it came in through Sumit's tree and it's only in linux-next I
>> >> > >> believe.
>> >> > >
>> >> > > Odd, linux-next is for merging things in Linus's next release.
>> >> > >
>> >> > > And as I have never seen this code that will end up being my
>> >> > > responsibility to maintain, it seems strange that it will be merged in
>> >> > > the next kernel development cycle.
>> >> > >
>> >> > > What broke down here with our review process that required something to
>> >> > > be merged without at least a cc: to me?
>> >> >
>> >> > This is a new file added by Maarten's patches [1], that got reviewed
>> >> > on dri-devel and other mailing lists. Since it was quite closely
>> >> > associated with dma-buf, I figured I should take it through the
>> >> > dma-buf tree.
>> >> >
>> >> > I am sorry I didn't notice that you weren't CC'ed on these patches -
>> >> > Sincere apologies, since I should've noticed that during the patch
>> >> > review process - I would take part of the blame here as well  :(
>> >> >
>> >> > I do realize now that atleast on my part, I should've asked you before
>> >> > taking it through the dma-buf tree - I will make sure things like this
>> >> > don't happen again through me.
>> >> >
>> >> > May I request you to help us handle this - would it help if we add
>> >> > Maarten as the maintainer for this file? Any other suggestions?
>> >>
>> >> Perhaps something like the following would help?
>> >>
>> >> diff --git a/MAINTAINERS b/MAINTAINERS
>> >> index fb39c9c3f0c1..d582f54adec8 100644
>> >> --- a/MAINTAINERS
>> >> +++ b/MAINTAINERS
>> >> @@ -2867,7 +2867,9 @@ L:        linux-media@vger.kernel.org
>> >>  L:   dri-devel@lists.freedesktop.org
>> >>  L:   linaro-mm-sig@lists.linaro.org
>> >>  F:   drivers/base/dma-buf*
>> >> +F:   drivers/base/fence.c
>> >>  F:   include/linux/dma-buf*
>> >> +F:   include/linux/fence.h
>> >>  F:   Documentation/dma-buf-sharing.txt
>> >>  T:   git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
>> >> @@ -2936,6 +2938,8 @@ T:        git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
>> >>  S:   Supported
>> >>  F:   Documentation/kobject.txt
>> >>  F:   drivers/base/
>> >> +X:   drivers/base/dma-buf*
>> >> +X:   drivers/base/fence.c
>> >>  F:   fs/sysfs/
>> >>  F:   fs/debugfs/
>> >>  F:   include/linux/kobj*
>> >>
>> >> That removes Greg from the list generated by get_maintainer.pl for
>> >> anything that touches the DMA-BUF files.
>> >
>> > That doesn't really work for most people, I'll still be "responsible"
>> > for the code.
>> >
>> >> Thinking about it, perhaps moving DMA-BUF into its own subdirectory
>> >> would be an option too, to make the separation more obvious.
>> >
>> > That might be best for some of this.
>> >
>> > But again, why is the fence.c code needed at all anyway?  I'm not sold
>> > on that.
>>
>> Fence serves as a way to synchronize between (for example) multiple
>> asynchronous gpu's.  There is definitely a need for this.  Otherwise
>> performance for optimus/prime type setups is going to suck.
>
> What's wrong with the 'sync' code in the drivers/staging/android/
> directory?  I thought that is what that codebase was supposed to be
> doing.

the 'explicit sync' approach of the android stuff really doesn't work
out well for x11 or wayland userspace

The current fence stuff from Maarten is the result of coming up with a
single mechanism that works both for "traditional" linux userspace,
which can also sit beneath the android stuff.  Not completely
dissimilar to dma-buf vs ION..

>> I thought we had added something under Documentation/ about it, but I
>> can't find it now (although possibly looking at the wrong trees)..
>> there is at least a bit of a description in the commit msg:
>>
>>   https://lkml.org/lkml/2014/2/24/602
>
> Ah, so no documenation, no discussion, and you want to just throw it in
> a directory I am responsible for?  That sounds like a major rush job...

well, I mean beyond the docbook/headerdoc stuff (of which there is
plenty for fence)

>> I don't think the question about whether we need something like fence
>> to augment dma-buf is really in doubt.  Maybe it should live somewhere
>> else, I'm not sure.  But it makes sense for it to live wherever
>> dma-buf does, as they are intended to work together.
>
> Ok, then let's give it a proper review cycle, and notify everyone
> involved.  It doesn't look like this happened at all.  We don't add core
> primitives to the kernel without a lot of discussion and agreement.  And
> we sure don't add them without telling the person who owns the directory
> (again, my pet peeve, I know...)

In this case, the only thing missing was the one who owned the
directory.  The discussions were CC'd to linux-media, dri-devel,
linaro-mm-sig, various android folks, linux-kernel... and discussed
and discussed and discussed ;-)

I think the only controversial thing is where the code lives.  Maybe
one week in is too late to be moving things, in which case fine, 3.17.
 But for such a superficial thing it seems a bit sad to let it slip
another cycle.

BR,
-R

> greg k-h
