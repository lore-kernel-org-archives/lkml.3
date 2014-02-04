Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaBDTXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:23:36 -0500
Received: from imap.thunk.org ([74.207.234.97]:54139 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbaBDTXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:23:34 -0500
Date: Tue, 4 Feb 2014 19:23:25 +0000
From: tytso@mit.edu
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephan Mueller <smueller@chronox.de>,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
Message-ID: <20140204192325.GA11831@thunk.org>
Mail-Followup-To: tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
	Stephan Mueller <smueller@chronox.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
	blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
	tg@mirbsd.de, sandyinchina@gmail.com
References: <2039634.jSmQAS6tdi@myon.chronox.de>
 <20140204170823.GF12768@thunk.org>
 <52F13A1C.3040003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F13A1C.3040003@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:06:04AM -0800, H. Peter Anvin wrote:
> 
> The quantum noise sources there are in a system are generally two
> independent clocks running against each other.  However, independent
> clocks are rare; instead, most clocks are in fact slaved against each
> other using PLLs and similar structures.

One of the things that would be useful for us to understand is in
general, where in a system we have independent clocks.  For example, I
think (correct me if I'm wrong), a 2.5" or 3.5" HDD has its own clock
which is separate from the CPU/chipset.  That is actually how and
where we get any entropy; I am not at all convinced that we are
getting any variation from "chaotic air turbulence in the HDD" ---
that paper was published in 1994, and hard drive technologies have
changed quite a bit since then, with extra layers of caching, track
bufers, etc.

However, where a decade ago the ethernet card probably had its own
independent clock crystal/oscillator, I'm going to guess that these
days with SOC's and even on laptops, with ethernet device part of the
chipset, it is probably being driven off the same master oscillator.

I wonder if there's anyway we can either figure out manually, or
preferably, automatically at boot time, which devices actually have
independent clock oscillators.

							- Ted

