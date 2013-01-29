Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3A2Lnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:43:40 -0500
Received: from mout.gmx.net ([212.227.15.19]:64305 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab3A2Lnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:43:37 -0500
X-Authenticated: #46697607
X-Provags-ID: V01U2FsdGVkX1/YgPYVMmjY7MBbweh9WLkeK38CoAfWO5lBYrAepG
	7KiC2BJTGzF54w
From: Egon Alter <egon.alter@gmx.net>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, hyojun.im@lge.com,
        raphael.andy.lee@gmail.com, linux-kbuild@vger.kernel.org,
        gunho.lee@lge.com, namhyung.kim@lge.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Ingo Molnar <mingo@redhat.com>, Joe Millenbach <jmillenbach@gmail.com>,
        chan.jeong@lge.com, Kyungsik Lee <kyungsik.lee@lge.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        minchan.kim@lge.com
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
Date: Tue, 29 Jan 2013 12:43:20 +0100
Message-ID: <34874167.ghObrToI03@fb07-iapwap2>
User-Agent: KMail/4.9.5 (Linux/3.7.4-20-desktop; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130129101549.GP23505@n2100.arm.linux.org.uk>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130128142510.68092e10.akpm@linux-foundation.org> <20130129101549.GP23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Januar 2013, 10:15:49 schrieb Russell King - ARM Linux:
> On Mon, Jan 28, 2013 at 02:25:10PM -0800, Andrew Morton wrote:
> > What's this "with enabled unaligned memory access" thing?  You mean "if
> > the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
> > that's only x86, which isn't really in the target market for this
> > patch, yes?
> > 
> > It's a lot of code for a 50ms boot-time improvement.  Does anyone have
> > any opinions on whether or not the benefits are worth the cost?
> 
> Well... when I saw this my immediate reaction was "oh no, yet another
> decompressor for the kernel".  We have five of these things already.
> Do we really need a sixth?
> 
> My feeling is that we should have:
> - one decompressor which is the fastest
> - one decompressor for the highest compression ratio
> - one popular decompressor (eg conventional gzip)

the problem gets more complicated as the "fastest" decompressor usually 
creates larger images which need more time to load from the storage, e.g. a 
one MB larger image on a 10 MB/s storage (note: bootloaders often configure 
the  storage controllers in slow modes) gives 100 ms more boot time, thus 
eating the gain of a "fast decompressor".

	Egon

