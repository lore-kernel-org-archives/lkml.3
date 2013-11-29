Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab3K2EBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 23:01:36 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60288 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3K2EBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 23:01:35 -0500
Message-ID: <52981222.3080007@gmail.com>
Date: Fri, 29 Nov 2013 12:03:46 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arch: hexagon: kernel: hexagon_ksyms.c: export related
 symbols which various modules need
References: <529811AE.8050502@gmail.com>
In-Reply-To: <529811AE.8050502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After this patch, excluding the VGA_CONSOLE issue, the hexagon can pass
allmodconfig. :-)

Please help check all related patches when you have time.


Thanks.

On 11/29/2013 12:01 PM, Chen Gang wrote:
> Need export all related functions and symbols for various modules with
> allmodconfig. The related errors:
> 
>     MODPOST 2879 modules
>   ERROR: "__vmyield" [sound/sound_firmware.ko] undefined!
>   ERROR: "__phys_offset" [sound/drivers/snd-dummy.ko] undefined!
>   ERROR: "ioremap_nocache" [drivers/char/ipmi/ipmi_si.ko] undefined!
>   ERROR: "__iounmap" [drivers/char/ipmi/ipmi_si.ko] undefined!
>   ...
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/hexagon/kernel/hexagon_ksyms.c |   27 +++++++++++++++++++++++----
>  1 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/hexagon/kernel/hexagon_ksyms.c b/arch/hexagon/kernel/hexagon_ksyms.c
> index 32b1379..3188de4 100644
> --- a/arch/hexagon/kernel/hexagon_ksyms.c
> +++ b/arch/hexagon/kernel/hexagon_ksyms.c
> @@ -20,6 +20,9 @@
>  
>  #include <asm/hexagon_vm.h>
>  #include <asm/uaccess.h>
> +#include <asm/io.h>
> +#include <linux/dma-mapping.h>
> +#include <asm/dma-mapping.h>
>  
>  EXPORT_SYMBOL(__copy_from_user_hexagon);
>  EXPORT_SYMBOL(__copy_to_user_hexagon);
> @@ -28,13 +31,29 @@ EXPORT_SYMBOL(__vmsetie);
>  EXPORT_SYMBOL(memcpy);
>  EXPORT_SYMBOL(memset);
>  
> +/* Additional functions */
> +EXPORT_SYMBOL(__strnlen_user);
> +EXPORT_SYMBOL(__vmyield);
> +EXPORT_SYMBOL(__iounmap);
> +EXPORT_SYMBOL(__clear_user_hexagon);
> +EXPORT_SYMBOL(ioremap_nocache);
> +EXPORT_SYMBOL(empty_zero_page);
> +
> +/* Additional variables */
> +EXPORT_SYMBOL(_dflt_cache_att);
> +EXPORT_SYMBOL(__phys_offset);
> +EXPORT_SYMBOL(bad_dma_address);
> +
>  #define DECLARE_EXPORT(name)     \
>  	extern void name(void); EXPORT_SYMBOL(name)
>  
>  /* Symbols found in libgcc that assorted kernel modules need */
>  DECLARE_EXPORT(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes);
>  
> -DECLARE_EXPORT(__hexagon_divsi3);
> -DECLARE_EXPORT(__hexagon_modsi3);
> -DECLARE_EXPORT(__hexagon_udivsi3);
> -DECLARE_EXPORT(__hexagon_umodsi3);
> +DECLARE_EXPORT(__divsi3);
> +DECLARE_EXPORT(__modsi3);
> +DECLARE_EXPORT(__udivsi3);
> +DECLARE_EXPORT(__umodsi3);
> +
> +/* Additional functions */
> +DECLARE_EXPORT(csum_tcpudp_magic);
> 


-- 
Chen Gang
