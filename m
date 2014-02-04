Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaBDUkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:40:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48289 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbaBDUks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:40:48 -0500
Message-ID: <52F15000.2080102@zytor.com>
Date: Tue, 04 Feb 2014 12:39:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
        Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
References: <2039634.jSmQAS6tdi@myon.chronox.de>	<20140204170823.GF12768@thunk.org>	<52F13A1C.3040003@zytor.com>	<20140204192325.GA11831@thunk.org> <CAMuHMdV5tLX7L6m4Q+1tMu_LF0bhxErVJuXDcga8VAmGV91dZg@mail.gmail.com>
In-Reply-To: <CAMuHMdV5tLX7L6m4Q+1tMu_LF0bhxErVJuXDcga8VAmGV91dZg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 11:39 AM, Geert Uytterhoeven wrote:
> On Tue, Feb 4, 2014 at 8:23 PM,  <tytso@mit.edu> wrote:
>> However, where a decade ago the ethernet card probably had its own
>> independent clock crystal/oscillator, I'm going to guess that these
>> days with SOC's and even on laptops, with ethernet device part of the
>> chipset, it is probably being driven off the same master oscillator.
> 
> USB typically still has its own crystal.

USB and the Ethernet PHY frequently do still have their own crystals,
for reasons not entirely clear to me.  However, what all of these have
in common is that they are way out in the periphery.

>> I wonder if there's anyway we can either figure out manually, or
>> preferably, automatically at boot time, which devices actually have
>> independent clock oscillators.
> 
> You may find this information in the DT on some platforms (if you're
> lucky).

On most systems today, all the high speed clocks (CPU, memory, etc.) are
all fed from a single oscillator.  On PCs there used to be a separate
14.31818 MHz oscillator for the PIT, PMTIMER and HPET, but that is
increasingly handled by a frequency converter from the main bus clock.
Oscillators are expensive, and true asynchronous domains cause problems
with metastability.

	-hpa



