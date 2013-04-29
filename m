Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab3D2VIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:08:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12947 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab3D2VIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:08:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,576,1363158000"; 
   d="scan'208";a="42697236"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
References: <20130429162115.GA6893@kroah.com>
	<CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
	<CA+55aFzLtBwsvVrnT2DrUOU+eYrQ5eiKeamRb4Y5+-TVgbuM5Q@mail.gmail.com>
	<201304292154.15920.arnd@arndb.de>
	<CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
Date: Mon, 29 Apr 2013 14:08:23 -0700
In-Reply-To: <CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 29 Apr 2013 13:12:54 -0700")
Message-ID: <8yafvy92gfs.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> There are other things wrong with that whole SSBI driver crap that you
> seem to be ignoring:
>
>  - it's not a bus, it's just a driver. Just because some people call
> it "serial bus" doesn't make it magically about a "bus". I can call an
> ethernet driver an "ethernet bus driver", and it may be technically
> correct, but it is still bullshit. And ethernet is damn more a real
> bus than that SSBI driver is. That's just a pure serial driver for a
> very specific piece of embedded hardware. Stop calling it a bus.

Correct.  Despite having "bus" in the name, it isn't really a bus.  It's
a point-to-point serial interface to a non-addressible device.

>  - The whole Kconfig thing is complete and utter garbage. There is no
> excuse what-so-ever for ever asking the user about it. Not on x86, not
> on ARM. The drivers that actually *use* that magical serial line
> driver should just have selected it.

Agreed

>  - I'm not seeing what commonalities this thing can have with anything
> else. Did anybody look at the code? There's nothing generic there.

This driver has one purpose, and will only ever have this one purpose:
to connect the MSM SOC to a small family of power management chips.  It
is theoretically possible to connect it to other things, and I think
there have been some obscure designs that do this, but not anything that
is going to be supported in the kernel.

> So move it to a saner place, fix the kconfig idiocy, and don't make
> noises as if it's some generic driver, much less some generic bus.
> It's not.

So, what is this saner place?  The hardware is theoretically shared
between ARM and Hexagon, but I don't know the hexagon plans to support
it, I've added them to the CC.

I'm not sure why this shouldn't be in the drivers/mfd directory
alongside the various pm*.c drivers that use it.  It isn't going to be
used for anything else.

Given the bikeshedding that happened when Ken pushed the driver out last
time, though, I'm sure this will create a firestorm of disagreement over
its location.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
