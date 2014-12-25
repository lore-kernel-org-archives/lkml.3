Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaLYWVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:21:35 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:55156 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaLYWVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:21:31 -0500
Date: Fri, 26 Dec 2014 00:21:23 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pavel Machek <pavel@ucw.cz>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Archit Taneja <archit@ti.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Nishanth Menon <nm@ti.com>, linux-omap <linux-omap@vger.kernel.org>,
        sre@debian.org, Tony Lindgren <tony@atomide.com>, sre@ring0.de,
        ivo.g.dimitrov.75@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.19-rc1 regression(?) on N900
Message-ID: <20141225222122.GB582@fuloong-minipc.musicnaut.iki.fi>
References: <549B44E2.6080202@ti.com>
 <201412250932.40403@pali>
 <20141225091121.GA20355@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141225091121.GA20355@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 25, 2014 at 10:11:21AM +0100, Pavel Machek wrote:
> On Thu 2014-12-25 09:32:40, Pali Rohár wrote:
> > On Wednesday 24 December 2014 23:57:38 Nishanth Menon wrote:
> > > based on automated testing with u-boot as a chained
> > > bootloader..
> > > 
> > > v3.19-rc1: hung
> > > https://github.com/nmenon/kernel-test-logs/blob/v3.19-rc1/omap
> > > 2plus_defconfig/n900.txt
> 
> Early hang, independend on config. That's "dtb too big". Delete
> something, and it should work again.

For me, DT boot works fine with 3.19-rc1 as is...

> Plus you'll note video regression.

...however, I can confirm that framebuffer is broken:

[    8.230743] omapfb omapfb: no displays
[    8.255584] omapfb omapfb: failed to setup omapfb
[    8.260620] platform omapfb: Driver omapfb requests probe deferral
[    8.284118] of_get_named_gpiod_flags: parsed 'reset-gpios' property of node
'/ocp/spi@48098000/acx565akm@2[0]' - status (0)
[    8.284271] acx565akm spi1.2: failed to find video source
[    8.290069] spi spi1.2: Driver acx565akm requests probe deferral

I bisected it to ef691ff48bc8 (OMAPDSS: DT: Get source endpoint
by matching reg-id). When I revert that, also FB works with 3.19-rc1.

A.
