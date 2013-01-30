Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3A3Sdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:33:52 -0500
Received: from relais.videotron.ca ([24.201.245.36]:14718 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab3A3Sdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 30 Jan 2013 13:33:47 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>, hyojun.im@lge.com,
        raphael.andy.lee@gmail.com, linux-kbuild@vger.kernel.org,
        gunho.lee@lge.com, namhyung.kim@lge.com, x86@kernel.org,
        minchan.kim@lge.com, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Ingo Molnar <mingo@redhat.com>, Joe Millenbach <jmillenbach@gmail.com>,
        chan.jeong@lge.com, Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
In-reply-to: <51089523.3080804@zytor.com>
Message-id: <alpine.LFD.2.02.1301301326530.6300@xanadu.home>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
 <20130128142510.68092e10.akpm@linux-foundation.org>
 <20130129101549.GP23505@n2100.arm.linux.org.uk> <51089523.3080804@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013, H. Peter Anvin wrote:

> On 01/29/2013 02:15 AM, Russell King - ARM Linux wrote:
> > On Mon, Jan 28, 2013 at 02:25:10PM -0800, Andrew Morton wrote:
> > > What's this "with enabled unaligned memory access" thing?  You mean "if
> > > the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
> > > that's only x86, which isn't really in the target market for this
> > > patch, yes?
> > > 
> > > It's a lot of code for a 50ms boot-time improvement.  Does anyone have
> > > any opinions on whether or not the benefits are worth the cost?
> > 
> > Well... when I saw this my immediate reaction was "oh no, yet another
> > decompressor for the kernel".  We have five of these things already.
> > Do we really need a sixth?
> > 
> > My feeling is that we should have:
> > - one decompressor which is the fastest
> > - one decompressor for the highest compression ratio
> > - one popular decompressor (eg conventional gzip)
> > 
> > And if we have a replacement one for one of these, then it should do
> > exactly that: replace it.  I realise that various architectures will
> > behave differently, so we should really be looking at numbers across
> > several arches.
> > 
> > Otherwise, where do we stop adding new ones?  After we have 6 of these
> > (which is after this one).  After 12?  After the 20th?
> > 
> 
> The only concern I have with that is if someone paints themselves into a
> corner and absolutely wants, say, LZO.

That would be hard to justify given that the kernel provides its own 
decompressor code, making the compression format transparent to 
bootloaders, etc.  And no one should be poking into the compressed 
zImage.

> Otherwise, per your list it pretty much sounds like we should have lz4, gzip,
> and xz.

I do agree with that.


Nicolas
