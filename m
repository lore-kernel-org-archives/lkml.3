Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3JHU3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:29:52 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:47455 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab3JHU3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:29:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <201309182120.30950.heiko@sntech.de>
References: <201309182118.28391.heiko@sntech.de>
	<201309182120.30950.heiko@sntech.de>
Date: Tue, 8 Oct 2013 13:29:47 -0700
Message-ID: <CAOesGMjK5ZMkK8mj_+HSEjZCtfZUiLmVZThBAHacW8kp1=ThFw@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] ARM: S3C24XX: add platform-devices for new dma
 driver for s3c2412 and s3c2443
From: Olof Johansson <olof@lixom.net>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>, LinusW <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 18, 2013 at 12:20 PM, Heiko Stübner <heiko@sntech.de> wrote:
> This includes defining the mapping for the request sources.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> changes since v1:
> - follow new pdata definition

This showed up in -next today, and introduced:

arch/arm/mach-s3c24xx/common.c:337:24: warning: 's3c2410_dma_resource'
defined but not used [-Wunused-variable]

> +#if defined(CONFIG_CPU_S3C2410) || defined(CONFIG_CPU_S3C2412) || \
> +    defined(CONFIG_CPU_S3C2440) || defined(CONFIG_CPU_S3C2442)
> +static struct resource s3c2410_dma_resource[] = {
> +       [0] = DEFINE_RES_MEM(S3C24XX_PA_DMA, S3C24XX_SZ_DMA),
> +       [1] = DEFINE_RES_IRQ(IRQ_DMA0),
> +       [2] = DEFINE_RES_IRQ(IRQ_DMA1),
> +       [3] = DEFINE_RES_IRQ(IRQ_DMA2),
> +       [4] = DEFINE_RES_IRQ(IRQ_DMA3),
> +};
> +#endif
> +

Log at:

http://arm-soc.lixom.net/buildlogs/next-thierry/v3.12-rc4-4340-g56a7390/buildall.arm.mini2440_defconfig.log.passed


-Olof
