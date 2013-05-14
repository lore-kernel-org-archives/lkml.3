Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab3ENPtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:49:49 -0400
Received: from [207.46.163.27] ([207.46.163.27]:35615 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754468Ab3ENPtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:49:47 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371I1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h947hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h1d0ch1d2eh1d3fh19b6n1155h)
Date: Tue, 14 May 2013 17:49:08 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 02/20] ARM: zynq: Remove init_irq declaration in machine
 description
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com> <1368545933-7430-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1368545933-7430-3-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <4e7a6946-b165-4440-9785-e0d538b608e0@CO9EHSMHS013.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 05:38 PM, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for zynq as well.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Acked-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/arm/mach-zynq/common.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index 5bfe703..4c0199b8 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -25,7 +25,6 @@
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
>  #include <linux/of.h>
> -#include <linux/irqchip.h>
>  
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> @@ -106,7 +105,6 @@ static const char * const zynq_dt_match[] = {
>  MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
>  	.smp		= smp_ops(zynq_smp_ops),
>  	.map_io		= zynq_map_io,
> -	.init_irq	= irqchip_init,
>  	.init_machine	= zynq_init_machine,
>  	.init_time	= zynq_timer_init,
>  	.dt_compat	= zynq_dt_match,
> 

Subject should contain v2 but anyway I have added it my zynq repo.

Thanks,
Michal


