Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbaGAUCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:02:17 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50431 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639AbaGAUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:02:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Gregory Hermant <gregory.hermant@calao-systems.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Rodolfo Giometti <giometti@linux.it>,
        Gael Portay <g.portay@overkiz.com>,
        Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tim Schendekehl <tim.schendekehl@egnite.de>
Subject: Re: [PATCH 00/33] ARM: at91: Switch remaining SoCs and boards to CCF
Date: Tue, 01 Jul 2014 22:02:07 +0200
Message-ID: <4737199.CfKe4Y859I@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140701175601.GJ3427@piout.net>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com> <8196570.1BaMSL4giB@wuerfel> <20140701175601.GJ3427@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BIsS6+rQ7AEk9WAJfHtzt0QMcmA1sOF4U1XvLO3ABOp
 J2z3TJfq0Cct4sPjL9FRIf1lHDvCdoTWKjjtN5zfHxm2OVASd6
 p7+1M+DG0R+X5aPaYw1PZzgbFzcPCfO8FP8AukFtFKWuBZOz6H
 huDqjeJV6guEn8Vz1EK2/wPUlbVbYGECu4dq9wZKXf49EPPhKr
 uhXXXiDeGwFLx5NiH5Jegg2akGme/emhN6vbagPz/7cRRFJF3V
 4+KRm0j09AL/92H5HOFYg94bD4PoqI33Vs7nrOVI7Pnm/L5rfp
 AGXGzTq3zoy1erggUjujipjGgvKSKsloHwGTziq+v37SR/agux
 WgFtJd1EiwwXZM/brpUA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 19:56:01 Alexandre Belloni wrote:
> On 01/07/2014 at 19:01:12 +0200, Arnd Bergmann wrote :
> > On Tuesday 01 July 2014 18:48:51 Alexandre Belloni wrote:
> > > On 01/07/2014 at 18:35:50 +0200, Arnd Bergmann wrote :
> > > > If I read this right, disabling 'USE_OF' results in still using
> > > > the old clock interface. Is that intentional? If you want to always
> > > > use COMMON_CLK now, the above can probably be simplified to
> > > > 
> > > > config AT91_PMC_UNIT
> > > >         def_bool !ARCH_AT91X40
> > > >       select COMMON_CLK
> > > > 
> > > > and all references to AT91_USE_OLD_CLK, COMMON_CLK_AT91 and
> > > > OLD_CLK_AT91 be removed.
> > > 
> > > Yeah, this is intentional we still have 30 or so boards that we have to
> > > migrate to DT. Until then, we want to be able to boot a kernel without
> > > CCF. The next step in the migration is to switch those boards to DT,
> > > possibly using an hybrid DT/pdata approach until we can get rid of the
> > > board files. Then, we will be able to get rid of the old clk
> > > implementation (and a few other drivers still living in mach-at91).
> > 
> > Ok, I see. Do you expect those 30 boards to work if COMMON_CLK_AT91
> > is enabled, or are there known problems with that?
> > 
> > If you have reason to believe it doesn't work, maybe you can expose
> > the selection of the clock interface to users, e.g. like
> > 
> 
> We actually do the opposite, when a board without DT support is
> selected, the old clock support is also selected even when also
> selecting CONFIG_OF.

Ok, got it now. Yes, that makes sense.

I guess we can start doing the actual multiplatform enablement now,
which would be only for the DT-enabled boards -- all of Kconfig.non_dt
still has to depend on !ARCH_MULTIPLATFORM but we can make at91
either be built standalone (with board files) or multiplatform and
still support all SAM9 and RM9200 SoCs but without board files.

	Arnd
