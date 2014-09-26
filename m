Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaIZNqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:46:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44053 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752149AbaIZNqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:46:35 -0400
Date: Fri, 26 Sep 2014 14:46:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
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
        "broonie@linaro.org" <broonie@linaro.org>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed
	MMIO accessors
Message-ID: <20140926134608.GT5182@n2100.arm.linux.org.uk>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <4240583.SJ4jiIW6Zy@wuerfel> <20140926080551.GD31106@ulmo> <9197976.uQdLmtvIl1@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9197976.uQdLmtvIl1@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 03:39:49PM +0200, Arnd Bergmann wrote:
> On Friday 26 September 2014 10:05:52 Thierry Reding wrote:
> 
> > My original patch to consolidate the read*/write*() and friends
> > explicitly avoided the use of macros to do this. The reason was that if
> > we have static inline functions in asm-generic/io.h it defines the
> > canonical prototype of these functions, so that architectures that want
> > to override them can just copy the prototype from there.
> > 
> > So for consistency the above would become:
> > 
> > 	#ifndef readb_relaxed
> > 	#define readb_relaxed readb_relaxed
> > 	static inline u8 readb_relaxed(const void __iomem *addr)
> > 	{
> > 		return readb(addr);
> > 	}
> > 	#endif
> > 
> > And analogously for the others. For the *_relaxed variants it's perhaps
> > not as important because the signature is the same as for the plain
> > variants, so I'm not objecting very strongly to the plain macros.
> 
> Ok. I'd prefer the brief version I think.
> 
> Russell found a number of other bugs with the series, the patch below
> contains the fixes I've had to do so far.

Obviously, this does nothing for the:

include/asm-generic/io.h:804:29: error: redefinition of 'virt_to_bus'
include/asm-generic/io.h:809:21: error: redefinition of 'bus_to_virt'

errors which are also reported in Olof's build system.

Given how close we are to the merge window, I'd suggest this stuff gets
reverted so that it can have a better period of testing, rather than
stuffing it into -next at such a critical time.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
