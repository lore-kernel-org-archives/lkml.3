Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbbAEUZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:25:30 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:51532 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbbAEUZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:25:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        linux-samsung-soc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        drake@endlessm.com, loeliger@gmail.com,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org, khilman@linaro.org
Subject: Re: [PATCH v11 1/9] ARM: OMAP2+: use common l2cache initialization code
Date: Mon, 05 Jan 2015 21:25:17 +0100
Message-ID: <2975078.sXsfBJkaoi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420460348-20302-2-git-send-email-m.szyprowski@samsung.com>
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com> <1420460348-20302-2-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:MiDX6AAq1Pyjkx59QGJbu2kuuC35AQ+ThE0WE9VLFgBboX6pKHL
 2zEGy5iShNGZJP20L9PuhMDcow5eD1o3EeTD00USRMK8GwdPI+Hh7XaXPIpNVofT7mb3TVS
 ulQs9IluK8T/h6ralOz5rdXoNneFU1MIQOlFMD4GsKMxmWKeFJXho2dAbgKIhCQE/pS+H8N
 1sxikdNW4bYKrTTUGTDHQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 13:19:00 Marek Szyprowski wrote:
>  DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
> +       .l2c_aux_val    = OMAP_L2C_AUX_CTRL,
> +       .l2c_aux_mask   = 0xcf9fffff,
> +       .l2c_write_sec  = omap4_l2c310_write_sec,
>         .reserve        = omap_reserve,
>         .smp            = smp_ops(omap4_smp_ops),
>         .map_io         = omap4_map_io,
> 

Could we also get those values into the dts files? Clearly we
can't remove them here without breaking compatibility with old
dtbs, but it would be nice to have all new dtbs do the right thing.

	Arnd
