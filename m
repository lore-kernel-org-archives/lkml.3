Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab3BZU77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 15:59:59 -0500
Received: from relais.videotron.ca ([24.201.245.36]:15805 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759658Ab3BZU76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 15:59:58 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 26 Feb 2013 15:59:56 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>,
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
In-reply-to: <512D1C12.4080109@oberhumer.com>
Message-id: <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
 <512D1C12.4080109@oberhumer.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013, Markus F.X.J. Oberhumer wrote:

> On 2013-02-26 07:24, Kyungsik Lee wrote:
> > Hi,
> > 
> > [...]
> > 
> > Through the benchmark, it was found that -Os Compiler flag for
> > decompress.o brought better decompression performance in most of cases
> > (ex, different compiler and hardware spec.) in ARM architecture.
> > 
> > Lastly, CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is not always the best
> > option even though it is supported. The decompression speed can be
> > slightly slower in some cases.
> > 
> > This patchset is based on 3.8.
> > 
> > Any comments are appreciated.
> 
> Did you actually *try* the new LZO version and the patch (which is attached
> once again) as explained in https://lkml.org/lkml/2013/2/3/367 ?
> 
> Because the new LZO version is faster than LZ4 in my testing, at least
> when comparing apples with apples and enabling unaligned access in
> BOTH versions:
> 
> armv7 (Cortex-A9), Linaro gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:
> 
>                    compression speed   decompression speed
> 
>   LZO-2012    :          44 MB/sec          117 MB/sec     no unaligned access
>   LZO-2013-UA :          47 MB/sec          167 MB/sec     Unaligned Access
>   LZ4 r88  UA :          46 MB/sec          154 MB/sec     Unaligned Access

To be fair, you should also take into account the compressed size of a 
typical ARM kernel.  Sometimes a slightly slower decompressor may be 
faster overall if the compressed image to work on is smaller.


Nicolas
