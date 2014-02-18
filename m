Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaBRKUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:20:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37945 "EHLO
	alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754991AbaBRKKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:10:31 -0500
Date: Tue, 18 Feb 2014 10:09:43 +0000
From: Etched Pixels <sales@etchedpixels.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
Message-ID: <20140218100943.34f2e186@alan.etchedpixels.co.uk>
In-Reply-To: <20140217235013.GD2669@sirena.org.uk>
References: <20140120100415.GX15937@n2100.arm.linux.org.uk>
	<20140213181216.GB24155@kroah.com>
	<20140213181559.GB30257@n2100.arm.linux.org.uk>
	<20140213182701.GA32578@kroah.com>
	<20140213184249.GC30257@n2100.arm.linux.org.uk>
	<20140213232606.GA27372@kroah.com>
	<20140214000717.GG30257@n2100.arm.linux.org.uk>
	<20140214001436.GA16287@kroah.com>
	<20140214003834.GH30257@n2100.arm.linux.org.uk>
	<20140217153518.30891455@alan.etchedpixels.co.uk>
	<20140217235013.GD2669@sirena.org.uk>
Organization: Etched Pixels: www.etchedpixels.co.uk
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 08:50:13 +0900
Mark Brown <broonie@kernel.org> wrote:

> On Mon, Feb 17, 2014 at 03:35:18PM +0000, One Thousand Gnomes wrote:
> 
> > We've identified a correct working approach which is to simply add a
> > CONFIG entry to the ARM tree and a few ifdefs to the problem drivers to
> > make the "problem" (in fact a complete fictional non-problem) go away and
> > to get rid of the mess over time completely as the drivers are set
> > dynamic and it turns out that all the userspace happens to already handle
> > this just fine.
> 
> It's a very real problem which affects actual kernels that distro style
> users are building.

Only because you persist in trying to keep the old static minor
numbers even though they are not needed by anything in the real world
that will ever run such kernels. Also only because you are apparently
too slack to bother to check whether the driver matches the platform or
there is an device tree node before registering it even though that's
trivial to code and is already done by some other platforms and serial
drivers just fine.

It's a core code "problem" that is invented by refusing to do the simple
trivial fixes in the ARM tree. Please clean up your own poop instead of
trying to shovel it into the street.

And the proposed change set is buggy as hell - because we register things
like 8250 devices at least four ways on the same x86 machine all of which
could in theory occur in parallel.

Alan
