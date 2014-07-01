Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaGAR4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:56:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37955 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755115AbaGAR4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:56:21 -0400
Date: Tue, 1 Jul 2014 19:56:01 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
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
Message-ID: <20140701175601.GJ3427@piout.net>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
 <5780166.MMf0Vhnnsu@wuerfel>
 <20140701164851.GI3427@piout.net>
 <8196570.1BaMSL4giB@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8196570.1BaMSL4giB@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 at 19:01:12 +0200, Arnd Bergmann wrote :
> On Tuesday 01 July 2014 18:48:51 Alexandre Belloni wrote:
> > On 01/07/2014 at 18:35:50 +0200, Arnd Bergmann wrote :
> > > If I read this right, disabling 'USE_OF' results in still using
> > > the old clock interface. Is that intentional? If you want to always
> > > use COMMON_CLK now, the above can probably be simplified to
> > > 
> > > config AT91_PMC_UNIT
> > >         def_bool !ARCH_AT91X40
> > >       select COMMON_CLK
> > > 
> > > and all references to AT91_USE_OLD_CLK, COMMON_CLK_AT91 and
> > > OLD_CLK_AT91 be removed.
> > 
> > Yeah, this is intentional we still have 30 or so boards that we have to
> > migrate to DT. Until then, we want to be able to boot a kernel without
> > CCF. The next step in the migration is to switch those boards to DT,
> > possibly using an hybrid DT/pdata approach until we can get rid of the
> > board files. Then, we will be able to get rid of the old clk
> > implementation (and a few other drivers still living in mach-at91).
> 
> Ok, I see. Do you expect those 30 boards to work if COMMON_CLK_AT91
> is enabled, or are there known problems with that?
> 
> If you have reason to believe it doesn't work, maybe you can expose
> the selection of the clock interface to users, e.g. like
> 

We actually do the opposite, when a board without DT support is
selected, the old clock support is also selected even when also
selecting CONFIG_OF.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
