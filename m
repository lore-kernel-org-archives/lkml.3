Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaFDL13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:27:29 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42296 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaFDL12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:27:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140530160831.GA11182@kroah.com>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
 <20140528205145.GB10468@kroah.com> <20140530081504.GA16669@ulmo> <20140530160831.GA11182@kroah.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 4 Jun 2014 16:57:07 +0530
Message-ID: <CAO_48GE_Y7DQj_nCZ=0gb_AY26_vtPsQybf9zuhsLW1nnaOuQw@mail.gmail.com>
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,


On 30 May 2014 21:38, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Fri, May 30, 2014 at 10:15:05AM +0200, Thierry Reding wrote:
>> On Wed, May 28, 2014 at 01:51:45PM -0700, Greg Kroah-Hartman wrote:
>> > On Wed, May 28, 2014 at 04:26:32PM +0200, Thierry Reding wrote:
>> > > From: Thierry Reding <treding@nvidia.com>
>> > >
>> > > Commit febdbfe8a91c (arch: Prepare for smp_mb__{before,after}_atomic())
>> > > deprecated the smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}*()
>> > > functions in favour of the unified smp_mb__{before,after}_atomic().
>> > >
>> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
>> > > ---
>> > >  drivers/base/fence.c | 4 ++--
>> >
>> > Where does this file come from?  I've not seen it before, and it's not
>> > in my tree.
>>
>> I think it came in through Sumit's tree and it's only in linux-next I
>> believe.
>
> Odd, linux-next is for merging things in Linus's next release.
>
> And as I have never seen this code that will end up being my
> responsibility to maintain, it seems strange that it will be merged in
> the next kernel development cycle.
>
> What broke down here with our review process that required something to
> be merged without at least a cc: to me?

This is a new file added by Maarten's patches [1], that got reviewed
on dri-devel and other mailing lists. Since it was quite closely
associated with dma-buf, I figured I should take it through the
dma-buf tree.

I am sorry I didn't notice that you weren't CC'ed on these patches -
Sincere apologies, since I should've noticed that during the patch
review process - I would take part of the blame here as well  :(

I do realize now that atleast on my part, I should've asked you before
taking it through the dma-buf tree - I will make sure things like this
don't happen again through me.

May I request you to help us handle this - would it help if we add
Maarten as the maintainer for this file? Any other suggestions?

>
> greg k-h

Best regards,
~Sumit.

[1]: https://lkml.org/lkml/2014/2/24/824
