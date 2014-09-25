Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaIYPLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:11:10 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51196 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaIYPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:11:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
Date: Thu, 25 Sep 2014 17:07:47 +0200
Message-ID: <3361270.4SkjDs5lox@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140925145538.GN20043@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <2811016.mhqlsl6pTS@wuerfel> <20140925145538.GN20043@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QQ3+Fv4Uaa0r1xyBdlmGBX38ZsbCJZcUb6Lxc4/NveD
 6KWXLK8O5U/FxwAKUwjOS7G8B+T7mEP7OutOEi6KODSaml9KBN
 DeeVc+bGFx1PwVHlx5AEQ9EakNyqslOb2e6lfyO21fDXaAtTDw
 wKsmU1JPNMol3BK5WibuGVZstFIdWNzKz6bo5xZrcMM20Mpp0k
 FcURBQd2+PKflQRoM68v2igDdNkqzNnQ0tcUQWIETXOaeR4QQL
 +Vp19bgqLVs1uv2XNMAYzJdQr4BdMEt10I0TfuKgg7WwNhyr5Q
 a1yFNv2YgVgxjCQENdKsO2r6VWF+UcC2T00+qSLzhOYAzucJ59
 Osf8ZXMowhoEA5Hgc3MI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2014 15:55:38 Will Deacon wrote:
> On Thu, Sep 25, 2014 at 02:15:10PM +0100, Arnd Bergmann wrote:
> > On Wednesday 24 September 2014 18:17:19 Will Deacon wrote:
> > > This is version three of the series I've originally posted here:
> > > 
> > >   v1: https://lkml.org/lkml/2014/4/17/269
> > >   v2: https://lkml.org/lkml/2014/5/22/468
> > > 
> > > This is basically just a rebase on top of 3.17-rc6, minus the alpha patch
> > > (which was merged into mainline).
> > > 
> > > I looked at reworking the non-relaxed accessors to imply mmiowb, but it
> > > quickly got messy as some architectures (e.g. mips) deliberately keep
> > > mmiowb and readX/writeX separate whilst others (e.g. powerpc) don't trust
> > > drivers to get mmiowb correct, so add barriers to both. Given that
> > > arm/arm64/x86 don't care about mmiowb, I've left that as an exercise for
> > > an architecture that does care.
> > > 
> > > In order to get this lot merged, we probably want to merge the asm-generic
> > > patch (1/17) first, so Acks would be much appreciated on the architecture
> > > bits.
> > > 
> > > As before, I've included the original cover letter below, as that describes
> > > what I'm trying to do in more detail.
> > > 
> > 
> > I've now applied the parts of your series that are required to have
> > every architecture provide all the 'relaxed' accessors to the
> > asm-generic tree, on top of Thierry's series.
> 
> Brill, thanks Arnd! I'll repost what's left during the next cycle, however
> I think you also need to pick the microblaze patch as it includes
> <asm-generic/io.h> before defining its relaxed accessors, so I think
> you'll get a redefinition warning from the preprocessor.

Good point, I'll add that on top then.

> > I had to change your first patch significantly because all the context
> > changed in his patches. See below for the new version. Thierry, can
> > you also confirm that this matches up with the intention of your
> > series? Since that now adds a separate #ifdef for each symbol, I
> > ended up putting the #ifdef for the relaxed version inside of the
> > #ifdef for the non-relaxed version, but it could alternatively
> > be defined outside of it as well.
> 
> I think both work, as I can't find any architectures that define the
> relaxed variants but not the non-relaxed versions.

Actually I just made up my mind about that: Architectures are actually
supposed to provide the non-relaxed versions themselves using inline
assembly, but they don't need to provide the relaxed version.

The current version doesn't let you do that, so I'll keel the #ifdef
sections separate. This also means that I won't apply your patch 17:
we will keep needing the #ifdef to support all three relevant combinations:

a) architectures that provide neither and want to get the defaults
   from asm-generic
b) architectures that provide the non-relaxed versions and want tog
   to get just the relaxed version from asm-generic
c) architectures that provide both

	Arnd
