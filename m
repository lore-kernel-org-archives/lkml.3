Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbaGAQs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:48:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37429 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756521AbaGAQsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:48:55 -0400
Date: Tue, 1 Jul 2014 18:48:51 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Gregory Hermant <gregory.hermant@calao-systems.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Rodolfo Giometti <giometti@linux.it>,
        Gael Portay <g.portay@overkiz.com>,
        Joachim Eastwood <manabian@gmail.com>, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tim Schendekehl <tim.schendekehl@egnite.de>
Subject: Re: [PATCH 00/33] ARM: at91: Switch remaining SoCs and boards to CCF
Message-ID: <20140701164851.GI3427@piout.net>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
 <5780166.MMf0Vhnnsu@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5780166.MMf0Vhnnsu@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/07/2014 at 18:35:50 +0200, Arnd Bergmann wrote :
> On Tuesday 01 July 2014 16:12:09 Alexandre Belloni wrote:
> Looks good overall, but I think this Kconfig snippet should be cleaned
> up a little now:
> 
> config AT91_USE_OLD_CLK
>         bool
> 
> config AT91_PMC_UNIT
>         bool
>         default !ARCH_AT91X40
> 
> config COMMON_CLK_AT91
>         bool
>         default AT91_PMC_UNIT && USE_OF && !AT91_USE_OLD_CLK
>         select COMMON_CLK
> 
> config OLD_CLK_AT91
>         bool
>         default AT91_PMC_UNIT && AT91_USE_OLD_CLK
> 
> 
> If I read this right, disabling 'USE_OF' results in still using
> the old clock interface. Is that intentional? If you want to always
> use COMMON_CLK now, the above can probably be simplified to
> 
> config AT91_PMC_UNIT
>         def_bool !ARCH_AT91X40
> 	select COMMON_CLK
> 
> and all references to AT91_USE_OLD_CLK, COMMON_CLK_AT91 and
> OLD_CLK_AT91 be removed.

Yeah, this is intentional we still have 30 or so boards that we have to
migrate to DT. Until then, we want to be able to boot a kernel without
CCF. The next step in the migration is to switch those boards to DT,
possibly using an hybrid DT/pdata approach until we can get rid of the
board files. Then, we will be able to get rid of the old clk
implementation (and a few other drivers still living in mach-at91).


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
