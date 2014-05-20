Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaETQrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:47:40 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49465 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaETQri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:47:38 -0400
Date: Tue, 20 May 2014 09:47:46 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: DT for 3.16 #2
Message-ID: <20140520164746.GA601@quad.lixom.net>
References: <1400059162-630-1-git-send-email-nicolas.ferre@atmel.com>
 <20140520055041.GO18956@quad.lixom.net>
 <537B727C.5080404@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537B727C.5080404@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 20, 2014 at 05:19:24PM +0200, Nicolas Ferre wrote:
> On 20/05/2014 07:50, Olof Johansson :
> > On Wed, May 14, 2014 at 11:19:22AM +0200, Nicolas Ferre wrote:
> >> Arnd, Olof, Kevin,
> >>
> >> More DT material for AT91. Some fixes that apply on what was merged for 3.15
> >> but that are not very critical.
> >> The other patches are feature additions to old or very recent product/board:
> >> at91sam9261 or sama5d3 Xplained.
> >>
> >> Thanks, best regards,
> >>
> >> The following changes since commit 27a96a0364787d2b41d2a72d08143d95263e1b07:
> >>
> >>   ARM: at91: sama5d3: clock for ssc from rk pin (2014-04-18 22:43:44 +0200)
> >>
> >> are available in the git repository at:
> >>
> >>   git://github.com/at91linux/linux-at91.git tags/at91-dt2
> >>
> >> for you to fetch changes up to a93f9c88b7701d1c4c3b22d39d64a408f000a6ef:
> >>
> >>   ARM: at91/dt: at91-sama5d3_xplained: add the regulator device node (2014-05-12 16:48:54 +0200)
> > 
> > Merged, but:
> > 
> >>  arch/arm/boot/dts/at91-sama5d3_xplained.dts |  62 +++++++++++++++
> >>  arch/arm/boot/dts/at91sam9261.dtsi          | 114 ++++++++++++++++++++++++++--
> >>  arch/arm/boot/dts/at91sam9rl.dtsi           |   7 +-
> >>  arch/arm/boot/dts/sama5d3.dtsi              |  78 +++++++++++++++++++
> > 
> > Grmbl. I remember being somewhat annoyed that you didn't use at91 prefix
> > when you introduced the sama5d3 dtsi files, but please don't start using
> > it on a random board like this, especially when other boards just use
> > the sama5d3_<board>.dts format.
> 
> Well, I don't understand completely. Since our discussion during 3.10
> merge window ([GIT PULL] at91: DT changes for 3.10 #2), I try to conform
> to this rule:
> 
> 1/ all pre-3.10 and 3.10 device tree file names stay unchanged
> -> sama5d3.dti (SoC)
> -> sama5d35ek.dts (board)
> 
> 2/ all *SoC* DT files conform to their marking:
> at91sam9263.dtsi
> at91sam9rl.dtsi
> sama5d3.dtsi, sama5d36.dtsi
> sama5d4.dtsi, sama5d46.dtsi (maybe in the future, who knows...)
> 
> 3/ all post-3.10 *boards* have the "at91-" prefix, whether they are
> populated with sam9 or sama5:
> at91-ariag25.dts (since 3.10, using a at91sam9g25)
> at91-qil_a9260.dts (since 3.14, using at91sam9260)
> at91-sama5d3_xplained.dts (since 3.14, using sama5d36)
> 
> The rule for AT91 has never been to prefix the board DT filename with
> the name of the SoC or SoC family.

So, going back and looking at the discussion from a year ago, I think the
disconnect was in what consistency we were looking for. Yes, we would have
preferred to prefix the sama5d3* dts/dtsis with at91, and you even
offered to do it. ;-) But I think even more important for sanity is
to stay consistent with how we handle all platforms, which is that the
board dts files are prefixed with the SoC name.

In the past, we've had cases where this didn't happen, but these days we have
tried to be very consistent on it. I.e. omap3*, exynos<##>*, etc.

So, if you have at91- as a prefix, have the SoC as the second component. But
that gets awkward too, so I would juts use the current SoC dtsi as the prefix
at91sam9263-<boardname>.dts, or sama5d35_<boardname>.dts.

> > Care to fix this up in time for 3.16 merge window?
> 
> Well, I do not know what to fix as the files were already present in
> mainline before this kernel revision and that I am a little bit
> reluctant to change file names after they are merged in mainline.
> 
> Now, can we keep the current policy described above (somehow weird, I
> admit) for future SoCs and boards?

It is unfortunate that I didn't catch this for 3.14 so that name has been
there in a release. I guess the least disruptive thing for now would be
to change over to use the SoC dtsi prefix for any new board files from
here on out, and treat at91-sama5d3_xplained as a one-time thing.


-Olof
