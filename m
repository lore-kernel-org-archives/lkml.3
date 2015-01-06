Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbbAFTFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:05:40 -0500
Received: from gloria.sntech.de ([95.129.55.99]:52566 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbbAFTFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:05:39 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] mfd: syscon: fix syscon probing from dt
Date: Tue, 06 Jan 2015 20:05:20 +0100
Message-ID: <3852443.x4DN8HDuzc@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
References: <1420558236-14063-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Am Dienstag, 6. Januar 2015, 16:30:36 schrieb Philipp Zabel:
> Patch bdb0066df96e ("mfd: syscon: Decouple syscon interface from platform
> devices") breaks probing pure syscon devices from device tree, such as
> anatop and iomuxc-gpr on i.MX. This patch adds back the dt id table to
> match against "syscon" compatible device tree nodes.

could you elaborate a bit on the problem you're seeing without your patch?

With bdb0066df96e the syscon should be registered by the first call to one of 
the syscon_regmap_lookup_by_* functions. On my rockchip boards this works 
without any hickups:

       .bss : 0xc07f88a8 - 0xc0847264   ( 315 kB)
Hierarchical RCU implementation.
NR_IRQS:16 nr_irqs:16 16
L2C: failed to init: -19
	syscon_regmap_lookup_by_phandle of /syscon@ff770000
	of_syscon_register of /syscon@ff770000
Architected cp15 timer(s) running at 24.00MHz (phys).
sched_clock: 56 bits at 24MHz, resolution 41ns, wraps every 2863311519744ns

[... a lot later ...]

stmmaceth ff290000.ethernet: rk_gmac_setup: Can not read property: rx_delay.
stmmaceth ff290000.ethernet: rk_gmac_setup: set rx_delay to 0x10
	syscon_regmap_lookup_by_phandle of /syscon@ff770000
stmmaceth ff290000.ethernet: rk_gmac_setup: NO interface defined!
stmmaceth ff290000.ethernet: gmac_clk_init: clock input from PHY


The syscon@ff770000 from above also is a pure syscon device, so I'm wondering 
why it wouldn't work on imx boards.


Heiko
