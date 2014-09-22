Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaIVVQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbaIVVQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:16:18 -0400
Message-ID: <1411420555.1199.151.camel@ul30vt.home>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: C =?ISO-8859-1?Q?Bergstr=F6m?= <cbergstrom@pathscale.com>,
        David Airlie <airlied@linux.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 15:15:55 -0600
In-Reply-To: <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
	 <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 13:43 -0700, Linus Torvalds wrote:
> Adding proper people and mailing lists..
> 
> The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
> BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
> appropriate, but hopefully somebody does. The fact that it makes
> things work certainly argues fairly convincingly for it, but I want
> some backup here.
> 
> Dave, BenH?

TBH, it seems pretty dubious to me.  There's nothing in the spec that
would give us reason to believe that a device with a 3D controller class
code requires VGA arbitration.  Also, if this controller starts
participating in arbitration then this same laptop will likely disable
DRI when Intel is the primary graphics due to Xorg wanting to mmap VGA
MMIO space.  I'm not sure what the solution is, but unfortunately it's
likely to be much more complicated than this patch.  Thanks,

Alex

> Christopher(?), can you please also specify which laptop etc. And the
> patch itself seems to have come from somebody else, unless you're
> Lekensteyn. So we'd want to get the provenance of that too.
> 
>                 Linus
> 
> On Mon, Sep 22, 2014 at 1:28 PM, C Bergström <cbergstrom@pathscale.com> wrote:
> > Hi Linus,
> >
> > I don't know who the original author is and I can have one of the distro
> > graphics friends review it, but I need this patch below to get NVIDIA
> > drivers to work (without using any Intel graphics) on my laptop
> > http://pastebin.com/wpmFi38k
> >
> > Sorry - I know this is not the proper way to submit a patch, but it's
> > trivial and I'm not a kernel dev.
> >
> > Thanks
> >
> > ./C



