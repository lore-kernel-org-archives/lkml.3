Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3BZV6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:58:11 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39909 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3BZV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:58:08 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Nicolas Pitre <nico@fluxnic.net>
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
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
	<512D1C12.4080109@oberhumer.com>
	<alpine.LFD.2.03.1302261557220.1254@syhkavp.arg>
Date: Tue, 26 Feb 2013 22:58:02 +0100
In-Reply-To: <alpine.LFD.2.03.1302261557220.1254@syhkavp.arg> (Nicolas Pitre's
	message of "Tue, 26 Feb 2013 15:59:56 -0500 (EST)")
Message-ID: <87fw0i7n6d.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nicolas" == Nicolas Pitre <nico@fluxnic.net> writes:

Hi,

 >> Did you actually *try* the new LZO version and the patch (which is attached
 >> once again) as explained in https://lkml.org/lkml/2013/2/3/367 ?
 >> 
 >> Because the new LZO version is faster than LZ4 in my testing, at least
 >> when comparing apples with apples and enabling unaligned access in
 >> BOTH versions:
 >> 
 >> armv7 (Cortex-A9), Linaro gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:
 >> 
 >> compression speed   decompression speed
 >> 
 >> LZO-2012    :          44 MB/sec          117 MB/sec     no unaligned access
 >> LZO-2013-UA :          47 MB/sec          167 MB/sec     Unaligned Access
 >> LZ4 r88  UA :          46 MB/sec          154 MB/sec     Unaligned Access

 Nicolas> To be fair, you should also take into account the compressed
 Nicolas> size of a typical ARM kernel.  Sometimes a slightly slower
 Nicolas> decompressor may be faster overall if the compressed image to
 Nicolas> work on is smaller.

Yes, but notice that lzo compressed BETTER than lz4 - E.G. from the
introduction mail:

1. ARMv7, 1.5GHz based board
   Kernel: linux 3.4
   Uncompressed Kernel Size: 14MB
        Compressed Size  Decompression Speed
   LZO  6.7MB            21.1MB/s
   LZ4  7.3MB            29.1MB/s, 45.6MB/s(UA)

-- 
Bye, Peter Korsgaard
