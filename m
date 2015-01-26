Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbbAZLrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:47:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53690 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbbAZLrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:47:41 -0500
Date: Mon, 26 Jan 2015 12:47:35 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        YH Chen =?utf-8?B?KOmZs+aYseixqik=?= <yh.chen@mediatek.com>,
        linux-kernel@vger.kernel.org, Henry Chen <henryc.chen@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yingjoe Chen =?utf-8?B?KOmZs+iLsea0sik=?= 
	<Yingjoe.Chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] MediaTek PMIC support
Message-ID: <20150126114735.GA3178@pengutronix.de>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:44:36 up 102 days, 22:58, 144 users,  load average: 0.04, 0.27,
 0.29
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof, Arnd,

OK to put the driver into drivers/soc/mediatek? Can you take these
patches?

Sascha

On Fri, Jan 23, 2015 at 03:09:55PM +0100, Sascha Hauer wrote:
> This series adds initial support for the MediaTek MT6397 PMIC and the
> necessary infrastructure to attach it on the MT8135 / MT8173 SoCs.
> 
> The infrastructure includes:
> 
> - pericfg / infracfg controller support
>   The pericfg / infracfg controllers contain miscellaneous registers for
>   reset controllers and clocks.
> 
> - PMIC wrapper support
>   On MediaTek MT8135, MT8173 and other SoCs the PMIC is connected via
>   SPI. The SPI master interface is not directly visible to the CPU, but
>   only through the PMIC wrapper inside the SoC. The communication between
>   the SoC and the PMIC can optionally be encrypted. Also a non standard
>   Dual IO SPI mode can be used to increase speed. The MT8135 also supports
>   a special feature named "IP Pairing". With IP Pairing the pins of some
>   SoC internal peripherals can be on the PMIC. The signals of these pins
>   are routed over the SPI bus using the pwrap bridge. Because of these
>   optional non SPI conform features the PMIC driver is not implemented as
>   a SPI bus master driver.
> 
> The MT6397 PMIC itself is implemented as a regular mfd device driver which
> uses regmap to access the PMIC registers.
> 
> This series also adds regulator support for the MT6397 PMIC.
> 
> The first 6 patches can be merged through the ARM SoC tree. The mfd
> patch is independent of the first 6 patches and can be merged through the
> mfd maintainer trees.
> 
> Changes since v1:
> 
> - document reset bindings for infracfg/pericfg
> - fix base addresses in infracfg binding example
> - Remove more Email addresses from Flora Fu (She is not working at
>   MediaTek anymore, her address is no longer valid)
> - drop Regulator support patch, it's already in next
> 
> Sascha
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
