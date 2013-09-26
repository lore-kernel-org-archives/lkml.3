Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3IZWse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 18:48:34 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:55767 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3IZWsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 18:48:31 -0400
Date: Thu, 26 Sep 2013 17:48:29 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: new binutils needed for arm in 3.12-rc1
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Andrew Morton <akpm@osdl.org>,
        Trivial patch monkey <trivial@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <alpine.LFD.2.03.1309251147320.312@syhkavp.arg> (from
	nico@fluxnic.net on Wed Sep 25 11:13:17 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380235709.1974.93@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 11:13:17 AM, Nicolas Pitre wrote:
> On Wed, 25 Sep 2013, Rob Landley wrote:
> 
> > On 09/24/2013 09:07:57 PM, Nicolas Pitre wrote:
> > > I'd strongly suggest you make your binutils compatible with newer
> > > instruction syntax instead of making the kernel more complex.
> >
> > Meaning I play whack-a-mole as this becomes permission to depend on  
> endless
> > new gnuisms just because they're there and nobody else is  
> regression testing
> > against them, not because they actually add anything.
> 
> Gnuism?
> 
> Let me quote the ARM ARchitecture Reference Manual, version 7  
> revision C,
> section A8.8.44 (sorry for the whitespace dammage):

Globally changing the binutils requirement for all architectures, as  
the doc patch at the start of this thread proposed doing, would mean  
gnuisms in common code (ext2 and such) wouldn't get caught, giving llvm  
and pcc and such a moving target when trying to build the kernel with  
non-gnu toolchains. That's what I meant by gnuisms breeding.

> So what's the link with the above and your issue with GPLv3, besides  
> the
> fact that the last binutils version to have been released under the
> GPLv2 is defficient?

I apparently wasn't clear. The new instructions aren't gnuisms. The  
lack of widespread regression testing for armv5l and such would allow  
introduction of nonportable constructs in a larger context.

(The fact that armv7 could apparently build fine for ~7 years with  
binutils 2.18 through 2.21, and now it's suddenly can't Because Reasons  
is kinda silly, but not really a big deal. That, I can patch my  
toolchain.)

> > > It could be as simple as making gas accept an extra argument for
> > > instructions like dsb and just ignoring it.
> >
> > So you prefer I come up with the reversion patches locally and  
> _not_ send them
> > upstream?
> 
> Sort of.  And I'm suggesting you patch your binutils rather than the
> kernel.

I had this misidentified as a global arm problem and not specific to  
arm7l. If armv5l still still builds with the old toolchains, it's not a  
big deal.

> Given you're not upgrading your binutils anymore that means
> you'll have to apply that patch only once instead of having to apply  
> it
> to every kernel upgrade.

Indeed. Patching my own toolchain isn't really a problem. My objection  
was to the Documentation patch telling the world at large that for all  
targets, older binutils aren't supported even on x86. That was worth  
pushing back against.

I don't indend to use old gcc/binutils versions forever, I just want to  
be able to use them until I can replace them with llvm or similar.

Rob
