Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046Ab3B0NYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:24:05 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56581 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3B0NYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:24:01 -0500
X-AuditID: 9c93016f-b7c56ae00000569b-5c-512e08efc447
Date: Wed, 27 Feb 2013 22:23:58 +0900
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, David Sterba <dsterba@suse.cz>,
        Richard Cochran <richardcochran@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Egon Alter <egon.alter@gmx.net>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH v2 0/4] Add support for LZ4-compressed kernel
Message-ID: <20130227132358.GA25071@Corona>
References: <1361859870-15751-1-git-send-email-kyungsik.lee@lge.com>
 <512D1C12.4080109@oberhumer.com>
 <20130227073646.GA22333@Corona>
 <20130227095139.GX17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227095139.GX17833@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 09:51:39AM +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 27, 2013 at 04:36:47PM +0900, Kyungsik Lee wrote:
> > Compiler: Linaro ARM gcc 4.6.2
> > 2. ARMv7, 1.7GHz based board
> >    Kernel: linux 3.7
> >    Uncompressed Kernel Size: 14MB
> >          Compressed Size  Decompression Speed
> >     LZO  6.0MB            34.1MB/s            Old
> >          ----------------------------------------
> >          6.0MB            34.7MB/s            New
> >          6.0MB            52.2MB/s(UA)
> >     =============================================
> >     LZ4  6.5MB            86.7MB/s
> > UA: Unaligned memory Access support
> 
> That is pretty conclusive - it shows an 8% increase in image size vs a
> 66% increase in decompression speed.  It will take a _lot_ to offset
> that increase in decompression speed.
> 
> So, what I think is that yes, we should accept LZ4 and drop LZO from
> the kernel - the "fast but may not be small" compression title has
> clearly been taken by LZ4.

I have read the comments regarding how many compressors the kernel
should support and understand that it can not support all the
compressors available.

However, I don't think that LZO can be replaced by LZ4 in all the
cases. The benchmark above shows only about improved decompression
speed.

Thanks,
Kyungsik

