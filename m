Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaFXM4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:56:14 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:9827 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaFXM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:56:12 -0400
Message-ID: <53A9755F.9000403@imgtec.com>
Date: Tue, 24 Jun 2014 13:55:59 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Walter <dwalter@google.com>, Ralf Baechle <ralf@linux-mips.org>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arch/mips/rb532: replace mac_addr parsing
References: <20140624111426.GA15160@google.com>
In-Reply-To: <20140624111426.GA15160@google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/14 12:14, Daniel Walter wrote:
> Replace parse_mac_addr with mac_pton().
> 
> 
> Signed-off-by: Daniel Walter <dwalter@google.com>

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
> Changes since v2
>   Use mac_pton() instead of sscanf()
>   added error handling in case could not be parsed
> ---
> Patch applies against current linux-git
> ---
>  arch/mips/rb532/devices.c | 27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
> ---
> diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
> index 3af00b2..03a4cdc 100644
> --- a/arch/mips/rb532/devices.c
> +++ b/arch/mips/rb532/devices.c
> @@ -250,28 +250,6 @@ static struct platform_device *rb532_devs[] = {
>  	&rb532_wdt
>  };
>  
> -static void __init parse_mac_addr(char *macstr)
> -{
> -	int i, h, l;
> -
> -	for (i = 0; i < 6; i++) {
> -		if (i != 5 && *(macstr + 2) != ':')
> -			return;
> -
> -		h = hex_to_bin(*macstr++);
> -		if (h == -1)
> -			return;
> -
> -		l = hex_to_bin(*macstr++);
> -		if (l == -1)
> -			return;
> -
> -		macstr++;
> -		korina_dev0_data.mac[i] = (h << 4) + l;
> -	}
> -}
> -
> -
>  /* NAND definitions */
>  #define NAND_CHIP_DELAY 25
>  
> @@ -333,7 +311,10 @@ static int __init plat_setup_devices(void)
>  static int __init setup_kmac(char *s)
>  {
>  	printk(KERN_INFO "korina mac = %s\n", s);
> -	parse_mac_addr(s);
> +	if (!mac_pton(s, korina_dev0_data.mac)) {
> +		printk(KERN_ERR "Invalid mac\n");
> +		return -EINVAL;
> +	}
>  	return 0;
>  }
>  
> 
