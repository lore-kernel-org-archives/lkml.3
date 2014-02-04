Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935320AbaBDVfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:35:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48841 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934571AbaBDVfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:35:18 -0500
Message-ID: <52F15CF0.8080209@zytor.com>
Date: Tue, 04 Feb 2014 13:34:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: Re: [RFC PATCH 0/5] CPU Jitter RNG
References: <2039634.jSmQAS6tdi@myon.chronox.de> <20140204170823.GF12768@thunk.org> <52F13A1C.3040003@zytor.com> <1874855.zG4mP2DzbB@tauon>
In-Reply-To: <1874855.zG4mP2DzbB@tauon>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 12:31 PM, Stephan Mueller wrote:
>>
>> The quantum noise sources there are in a system are generally two
>> independent clocks running against each other.  However, independent
>> clocks are rare; instead, most clocks are in fact slaved against each
>> other using PLLs and similar structures.  When mixing spread spectrum
>> clocks and non-spread-spectrum clocks that relationship can be very
>> complex, but at least for some designs it is still at its core
>> predictable.
> 
> But isn't there an additional clock? The clock used to drive the cache 
> and memory bus? When measuring memory accesses timings, larger 
> variations in the execution time are evident. This also applies when 
> hitting the caches (for L1, the variations are less than for L2 than for 
> L3). The variations in access timings would come from the CPU wait 
> states and their duration, would it not?
> 

Variations doesn't mean quantum unpredictable noise.  All the clocks you
are referring to are derived from the same BCLK and thus predictable.
What you have here is a PRNG with a large and obscure state space.

	-hpa


