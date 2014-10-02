Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaJBQo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:44:28 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64268 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJBQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:44:26 -0400
Message-ID: <542D80E7.6040204@gmail.com>
Date: Thu, 02 Oct 2014 09:44:23 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, davem@davemloft.net,
        leitec@staticky.com, andrew@lunn.ch
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/dsa/Kconfig: Let NET_DSA_BCM_SF2 depend on
 HAS_IOMEM
References: <542D5DAC.4010001@gmail.com>
In-Reply-To: <542D5DAC.4010001@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 07:14 AM, Chen Gang wrote:
> NET_DSA_BCM_SF2 need HAS_IOMEM, so depend on it, the related error (with
> allmodconfig under um):
> 
>     CC [M]  drivers/net/dsa/bcm_sf2.o
>   drivers/net/dsa/bcm_sf2.c: In function ‘bcm_sf2_sw_setup’:
>   drivers/net/dsa/bcm_sf2.c:487:3: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
>      iounmap(*base);
>      ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  drivers/net/dsa/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> index ea0697e..9234d80 100644
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -47,6 +47,7 @@ config NET_DSA_MV88E6171
>  
>  config NET_DSA_BCM_SF2
>  	tristate "Broadcom Starfighter 2 Ethernet switch support"
> +	depends on HAS_IOMEM
>  	select NET_DSA
>  	select NET_DSA_TAG_BRCM
>  	select FIXED_PHY if NET_DSA_BCM_SF2=y
> 

