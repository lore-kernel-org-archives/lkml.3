Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3BZWJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:09:55 -0500
Received: from relais.videotron.ca ([24.201.245.36]:61878 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3BZWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:09:52 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 26 Feb 2013 17:09:51 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
In-reply-to: <87fw0i7n6d.fsf@dell.be.48ers.dk>
Message-id: <alpine.LFD.2.03.1302261708120.1254@syhkavp.arg>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
 <512D1C12.4080109@oberhumer.com>
 <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg>
 <87fw0i7n6d.fsf@dell.be.48ers.dk>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013, Peter Korsgaard wrote:

> >>>>> "Nicolas" == Nicolas Pitre <nico@fluxnic.net> writes:
> 
> Hi,
> 
>  >> Did you actually *try* the new LZO version and the patch (which is attached
>  >> once again) as explained in https://lkml.org/lkml/2013/2/3/367 ?
>  >> 
>  >> Because the new LZO version is faster than LZ4 in my testing, at least
>  >> when comparing apples with apples and enabling unaligned access in
>  >> BOTH versions:
>  >> 
>  >> armv7 (Cortex-A9), Linaro gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:
>  >> 
>  >> compression speed   decompression speed
>  >> 
>  >> LZO-2012    :          44 MB/sec          117 MB/sec     no unaligned access
>  >> LZO-2013-UA :          47 MB/sec          167 MB/sec     Unaligned Access
>  >> LZ4 r88  UA :          46 MB/sec          154 MB/sec     Unaligned Access
> 
>  Nicolas> To be fair, you should also take into account the compressed
>  Nicolas> size of a typical ARM kernel.  Sometimes a slightly slower
>  Nicolas> decompressor may be faster overall if the compressed image to
>  Nicolas> work on is smaller.
> 
> Yes, but notice that lzo compressed BETTER than lz4 - E.G. from the
> introduction mail:
> 
> 1. ARMv7, 1.5GHz based board
>    Kernel: linux 3.4
>    Uncompressed Kernel Size: 14MB
>         Compressed Size  Decompression Speed
>    LZO  6.7MB            21.1MB/s
>    LZ4  7.3MB            29.1MB/s, 45.6MB/s(UA)

OK.  If LZO is now faster than LZ4 while still compressing more then I 
have no argument.


Nicolas
