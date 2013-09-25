Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3IYMAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:00:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45209 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3IYMAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:00:54 -0400
Date: Wed, 25 Sep 2013 14:00:52 +0200
From: Pavel Machek <pavel@denx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Tull <atull@altera.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
Message-ID: <20130925120052.GD9690@amd.pavel.ucw.cz>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
 <1379539063.31417.23.camel@atx-linux-37>
 <20130919100833.GC19346@amd.pavel.ucw.cz>
 <52421829.4050708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52421829.4050708@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> The firmware approach is interesting.  It might be less flexible
> >> compared with my original code (see link to git below) that this is
> > 
> > On the other hand... that's the interface world wants, right? To most
> > users, fpga bitstream is just a firmware.
> > 
> 
> No, not really.
> 
> The typical assumption with the firmware interface is that there is
> exactly one possible firmware for each device (possibly modulated by
> driver version, but still.)  

Actually, I have seen counterexample there, too. Wifi card had
different firmware for host and access points mode, probably because
internal RAM could not fit both at same time. 

It is not really different; there's internal logic and you are
programming it to do something. You can program FPGA, CPLD, or
firmware for some embedded CPU.

> This is blatantly not true for an FPGA in
> the most extreme way possible -- there are an almost infinite number of
> ways one can load an FPGA.

Well, usually the FPGA has some function on the board (unless you are
using it for compute acceleration), and it also wants just one
version. If you have FPGA-based GSM board, you'll want GSM
firmware. If you have FPGA-based WIFI, you'll want WIFI firmware. If
you load GSM firmware there, it will very likely not work because it
needs different amplifiers etc.

Heck, you probably _could_ use your WIFI card for cryptographics
operations just by loading different firmware. People just don't do
that. I don't expect that to be too different in the FPGA case...

> However, I have to question the whole idea of an "FPGA subsystem" --
> there is an almost infinite number of ways to program an FPGA or FPGA
> programming device (which may even be a commodity flash with a
> microcontroller or CPLD, and may be shared with other devices), and it
> really doesn't make any inherent sense to lump them together.

Firmware loading methods are also different, yet it makes sense to
have uniform way of loading firmware. This is very similar situation.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
