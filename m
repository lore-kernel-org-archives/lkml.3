Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaIXBzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:55:47 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:45565 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIXBzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:55:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAOnawYp4QLq+k9__BKcAapHQyShYa93B9S7rbt30Jv3z+Dm9XA@mail.gmail.com>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
	<CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
	<1411420555.1199.151.camel@ul30vt.home>
	<CAOnawYp4QLq+k9__BKcAapHQyShYa93B9S7rbt30Jv3z+Dm9XA@mail.gmail.com>
Date: Tue, 23 Sep 2014 21:55:45 -0400
Message-ID: <CADnq5_MXWn0BZHMuwp13gdctmvkKMcf4Q5hamhLjxVUN2GeWbw@mail.gmail.com>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
From: Alex Deucher <alexdeucher@gmail.com>
To: =?UTF-8?B?QyBCZXJnc3Ryw7Zt?= <cbergstrom@pathscale.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 5:20 PM, C Bergström <cbergstrom@pathscale.com> wrote:
> For clarity - My testing and the patch is required when the Intel driver
> isn't being used at all. After I finish some other testing I can see if
> bumblebee and intel driver + this patch will play nicely.
>
> How is a laptop with dual VGA controllers any different than if one
> identifies itself as a "3D controller"?
>

I'm not familiar with nvidia hw, but some newer AMD asics don't have
any vga hw at all so they would have no need to have vga routed to
them ever.

Alex

> On Tue, Sep 23, 2014 at 4:15 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
>>
>> On Mon, 2014-09-22 at 13:43 -0700, Linus Torvalds wrote:
>> > Adding proper people and mailing lists..
>> >
>> > The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
>> > BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
>> > appropriate, but hopefully somebody does. The fact that it makes
>> > things work certainly argues fairly convincingly for it, but I want
>> > some backup here.
>> >
>> > Dave, BenH?
>>
>> TBH, it seems pretty dubious to me.  There's nothing in the spec that
>> would give us reason to believe that a device with a 3D controller class
>> code requires VGA arbitration.  Also, if this controller starts
>> participating in arbitration then this same laptop will likely disable
>> DRI when Intel is the primary graphics due to Xorg wanting to mmap VGA
>> MMIO space.  I'm not sure what the solution is, but unfortunately it's
>> likely to be much more complicated than this patch.  Thanks,
>>
>> Alex
>>
>> > Christopher(?), can you please also specify which laptop etc. And the
>> > patch itself seems to have come from somebody else, unless you're
>> > Lekensteyn. So we'd want to get the provenance of that too.
>> >
>> >                 Linus
>> >
>> > On Mon, Sep 22, 2014 at 1:28 PM, C Bergström <cbergstrom@pathscale.com>
>> > wrote:
>> > > Hi Linus,
>> > >
>> > > I don't know who the original author is and I can have one of the
>> > > distro
>> > > graphics friends review it, but I need this patch below to get NVIDIA
>> > > drivers to work (without using any Intel graphics) on my laptop
>> > > http://pastebin.com/wpmFi38k
>> > >
>> > > Sorry - I know this is not the proper way to submit a patch, but it's
>> > > trivial and I'm not a kernel dev.
>> > >
>> > > Thanks
>> > >
>> > > ./C
>>
>>
>>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
