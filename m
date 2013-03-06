Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab3CFGKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:10:21 -0500
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:3869 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab3CFGKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:10:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQBAGHcNlGVhxBY/2dsb2JhbAANN4hsvCKCCoMeAQEBAwEjFUABBQsLDgoCAgUWCwICCQMCAQIBRQYNAQUCAQGHfAEMqAVxklaBI4wngUMHgi2BEwOgLookgVc
X-IronPort-AV: E=Sophos;i="4.84,793,1355068800"; 
   d="scan'208";a="317997502"
Message-ID: <5136DDBF.8090000@westnet.com.au>
Date: Wed, 06 Mar 2013 16:10:07 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: drop "select EMAC_INC"
References: <1362504650.16460.95.camel@x61.thuisdomein>
In-Reply-To: <1362504650.16460.95.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 06/03/13 03:30, Paul Bolle wrote:
> Somehow this select statement managed to squeeze itself between commit
> 0e152d80507b75c00aac60f2ffc586360687cd52 ("m68k: reorganize Kconfig
> options to improve mmu/non-mmu selections") and commit
> 95e82747d6e2abc513bfae416e6009968985d05b ("m68k: drop unused Kconfig
> symbols"). Whatever happened, there is no Kconfig symbol named EMAC_INC.
> The select statement for that symbol is a nop. Drop it.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, I'll add that to the m68knommu git tree, since it is a non-mmu
target.

Regards
Greg


> Untested, but it's hard to see what can got wrong here.
>
>   arch/m68k/Kconfig.machine | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
> index 7cdf6b0..7240584 100644
> --- a/arch/m68k/Kconfig.machine
> +++ b/arch/m68k/Kconfig.machine
> @@ -310,7 +310,6 @@ config COBRA5282
>   config SOM5282EM
>   	bool "EMAC.Inc SOM5282EM board support"
>   	depends on M528x
> -	select EMAC_INC
>   	help
>   	  Support for the EMAC.Inc SOM5282EM module.
>
>

