Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab3A1Q4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:56:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab3A1Q4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:56:34 -0500
Date: Mon, 28 Jan 2013 17:56:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rosegardener@freeode.co.uk
Subject: Re: [PATCH 1/4] USB: HID: SRW-S1 Gaming Wheel Driver
In-Reply-To: <1b4d173a8f4cbb94f6d99ae5c75c10d5.squirrel@mungewell.org>
Message-ID: <alpine.LNX.2.00.1301281750100.23853@pobox.suse.cz>
References: <1359095687-13398-1-git-send-email-simon@mungewell.org>    <alpine.LNX.2.00.1301281557040.23853@pobox.suse.cz> <1b4d173a8f4cbb94f6d99ae5c75c10d5.squirrel@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, simon@mungewell.org wrote:

> >> From: simon <simon@simon-virtual-machine.(none)>
> >>
> >> Add support the SRW-S1 by patching HID descriptor to read axis
> >> as Generic Desktop X, Y and Z (rather than Usage page being
> >> 'Simulation').
> >>
> >> Signed-off-by: Simon Wood <simon@mungewell.org>
> >> tested-by: John Murphy <rosegardener@freeode.co.uk>
> >
> > Hi Simon,
> >
> > thanks for the patch.
> >
> >>
> >> ---
> >>  drivers/hid/Kconfig     |    6 +++++
> >>  drivers/hid/Makefile    |    1 +
> >>  drivers/hid/hid-core.c  |    1 +
> >>  drivers/hid/hid-ids.h   |    3 +++
> >>  drivers/hid/hid-srws1.c |   58
> >> +++++++++++++++++++++++++++++++++++++++++++++++
> >
> > Is hid-srws1 really the best name? My understanding is that the vendor is
> > called Steelseries, and we mostly stick to calling the drivers according
> > to the device vendors (and grouping the quirks accordingly).
> >
> > So how about hid-steelseries?
> 
> I'm happy to change it; However Steelseries' other devices are all
> keyboards/mice intended for/marketed at gamers. Since other Steelseries
> devices are unlikely to have the same structure (OK I'm just guessing on
> that) is it better to keep this driver somewhat 'seperated'?
> 
> I mean, not make life difficult trying to merge keyboard code in with this
> wheel's code.... if that is required in future.

I don't think it's strictly required, but it seems to work quite nicely 
for other drivers as well.

Of course, if in the future it turns out that we will need a completely 
different driver for some other device produced by this vendor, we can 
operatively decide on a different naming for the future.

> If you still would prefer a name change I can do that. In which case is
> the naming of the LED interfaces still OK?
> 
> ie.
> --
> echo 1 > /sys/class/leds/SRWS1\:\:69005002125011007452\:\:RPM3/brightness
> --

Yes, that seems fine. Thanks,

-- 
Jiri Kosina
SUSE Labs
