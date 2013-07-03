Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3GCIpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:45:09 -0400
Received: from mail.abilis.ch ([195.70.19.74]:23331 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab3GCIoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:44:39 -0400
Date: Wed, 3 Jul 2013 10:44:31 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Vincent Stehlll <vincent.stehle@freescale.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH linux-next] i2c-designware: use div_u64 to fix link
Message-ID: <20130703084429.GB19130@ab42.lan>
References: <1372758414-21513-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1372758414-21513-1-git-send-email-vincent.stehle@freescale.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 11:46:54AM +0200, Vincent Stehlll wrote:
> This fixes the following link error:
> 
>   drivers/built-in.o: In function `dw_i2c_probe':
>   of_iommu.c:(.text+0x18c8f0): undefined reference to `__aeabi_uldivmod'
>   make: *** [vmlinux] Error 1

Looks good. I also tested it on our ARC based platform, no issues with
compilation or functionality. Thanks for pointing this out.

Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>

> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Christian Ruppert <christian.ruppert@abilis.com>
> Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> ---
> 
> 
> Hi,
> 
> Linux next-20130702 link broke for ARM config multi_v7_defconfig. This is with
> gcc 4.7.2 but I am not sure it matters much here.
> 
> This patch repairs the link.
> 
> It did not break anything for me on i.MX6 sabre sd, but it does'nt have a
> designware i2c, so more reviewing/testing is welcome.
> 
> Best regards,
> 
> V.
> 
> 
>  drivers/i2c/busses/i2c-designware-platdrv.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index def79b5..4c5fada 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -122,7 +122,8 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  
>  		of_property_read_u32(pdev->dev.of_node,
>  					"i2c-sda-hold-time-ns", &ht);
> -		dev->sda_hold_time = ((u64)ic_clk * ht + 500000) / 1000000;
> +		dev->sda_hold_time = div_u64((u64)ic_clk * ht + 500000,
> +					     1000000);
>  	}
>  
>  	dev->functionality =
> -- 
> 1.7.10.4
> 
> 
> 

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
