Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3BUNpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:45:35 -0500
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:24137 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab3BUNpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:45:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAO4jJlGVhxBY/2dsb2JhbAANN8B0gRyDEgEBAQMBOEABBQsLGAkWDwkDAgECAUUGDQEFAgEBiAisFJMejTuBUweDQAOqKYFX
X-IronPort-AV: E=Sophos;i="4.84,709,1355068800"; 
   d="scan'208";a="72756725"
Message-ID: <512624F2.2030004@uclinux.org>
Date: Thu, 21 Feb 2013 23:45:22 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/nommu: fix build when CPU is not coldfire
References: <1361064814-9727-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1361064814-9727-1-git-send-email-cascardo@holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thadeu,

On 17/02/13 11:33, Thadeu Lima de Souza Cascardo wrote:
> Commit dd1cb3a7c43508c29e17836628090c0735bd3137 unified mm/init.c for both MMU
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Its good practice to include the text title of the patch along with the
commit id.


> and non-MMU m68k platforms. However, it broke when we build a non-MMU M68K
> Classic CPU kernel.
>
> This fix builds a section that came from the MMU version only when we are
> building a MMU kernel.

Looks good thanks. I will push this into the m68knommu git tree.

Regards
Greg



> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>   arch/m68k/mm/init.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
> index afd8106f..519aad8 100644
> --- a/arch/m68k/mm/init.c
> +++ b/arch/m68k/mm/init.c
> @@ -188,7 +188,7 @@ void __init mem_init(void)
>   		}
>   	}
>
> -#if !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
> +#if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
>   	/* insert pointer tables allocated so far into the tablelist */
>   	init_pointer_table((unsigned long)kernel_pg_dir);
>   	for (i = 0; i < PTRS_PER_PGD; i++) {
>

