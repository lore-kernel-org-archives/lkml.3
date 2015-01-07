Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbbAGJ6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:58:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49564 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbAGJ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:58:30 -0500
Message-ID: <1420624699.3191.19.camel@pengutronix.de>
Subject: Re: [PATCH] mfd: syscon: fix syscon probing from dt
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>, kernel@pengutronix.de,
        Lee Jones <lee.jones@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Wed, 07 Jan 2015 10:58:19 +0100
In-Reply-To: <3852443.x4DN8HDuzc@phil>
References: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
	 <3852443.x4DN8HDuzc@phil>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

Am Dienstag, den 06.01.2015, 20:05 +0100 schrieb Heiko Stübner:
> Hi Philipp,
> 
> Am Dienstag, 6. Januar 2015, 16:30:36 schrieb Philipp Zabel:
> > Patch bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform
> > devices") breaks probing pure syscon devices from device tree, such as
> > anatop and iomuxc-gpr on i.MX. This patch adds back the dt id table to
> > match against "syscon" compatible device tree nodes.
> 
> could you elaborate a bit on the problem you're seeing without your patch?
>
> With bdb0066df96e the syscon should be registered by the first call to one of 
> the syscon_regmap_lookup_by_* functions. On my rockchip boards this works 
> without any hickups:

Oh, I didn't understand that is the way it's supposed to work now.

I noticed that after booting v3.19-rc on a nitrogen6x, the
/sys/kernel/debug/regmap/{20c8000.anatop,20e0000.iomuxc-gpr}
directories were missing. The syscon regmap is indeed registered,
but since regmap_init_mmio is called with dev = NULL, regmap_attach_dev,
and thus regmap_debugfs_init, is never called from regmap_init.

Also I want to add child devices to the syscon device since a while ago:
https://lkml.org/lkml/2014/12/15/133
This doesn't work anymore if there is no syscon device.

regards
Philipp

