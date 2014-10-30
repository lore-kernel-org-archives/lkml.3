Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161229AbaJ3Q7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:59:18 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:51070 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933737AbaJ3Q7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:59:16 -0400
Date: Thu, 30 Oct 2014 16:59:07 +0000
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20141030165907.GK32589@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
 <2811016.mhqlsl6pTS@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2811016.mhqlsl6pTS@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Sep 25, 2014 at 02:15:10PM +0100, Arnd Bergmann wrote:
> On Wednesday 24 September 2014 18:17:19 Will Deacon wrote:
> > Hello everybody,
> > 
> > This is version three of the series I've originally posted here:
> > 
> >   v1: https://lkml.org/lkml/2014/4/17/269
> >   v2: https://lkml.org/lkml/2014/5/22/468
> > 
> > This is basically just a rebase on top of 3.17-rc6, minus the alpha patch
> > (which was merged into mainline).
> > 
> > I looked at reworking the non-relaxed accessors to imply mmiowb, but it
> > quickly got messy as some architectures (e.g. mips) deliberately keep
> > mmiowb and readX/writeX separate whilst others (e.g. powerpc) don't trust
> > drivers to get mmiowb correct, so add barriers to both. Given that
> > arm/arm64/x86 don't care about mmiowb, I've left that as an exercise for
> > an architecture that does care.
> > 
> > In order to get this lot merged, we probably want to merge the asm-generic
> > patch (1/17) first, so Acks would be much appreciated on the architecture
> > bits.
> > 
> > As before, I've included the original cover letter below, as that describes
> > what I'm trying to do in more detail.
> > 
> 
> I've now applied the parts of your series that are required to have
> every architecture provide all the 'relaxed' accessors to the
> asm-generic tree, on top of Thierry's series.

Since these didn't make it for 3.18, would you like me to repost the series,
or do you already have a branch suitable for 3.19?

Cheers,

Will
