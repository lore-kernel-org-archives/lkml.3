Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab3BZWSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:18:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50647 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3BZWSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:18:42 -0500
Date: Tue, 26 Feb 2013 22:10:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20130226221027.GW17833@n2100.arm.linux.org.uk>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com> <512D1C12.4080109@oberhumer.com> <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg> <87fw0i7n6d.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw0i7n6d.fsf@dell.be.48ers.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:58:02PM +0100, Peter Korsgaard wrote:
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

Well, until someone can put all the pieces together so that a reasonably
meaningful test between:

- The new LZO code
- The new LZ4 code

then you're all comparing different things.  TBH, I'm disappointed that
all the comments about this from the previous posting of LZ4 have been
totally ignored, and we _still_ don't really have this information.  It
seems like replying to these threads is a waste of time.

So... for a selected kernel version of a particular size, can we please
have a comparison between the new LZO code and this LZ4 code, so that
we can see whether it's worth updating the LZO code or replacing the
LZO code with LZ4?
