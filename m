Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3IOUfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 16:35:22 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49370 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3IOUfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 16:35:21 -0400
Date: Sun, 15 Sep 2013 22:35:20 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Andreas Mohr <andi@lisas.de>, alsa-devel@alsa-project.org,
        krzysztof.h1@wp.pl,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ES938 support for ES18xx driver
Message-ID: <20130915203520.GA10589@rhlx01.hs-esslingen.de>
References: <20130915184902.GA23480@rhlx01.hs-esslingen.de>
 <201309152225.46581.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309152225.46581.linux@rainbow-software.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Sep 15, 2013 at 10:25:45PM +0200, Ondrej Zary wrote:
> On Sunday 15 September 2013 20:49:02 Andreas Mohr wrote:
> BTW. I've got an AZT3328 card and it works fine with your driver. Thanks for 
> it.

What!?!? I didn't quite expect any kernel dev to have that one, too ;)

(got several commits sitting here and waiting for submission though)

> I'm thinking about doing some reverse-engineering of thunderbird-based sound 
> cards (VLSI Thunderbird - Aztech PCI 368-DSP, Thunderbird Avenger - Philips 
> Acoustic/Seismic/Rhythmic Edge).

Oh, nice. I've got the Aztech PCI 368-DSP, too (that was somewhat obligatory
due to having written another Aztech card driver...).

And yeah, the PCI 368 (etc.) series does seem to be some rather heavy
support hole indeed, IIRC (especially as it's more modern PCI-based and not ISA).


> > So perhaps ES938 has (perhaps since it might more or less conform to
> > certain standards specs?) another control for PCM output switch as well
> > which would need implementing or simply isn't set properly?
> > (to clarify, we're talking about a switch which would cause output signal
> > to be grabbed pre or post the 3D manipulation block)
> 
> The good thing is that there's a datasheet available for ES938 - e.g. at 
> http://www.datasheetarchive.com/ES938-datasheet.html
> 
> The 3D switch works but the level doesn't. Maybe I should use only the 3 
> specific level values from the datasheet and not a variable scale. Or just 
> remove the level control completely as Windows driver does (there's only a 3D 
> switch).

Hmm. Perhaps they removed it "Since It Does Not Work"? ;-P


Thanks for hinting at the TLV control dB values thingy! Didn't know that such
thing existed, thus azt3328 does not have it (yet?).


> > Perhaps we could have a more verbose message here?
> > That ES938 surely must have some human-readable characteristics...
> > (hmm, what about "ES938 3D audio effects processor found!"?)
> > ((or "Detected ..."))
> 
> Yes, that's wrong - it's only for testing purposes. There should probably be 
> no message at all as the es18xx driver itself does not display anything if 
> everything is OK.

...or that, yeah.


> > Perhaps that check is not specific enough, i.e. it might be useful
> > to figure out a more precise check?
> 
> snd_es938_read_reg() checks that the returned data match the format used by 
> ES938. Maybe we can reread all the register values back after writing to be 
> sure.

Is there any chip ID/version register to be identified?

Andreas Mohr
