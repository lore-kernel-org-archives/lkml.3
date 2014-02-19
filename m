Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaBSOsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:48:21 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33048 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBSOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:48:18 -0500
Date: Wed, 19 Feb 2014 14:47:51 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
Message-ID: <20140219144751.75f7fb70@alan.etchedpixels.co.uk>
In-Reply-To: <20140219135751.GX2669@sirena.org.uk>
References: <20140213181559.GB30257@n2100.arm.linux.org.uk>
	<20140213182701.GA32578@kroah.com>
	<20140213184249.GC30257@n2100.arm.linux.org.uk>
	<20140213232606.GA27372@kroah.com>
	<20140214000717.GG30257@n2100.arm.linux.org.uk>
	<20140214001436.GA16287@kroah.com>
	<20140214003834.GH30257@n2100.arm.linux.org.uk>
	<20140217153518.30891455@alan.etchedpixels.co.uk>
	<20140217235013.GD2669@sirena.org.uk>
	<20140218100943.34f2e186@alan.etchedpixels.co.uk>
	<20140219135751.GX2669@sirena.org.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please try to avoid this sort of misdirected yelling, it's not helping

I don't see any misdirected yelling

> anything to complain that people are following the recommendations of
> the maintainer or to demand that this somehow gets hacked around in
> arch/ when we're trying to convince all the architectures to get their
> drivers merged into subsystem trees so they're reviewed by the subsystem
> maintainers.

It's not a case of hacking around it in arch. It's a case of fixing up
problems where they belong, which btw is what Greg has in his tree -
specifically ef2889f7ffee67f0aed49e854c72be63f1466759 and
6f134c3c770355b7e930d3ffc558864668f13055 which keep the handling of the
minor clash cock-up in the drivers affected.

No garbage in the core tty drivers, no racy delayed registration in the
core uart code. In the longer term we should probably just abolish the
fixed minor numbers, nothing in the real world cares about them enough to
justify keeping them forever.

> you're doing here is making disparaging remarks and telling people to
> adopt bad practices because someone else made a mistake a decade ago.

I'm not telling anyone to adopt bad practices - at least its news to me
that "stopping the merge of buggy crap" is now a bad practice.

> That is how problems like this get created in the first place.

We were having a discussion about the fact the proposed patch for
deferring the processing was buggy, and probably unfixably so. That's a
code correctness discussion. Merging overcomplicated buggy crap causes
problems.

> > And the proposed change set is buggy as hell - because we register things
> > like 8250 devices at least four ways on the same x86 machine all of which
> > could in theory occur in parallel.
> 
> Then you need to convince Greg of that.  The most recent set of patches
> are exactly what he asked for.

No there's an assumption that when someone asks for patches the proposed
changes actually *work*. As Russell has demonstrated - the general
deferral patches for the uart/tty layer are broken. The driver specific
fixups in -next on the other hand appear to be fine providing the amba
bus probe remains serialized (and trivially fixed if it doesn't).

Alan

