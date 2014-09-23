Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbaIWQbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:31:16 -0400
Received: from hygieia.santi-shop.eu ([78.46.175.2]:42905 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaIWQbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:31:13 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 12:31:13 EDT
Date: Tue, 23 Sep 2014 18:25:09 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: C =?UTF-8?B?QmVyZ3N0csO2bQ==?= <cbergstrom@pathscale.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
Message-ID: <20140923182509.46decd46@neptune.home>
In-Reply-To: <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
	<CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 September 2014 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Adding proper people and mailing lists..
> 
> The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
> BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
> appropriate, but hopefully somebody does. The fact that it makes
> things work certainly argues fairly convincingly for it, but I want
> some backup here.
> 
> Dave, BenH?
> 
> Christopher(?), can you please also specify which laptop etc. And the
> patch itself seems to have come from somebody else, unless you're
> Lekensteyn. So we'd want to get the provenance of that too.

More a question to Christopher, but what criteria is preventing the use
of the NVIDIA GPU under this condition?

As far as I've seen on my (single-GPU) systems X requires the GPU to
have boot_vga=1 sysfs attribute to accept autoconfiguration (though
with two GPUs and optimus/switcheroo interaction between the GPUs may
change the picture).

I've been looking at the open, nouveau side of things only. If NVIDIA
closed driver has some other requirement, I don't know.

But as here the intention seems to be to use exclusively the NVIDIA GPU
just leaving the IGD along it should require explicit X configuration
which then does not care about boot_vga.


A more detailed description of what prevents operation with GPU not
being added to vgaarb would certainly help understanding what happens,
what is expected and where things differ.

Bruno

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
