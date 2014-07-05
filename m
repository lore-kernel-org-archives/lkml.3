Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaGEOnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 10:43:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:44597 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaGEOnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 10:43:15 -0400
Message-ID: <53B80EFC.6020504@infradead.org>
Date: Sat, 05 Jul 2014 07:43:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, ralf@linux-mips.org
CC: jchandra@broadcom.com, blogic@openwrt.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: Add #ifdef in file bridge.h
References: <1404528619-3715-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1404528619-3715-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 07:50 PM, Nicholas Krause wrote:
> This patch addes a #ifdef __ASSEMBLY__ in order to check if this part
> of the file is configured to fix this #ifdef block in bridge.h for mips.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/mips/include/asm/netlogic/xlp-hal/bridge.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/netlogic/xlp-hal/bridge.h b/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
> index 3067f98..4f315c3 100644
> --- a/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
> +++ b/arch/mips/include/asm/netlogic/xlp-hal/bridge.h
> @@ -143,7 +143,7 @@
>  #define BRIDGE_GIO_WEIGHT		0x2cb
>  #define BRIDGE_FLASH_WEIGHT		0x2cc
>  
> -/* FIXME verify */
> +#ifdef __ASSEMBLY__
>  #define BRIDGE_9XX_FLASH_BAR(i)		(0x11 + (i))
>  #define BRIDGE_9XX_FLASH_BAR_LIMIT(i)	(0x15 + (i))
>  
> 

Hi,

Where is the corresponding #endif ?
The #endif at line 185 goes with the #ifndef __ASSEMBLY__ at line 176.

I think that this patch will cause a build error (or at least a warning).
Did you test it?


-- 
~Randy
