Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbaGAQgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:36:19 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:54353 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGAQgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:36:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
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
Date: Tue, 01 Jul 2014 18:35:50 +0200
Message-ID: <5780166.MMf0Vhnnsu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fFngYYGO54s1QhuL0YMVOarqd00lIUUWlk24jJ/rzkM
 evCj8yxoIzOEDTHzFdE0ZDuvnalzEKeBFNGtMhagKKVnVhP81Q
 jtJZ5LyQbLmFW0meQR9jRxoKsWNRQGrvAt1S4xGUTXT4IxFEbn
 +/FTtbt3CDVYYk5I0eypvhhQxNoKmVYmG0GOyg/LTcJve/yDWS
 z28pOZ4lJY24Bhl8W/BhZQmaHBF+Bq8KMdjZUCBbnZAE++7Bh+
 VnuGKOVNAnp69/NM2oXi9ljqKDpzBWXYrYNi+CG+wE5uQgDYjf
 oECHqrcMpFtvlVKV5n9ajJGE7epo0gAYR+K4OjofQfhw04410d
 Cx8i43yOvRPpejX3RZlA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 16:12:09 Alexandre Belloni wrote:
> This patch set adds support for the common clock framwork to the remaining atml
> SoCs: at91rm9200, at91sam9260, at91sam9263, at91sam9g45.
> 
> It also defines the necessary main crystal and slow crystal frequencies.
> 
> I couldn't find datasheets for the following boards:
>  - mpa1600
>  - ge863-pro3
>  - animeo_ip
>  - tny_a9260
> 
> For those, I assumed the 32kHz crystal is present on the board as this is the
> most common implementation (only one board doesn't have it). Please correct me
> if this is wrong.
> 
> I could not test at91rm9200 as I don't own any board with that chip.

Looks good overall, but I think this Kconfig snippet should be cleaned
up a little now:

config AT91_USE_OLD_CLK
        bool

config AT91_PMC_UNIT
        bool
        default !ARCH_AT91X40

config COMMON_CLK_AT91
        bool
        default AT91_PMC_UNIT && USE_OF && !AT91_USE_OLD_CLK
        select COMMON_CLK

config OLD_CLK_AT91
        bool
        default AT91_PMC_UNIT && AT91_USE_OLD_CLK


If I read this right, disabling 'USE_OF' results in still using
the old clock interface. Is that intentional? If you want to always
use COMMON_CLK now, the above can probably be simplified to

config AT91_PMC_UNIT
        def_bool !ARCH_AT91X40
	select COMMON_CLK

and all references to AT91_USE_OLD_CLK, COMMON_CLK_AT91 and
OLD_CLK_AT91 be removed.

	Arnd
