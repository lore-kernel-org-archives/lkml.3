Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaKEMDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:03:32 -0500
Received: from pepin.polanet.pl ([193.34.52.2]:57866 "EHLO pepin.polanet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbaKEMD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:03:27 -0500
Date: Wed, 5 Nov 2014 13:03:24 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141105120324.GB3467@polanet.pl>
References: <20141102102212.GA7034@polanet.pl>
 <20141102103300.GB5229@pd.tnic>
 <20141102121139.GA7000@polanet.pl>
 <20141102123538.GE5229@pd.tnic>
 <20141102140839.GA27342@polanet.pl>
 <20141103105508.GB27384@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
In-Reply-To: <20141103105508.GB27384@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 11:55:08 +0100, Borislav Petkov wrote:

>> The previous modules were well tested in this motherboard, so I can't
>> blame them nor any other component - it's a 'cosmic ray' situation.
> 
> So we still don't know. I wouldn't throw away the old DIMMs if it is a
> single failure only.

They found their place in some workstations, for less critical usage.

> Btw, I forgot to ask, why are you even running 32-bit? Do you have some
> old K8 CPU which is not 64-bit capable?

This system was backed-up by some Intel one without 64-bit support and
it needed to be fully binary-compatible (including databases storage).

Over the time, as older hardware is disposed, it might eventually be
upgraded to 64-bit kernel running 32-bit userland in compat mode (full
transition is not going to happen soon as costs of such operation, i.e.
dumping and restoring all the data, application tests etc. greatly
overweight any benefits), but even the kernel change is not trivial due
to many quirks that happened every time before (and it was really hard
to find some stable configuration). Thus, until there is some bigger
maintaince undergoing or the hardware reaches it's lifetime, noone is
going to "pay" (allocate time, people at night shifts etc.) for such
change.

> As a matter of fact, can you apply your patch, enable CONFIG_EDAC_DEBUG
> and catch dmesg and send it to me, privately is fine too.

There's not much of if related (system is running 3.14.4):

MCE: In-kernel MCE decoding enabled.
EDAC MC: Ver: 3.0.0
AMD64 EDAC driver v3.4.0
EDAC amd64: DRAM ECC enabled.
EDAC amd64: K8 revF or later detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:  2048MB 1:     0MB
EDAC amd64: MC: 2:  2048MB 3:     0MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB
EDAC amd64: CS0: Unbuffered DDR2 RAM
EDAC amd64: CS2: Unbuffered DDR2 RAM
EDAC MC0: Giving out device to module amd64_edac controller K8: DEV 0000:00:18.2 (INTERRUPT)
EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)

(there are 4 modules 1 GB each, I haven't tested if above changes with
ganged/unganged mode.)

> Fair enough. How about the warning above? It will issue upon successful
> loading on 32-bit.

That is decent solution IMHO. There is a warning visible in logs (not
only in sources or during configuration), so everyone interested would
be informed in the first place they should start reading after any
possible error happens.

> But I'd still like to know what is the reason you're not moving to 64-bit.

Mostly because "If it ain't broke, don't fix it" rule. These are systems
with a few hundreds days uptime (e.g. 3 weeks ago some malfunction
caused 1,5 half year uptime machine to reboot, 500-900 days are not so
uncommon, I remember my pain rebooting machines over 1200 days online).
Restarting them usually causes some minor troubles (not saved changes),
changing software leads to compat troubles (that might be tested before
going to production), but changing kernel makes uncertainty about entire
platform, so it is avoided until necessary (and these running are
polished as much as possible, with backported bugfixes etc.) So
replacing rock-solid kernel with some other is a no-go, even preserving
the current sources (there might always be some 64-bit related bugs).

> The driver supports everything from K8 on which can do ECC. Family 11h
> doesn't support ECC so no need for an EDAC driver. I hope this answers

I mean your '[PATCH] amd64_edac: Document why it is 64-bit only':

-         the AMD64 families of memory controllers (K8 and F10h)
+         the AMD64 families of memory controllers, everything >= K8.

"everything >= K8" mislead me.

best regards,
-- 
Tomasz Pala <gotar@pld-linux.org>
