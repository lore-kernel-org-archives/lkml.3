Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbbAMWuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:50:24 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753707AbbAMWuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:50:23 -0500
Date: Tue, 13 Jan 2015 23:50:21 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Bo Shen <voice.shen@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] ARM: at91/dt: add SRAM nodes
Message-ID: <20150113225021.GG3843@piout.net>
References: <1421172746-18727-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421172746-18727-5-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421172746-18727-5-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13/01/2015 at 19:12:24 +0100, Alexandre Belloni wrote :
> diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
> index 72424371413e..c055da2f151f 100644
> --- a/arch/arm/boot/dts/at91sam9rl.dtsi
> +++ b/arch/arm/boot/dts/at91sam9rl.dtsi
> @@ -70,6 +70,11 @@
>  		};
>  	};
>  
> +	sram: sram@00300000 {
> +		compatible = "mmio-sram";
> +		reg = <0x00300000 0x4000>;
> +	};
> +

Actually, I'm not sure about the sam9rl. The previous code was doing:
        switch (at91_soc_initdata.cidr & AT91_CIDR_SRAMSIZ) {
                case AT91_CIDR_SRAMSIZ_32K:
                        sram_size = 2 * SZ_16K;
                        break;
                case AT91_CIDR_SRAMSIZ_16K:
                default:
                        sram_size = SZ_16K;
        }

So the SRAM size should be 16k or 32k but what I get from the only cidr
registered for sam9rl (0x019b03a0, also from the datasheet) is SRAMSIZ=
0xb which give 64k. Could you confirm?

Thanks,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
