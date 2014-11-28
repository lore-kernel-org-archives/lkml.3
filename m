Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaK1KwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:52:21 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53989 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaK1KwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:52:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        vinod.koul@intel.com, linux-mmc@vger.kernel.org, nsekhar@ti.com,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        khilman@deeprootsystems.com, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>, chris@printf.net,
        dmaengine@vger.kernel.org, ulf.hansson@linaro.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: edma: Rename header file for dmaengine filter function definition
Date: Fri, 28 Nov 2014 11:51:37 +0100
Message-ID: <6448422.mtUnef24Xp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54782148.6040108@ti.com>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <4859328.eEV7jzKEaA@wuerfel> <54782148.6040108@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:sU20kC6hDV5kMtRuA5DwZsydLWC2qVbBF3UnsfY19um
 9ux1voaRwISRhTOzCUvDBep2SkiTC1pabcltZhpTEqSyGlXGSm
 VS+HkeGfLNRLmyKJuwU8FWQSoxpjMsXDU12pisSbm3UHPYbIOr
 1MpcRPz4GGfWkq7QndYb3dICD1i3kbmshugKyeSaSB9jCCsOUw
 E/2/6GXjw8bmzGp4qpQvrkiPbUlRQ6UShAyqqXPDFYtCO3z1yT
 un3QSys3mY1E232OBqlJr6ibIHCo2CpkElPe4epJyW6HrnNkpk
 RvCedQsvMkAF1kkPHV7ZfGxi23lopC0Q0s4ya5ExtfsacMgxdj
 x0HPetjlN+OGTXV+zXX4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 09:16:24 Peter Ujfalusi wrote:
> On 11/27/2014 11:52 PM, Arnd Bergmann wrote:
> > On Thursday 27 November 2014 20:46:12 Peter Ujfalusi wrote:
> >>
> >> I see. With this series I did not planed to fix all edma related issues, just
> >> as a start clean up the related header files. I would rather not add fixes to
> >> mmc, spi, etc drivers since while you have valid point it is not in the scope
> >> of this series.
> >> Can we do the changes you are suggesting in an incremental manner?
> > 
> > Sure, but I'd leave the existing filter function declaration alone then
> > and not move it, since we wouldn't want to keep it in the long run.
> 
> but if you want to reference the filter function (which is in
> drivers/dma/edma.c) in arch/arm/mach-davinci/ directory, we will need it.
> Don't we?

Yes, unless you move the definition of the filter function into
arch/arm/common/edma.c or arch/arm/mach-davinci/devices.c, but that
would require other changes.

> If I leave the header as it is, then how would we clean up the edma headers? I
> would not put the API definitions for the arch code into the same file as we
> have the filter definition.

Ok, just go ahead with your current patch then, we can always follow up.
The most important cleanup for edma is elsewhere anyway, so once the asoc
drivers can use the dmaengine interface, this should be easier.

	Arnd
