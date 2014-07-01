Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaGARBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:01:48 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59940 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaGARBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:01:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Gregory Hermant <gregory.hermant@calao-systems.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Gael Portay <g.portay@overkiz.com>,
        Joachim Eastwood <manabian@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Tim Schendekehl <tim.schendekehl@egnite.de>
Subject: Re: [PATCH 00/33] ARM: at91: Switch remaining SoCs and boards to CCF
Date: Tue, 01 Jul 2014 19:01:12 +0200
Message-ID: <8196570.1BaMSL4giB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140701164851.GI3427@piout.net>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com> <5780166.MMf0Vhnnsu@wuerfel> <20140701164851.GI3427@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PxLkBi9WuFV1dTTWHvejYPlt57odHxItBuQ9z+7shbC
 bt5k8VcsBIMw+0mD5nJHEvnXllQ01Zhvoq7g6K+chKWe5JNnDY
 OU2Hzt422jKWO3FyU3MERbNYddj0XC78DoUir4vfvJ6nYMi+tp
 Grtqt7Y4SFtHPAskhf0fJMdkTSFL+UAaygSZV0QE4qPo57wVdQ
 Upi3frtYGLyrm4S0ZycQur8HCS0xBQxNuR5PZr9Fq60bwgYYzi
 EO3dzIZGSnFXpbGvNXzsop0Uo7qinmn3vSLtS9JEOyacUJTfLu
 FRKfDw6AU8ouJUKs2BVSEyoGZBMzgeZuxnz5CrUmi4IQ6PwJJJ
 oxihqg5hqh8qQUe1R4wU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 18:48:51 Alexandre Belloni wrote:
> On 01/07/2014 at 18:35:50 +0200, Arnd Bergmann wrote :
> > If I read this right, disabling 'USE_OF' results in still using
> > the old clock interface. Is that intentional? If you want to always
> > use COMMON_CLK now, the above can probably be simplified to
> > 
> > config AT91_PMC_UNIT
> >         def_bool !ARCH_AT91X40
> >       select COMMON_CLK
> > 
> > and all references to AT91_USE_OLD_CLK, COMMON_CLK_AT91 and
> > OLD_CLK_AT91 be removed.
> 
> Yeah, this is intentional we still have 30 or so boards that we have to
> migrate to DT. Until then, we want to be able to boot a kernel without
> CCF. The next step in the migration is to switch those boards to DT,
> possibly using an hybrid DT/pdata approach until we can get rid of the
> board files. Then, we will be able to get rid of the old clk
> implementation (and a few other drivers still living in mach-at91).

Ok, I see. Do you expect those 30 boards to work if COMMON_CLK_AT91
is enabled, or are there known problems with that?

If you have reason to believe it doesn't work, maybe you can expose
the selection of the clock interface to users, e.g. like

config COMMON_CLK_AT91
        bool "Use common clock infrastructure"
        depends on AT91_PMC_UNIT
	default USE_OF
        select COMMON_CLK
	help
	  The at91 platform is migrating to use the common clk infrastructure
	  for all boards, but this has not been tested on some of the older
	  machines that do not use DT yet.
	  If you encounter problems on legacy boards, try disabling this option
	  and report the problem to linux-arm-kernel@lists.infradead.org.

	Arnd
