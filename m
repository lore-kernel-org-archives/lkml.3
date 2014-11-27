Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaK0RiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:38:11 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51613 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaK0RiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:38:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 00/11] ARM: at91: remove !DT support for at91rm9200
Date: Thu, 27 Nov 2014 18:38 +0100
Message-ID: <27354361.uIQEXGDqXb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141127171243.GL4508@piout.net>
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <3550407.q87bWB4Jdt@wuerfel> <20141127171243.GL4508@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pXsJQnIIKUKOub1wkhPxb+1G18DMIdwAM8eIRLLlcYy
 RGvLILttjX32zhJGENSyvdBccyYz/2o1swJtd/ZY2ZusUgNsML
 GY+ygeB3jCYFJsEwHX/ZlTc1ihijqEgcvljGvv6TvyQzSxlhPl
 QhspD2RXrp6eiEeUrcnFWi+IBT3UIjl4oTvLlQXOIQ6VRIoTZR
 Df/TCsQuM3ZcupWmFGl8HG9zXxhvlJ9ZUstPD11WqQZrin0bIM
 hYR1bTuW2eeY+RR++1tQOOoAX2EmJR88lY0nKfolh8Bz99dk4i
 HoV2QAhttl5D+/nYB1esGEwV9V21uPUv7mH9AFjsF0yduH4mMb
 ZTQx6g2W94RtZNv1VlNU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 18:12:43 Alexandre Belloni wrote:
> On 27/11/2014 at 17:49:50 +0100, Arnd Bergmann wrote :
> > On Thursday 27 November 2014 17:06:28 Nicolas Ferre wrote:
> > > This is the last series of patches that removes the non-Device-Tree board
> > > support for older Atmel SoCs.
> > > Again, for the record, it was announced here
> > > https://lkml.org/lkml/2014/9/10/293 ([ANNOUNCE] ARM: at91: removal of board
> > > files) two months ago.
> > > Several files beyond at91rm9200 are touched this time as I tried to remove the
> > > biggest parts that were related to !DT SoC initializations. More cleanup is
> > > certainly needed to remove dead code.
> > > 
> > > The diffstat is also pretty big as a lot of at91rm9200 boards were remaining.
> > > 
> > 
> > Awesome stuff!
> > 
> > Two questions:
> > 
> > - is anything holding this up from getting merged in 3.19?
> > 
> 
> If you think this is not too late in the cycle, I would say go ahead 

I'd say we should do it, unless there are last-minute regressions.

> > - Are there any remaining issues that keep us from using multiplatform?
> >   I know you all have been working on those a lot, but I haven't
> >   checked what is still missing.
> > 
> 
> As discussed some weeks ago, I prepared patches to switch sama5d[3-4] to
> multiplatform. We are still missing the SMC and matrix drivers to switch
> sam9 and rm9200.
> 
> The currently affected drivers are:
>  - drivers/ata/pata_at91.c (SMC)
>  - drivers/pcmcia/at91_cf.c (SMC)
>  - drivers/usb/gadget/udc/at91_udc.c (Matrix, this is the only one
>    for sam9)
>  - sound/atmel/ac97c.c (that one is still not converted to DT anyway...)
>  - drivers/watchdog/at91rm9200_wdt.c (WIP, will be converted properly to
>    an MFD)
> 
> I'll resume working on that in December.

Ok, sounds great.

> Do you want me to submit the sama5d[3-4] switch for 3.19? I'll have to
> rebase on that series. The main remaining issue is that I couldn't work
> out a way not breaking the defconfigs, even after talking with the
> Kconfig maintainer so doing first sama5 then sam9/rm9200 will break the
> defconfigs for sam9/rm9200 twice.

Probably better to do all of mach-at91 at once for 3.20 so we don't break
anything trying to make both aproaches work together.

	Arnd
