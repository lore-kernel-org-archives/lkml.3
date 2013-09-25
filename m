Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3IYPXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:23:11 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59175 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab3IYPXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:23:09 -0400
Date: Wed, 25 Sep 2013 10:23:06 -0500
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
In-Reply-To: <alpine.LFD.2.03.1309242158340.312@syhkavp.arg> (from
	nico@fluxnic.net on Tue Sep 24 21:07:57 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1380122586.1974.84@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 09:07:57 PM, Nicolas Pitre wrote:
> On Tue, 24 Sep 2013, Rob Landley wrote:
> 
> > On 09/24/2013 04:48:00 PM, Russell King - ARM Linux wrote:
> > > Now, if you feel strongly about this, we _could_ introduce a
> > > CONFIG_OLD_BINUTILS and give everyone their cake - but it will be
> > > fragile.  Not everyone will remember to get that right, because  
> they'll
> > > be using the later binutils.  Also, we already have an excessive  
> number
> > > of potential breakage-inducing options and we certainly don't need
> > > another.
> >
> > I'm doing the regression testing either way, on several different
> > architectures. (Although I tend to to only really do a thorough job  
> quarterly
> > when a new kernel comes out and it's time to make it work.) So I'm  
> going to be
> > doing something locally like this anyway, and if a  
> CONFIG_OLD_BINUTILS is
> > acceptable I might as well push it upstream.
> 
> If you are convinced you have no choice but to stick to old binutils,

Oh no, long-term other choices include lld.llvm.org and  
http://landley.net/code/qcc but they're not ready yet and I don't have  
time to work on them right now. (I had high hopes for gold, until the  
guy signed it over to the FSF and it vanished into the tiergruben. Oh  
well.)

> I'd strongly suggest you make your binutils compatible with newer
> instruction syntax instead of making the kernel more complex.

Meaning I play whack-a-mole as this becomes permission to depend on  
endless new gnuisms just because they're there and nobody else is  
regression testing against them, not because they actually add anything.

Whereas if I add an old binutils config option, other people might help  
regression test it (if not actually fix it), and the other toolchain  
projects have less of a moving target to catch up to.

> This is more in line with being future proof rather than stuck into  
> the past.

No, it's exactly the opposite of that. Future proof is getting off a  
toolchain whose license is a moving target.

GPLv2: "shut up and show me the code"
GPLv3: "I am altering the bargain, pray I don't alter it any further."
GPLv4: ???

> It could be as simple as making gas accept an extra argument for
> instructions like dsb and just ignoring it.

So you prefer I come up with the reversion patches locally and _not_  
send them upstream?

*shrug* That's what I've been doing for sh4 for around 4 years now.  
(And their breakage still reverts cleanly even.) It's also what I did  
when the arm versatile interrupts changed randomly 3 times in ways that  
weren't backwards compatible with existing qemu versions. And I  
maintained perl removal patches for 5 years before they finally went  
upstream.

But I do at least post said patches publicly, and other people use 'em  
when I do...

Rob