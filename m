Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaGUQPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:15:34 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55725 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaGUQPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:15:24 -0400
X-Auth-Info: sIZJW/uewb2/YVQLdkVGaIzzNLNdXBWYbW7yuSn3PhY=
From: Marek Vasut <marex@denx.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH RFC 9/9] arm: imx: non-secure aliased mapping of GIC registers
Date: Mon, 21 Jul 2014 18:15:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Harro Haan <hrhaan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org> <1405954040-30399-10-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1405954040-30399-10-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407211815.21099.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 21, 2014 at 04:47:20 PM, Daniel Thompson wrote:
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  arch/arm/mach-imx/mach-imx6q.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/mach-imx6q.c
> b/arch/arm/mach-imx/mach-imx6q.c index e60456d..192d268 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -381,10 +381,21 @@ static void __init imx6q_init_late(void)
>  	}
>  }
> 
> +static struct map_desc gic_cpu_io_desc __initdata = {
> +		.virtual        = 0xff000000,
> +		.pfn            = __phys_to_pfn(0x00a00000),
> +		.length         = SZ_1M,
> +		.type           = MT_DEVICE_NS,
> +};
> +
>  static void __init imx6q_map_io(void)
>  {
>  	debug_ll_io_init();
>  	imx_scu_map_io();
> +	/* TODO: Need to check we are running without a secure monitor before
> +	 *       setting up this mapping.
> +	 */
> +	iotable_init(&gic_cpu_io_desc, 1);
>  }

Is there no way to add ioremap_nonsecure() so the gic can allocate the mapping 
itself instead of adding a static one ? Also, can you add a flag to the 
MT_DEVICE_NS that says the mapping can only ever be in L1 and never in "lower" 
levels of the page table ?

Best regards,
Marek Vasut
