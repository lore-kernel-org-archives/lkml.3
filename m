Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3FETqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:46:33 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:43979 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3FETqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:46:31 -0400
MIME-Version: 1.0
Date: Wed, 5 Jun 2013 20:46:30 +0100
X-Google-Sender-Auth: kGNvYdd5vcnDgr6NirfJc2UtMJ4
Message-ID: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
Subject: getting allwinner SoC support upstream (was Re: Uploading linux (3.9.4-1))
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: debian-kernel@lists.debian.org, debian-release@lists.debian.org,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 3:52 AM, Ben Hutchings <ben@decadent.org.uk> wrote:

> The 3.8.y branch is over, so I think we have to move to 3.9, ready or
> not.  I merged the work in progress from trunk to sid and am going
> through the config changes at the moment.
>
> I'm rather disappointed that nothing at all has been committed by ARM
> porters to either branch in the last month.

 *sigh* i didn't want to leave this as it stood, ben, purely for the
reason that i don't want to see you discouraged!  but, i also had to
think a bit about what potentially to say.

 the one SoC family that's going to become increasingly important to
have both upstream and in debian is support for allwinner's
processors.  with 40% world-wide tablet market share [*0], they must
be doing something right, and it's basically getting a staggering
price-performance value as well as having a set of interfaces and
level of integration that is really second to none.

 to begin to describe the problem in getting allwinner soc source code
upstream is this: not only do we have the usual "let's get it out the
door as fast as possible" learning curve of a very young, very new and
bewilderingly-successful fabless SoC company, but we also have a
completely new type of very successful and comprehensive
device-tree-like dynamic configuration system to deal with, which
allwinner have called "fex" [*1].

 basically at the time when device-tree was being thought of,
allwinner needed something that they could *right then* - not waiting
for developers to finish device-tree - they needed to be able to
reconfigure their customer's kernels *without* needing a recompile.
so they invented the script.fex system, which is a simple config.ini
file-format, compile it to binary, and get the bootloader to upload it
to memory and read it.

 fex covers *eeeeeevvveeerryyyythiiiing* - right from flipping the
multiplexing for all 3 SD/MMC cards so that you can pretend that SD0
is SD2 and you can specify *different* GPIOs for each to say which is
the detect line, which is the write-protect line, to setting the DRAM
clock timings, saying which kernel driver must be loaded to support
the touchscreen, enabling debugging, JTAG, naming the GPIOs for easy
and convenient use in the kernel code: basically there isn't a single
piece of hardware on the allwinner SoC family which *isn't*
reconfigureable through script.fex... and they've even integrated it
into u-boot *and* their low-level (early) bootloader as well [which
they've just properly complied with the GPL on, hooray! [*2]].

what's the point of mentioning this?

well, the point is: the expectation of the linux kernel developers is
that Everyone Must Convert To DeviceTree.  implicitly behind that is,
i believe, an expectation that if you *don't* convert to Device Tree,
you can kiss upstream submission goodbye.  and, in allwinner's case,
that's simply not going to happen.

add to this the fact that they've already taken *five* near-identical
copies of each version of their drivers (for sun3i up to sun7i) - if
you do a recursive diff in the drivers/usb/sun7i_usb and
drivers/usb/sun4i_usb directories, the discrepancies are negligeable
(and are in many cases a regression, reintroducing known or new
bugs!), you can start to see that they simply have no idea how to work
with the free software community (they're too busy) and that they're
not really about to start, either.

... and yet they're unbelievably successful, despite making a dog's
dinner of things as far as upstream integration is concerned,
precisely because they really really do only need to get one single
kernel compiled (for *all* their multi-million-dollar clients) and
err... that's it.  everything else goes into a per-client (per
product) customissed script.fex.

so, i don't have all the answers, but i can clearly see that there
needs to be some discussion and dialog - we can't have the world's
most successful SoC vendor *not* supported upstream: that's just a
ridiculous situation that is not helping any of the linux distros to
be an easy install option on some of the world's highest
price-performance ratio hardware.

thoughts and discussion appreciated.

l.


[*0] http://hardware.slashdot.org/story/13/05/08/1636217/chinas-allwinner-outsold-intel-qualcomm-in-tablet-processors-in-2012
[*1] - fex guide for SoCs up to but excluding the Allwinner A20
http://linux-sunxi.org/Fex_Guide
[*2] http://lists.phcomp.co.uk/pipermail/arm-netbook/2013-June/007619.html and
      http://lists.phcomp.co.uk/pipermail/arm-netbook/2013-June/007611.html
