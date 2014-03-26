Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaCZQ6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:58:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26671 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbaCZQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:58:11 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-03-53330721616b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Tejun Heo <tj@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: fix Marvell SATA driver dependencies
Date: Wed, 26 Mar 2014 17:57:49 +0100
Message-id: <2706133.4NFborHvE6@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140326162302.GG25349@lunn.ch>
References: <5138028.BSQbEP7RRB@amdc1032> <20140326162302.GG25349@lunn.ch>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jQV1FduNgg93vLCzO3z3EbLGp7S2j
	ReOSyywWmx5fY7U4tuMRk8XlXXPYLN7/dLT4tfwoowOHx5NNFxk9ds66y+6xaVUnm0fDgfMs
	HpuX1Hvs3PGZyePzJrkA9igum5TUnMyy1CJ9uwSujIN3z7EWvOGo+HCft4Gxk72LkZNDQsBE
	4sHbe0wQtpjEhXvr2boYuTiEBKYzSrT8uMgK4bQwSUxfMBusg03ASmJi+ypGEFtEQEFiysk/
	YEXMAjOYJN4em8sKkhAWsJO4N30qmM0ioCqx8MZTsGZeAU2J3ZtWM4PYogKeEju2r2QDsTkF
	dCV2PtkONlRIwEti1czVbBD1ghI/Jt9jAbGZBeQl9u2HmMksoCWxfudxpgmMArOQlM1CUjYL
	SdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMER8Ex6B+OqBotDjAIcjEo8vDvuGwUL
	sSaWFVfmHmKU4GBWEuHd8RUoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6Yklqdmpq
	QWoRTJaJg1OqgVH75OScfx/a1iRN1ftxO/nvdDMVFTXlSY/l8jYrT7px+eq1+q+/HNu/FXeG
	fYiKuH3pTXZ3jaDIliOujgJZl1a/bH7kv37XvM2ZhxpzRBZ6f6tL682d7qUTc55P5u1kJcN2
	Lp/EU1FPvioqcwQrFgndqI3d/kd6yz+DEKdJT298ul6kb6E/xVSJpTgj0VCLuag4EQAL6Qfs
	fAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, March 26, 2014 05:23:02 PM Andrew Lunn wrote:
> On Wed, Mar 26, 2014 at 05:19:02PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > Make sata_mv host driver depend on PCI || ARCH_KIRKWOOD || ARCH_MVEBU ||
> > ARCH_ORION5X config options as Marvell SATA support covers both Marvell
> > PCI devices and Marvell Kirkwood, Armada 370/XP and Orion5x SoCs (for
> > non-PCI devices the driver to work requires suitable device tree node to
> > be defined).  Additionally allow the driver build if COMPILE_TEST config
> > option is set.
> 
> Hi Bartlomiej
> 
> I _think_ there are a few powerpc platforms which can also make use of
> this driver.

Currently no powerpc platform uses this driver for non-PCI devices and
looking at commits history for powerpc dts files it seems that it also
hasn't happened in the past.

I think that the current patch is sufficient as we can always relax
dependencies later if the need for it shows up + there is a possibility
to (ab)use COMPILE_TEST for older kernels.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

