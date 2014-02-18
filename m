Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaBRXAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:00:10 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:36294 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaBRXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:00:06 -0500
Date: Tue, 18 Feb 2014 17:54:30 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Laura Abbott <lauraa@codeaurora.org>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv4 1/2] mm/memblock: add memblock_get_current_limit
In-Reply-To: <1392761733-32628-2-git-send-email-lauraa@codeaurora.org>
Message-ID: <alpine.LFD.2.11.1402181754030.17677@knanqh.ubzr>
References: <1392761733-32628-1-git-send-email-lauraa@codeaurora.org> <1392761733-32628-2-git-send-email-lauraa@codeaurora.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Laura Abbott wrote:

> Apart from setting the limit of memblock, it's also useful to be able
> to get the limit to avoid recalculating it every time. Add the function
> to do so.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  include/linux/memblock.h |    2 ++
>  mm/memblock.c            |    5 +++++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 1ef6636..8a20a51 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -252,6 +252,8 @@ static inline void memblock_dump_all(void)
>  void memblock_set_current_limit(phys_addr_t limit);
>  
>  
> +phys_addr_t memblock_get_current_limit(void);
> +
>  /*
>   * pfn conversion functions
>   *
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 39a31e7..7fe5354 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1407,6 +1407,11 @@ void __init_memblock memblock_set_current_limit(phys_addr_t limit)
>  	memblock.current_limit = limit;
>  }
>  
> +phys_addr_t __init_memblock memblock_get_current_limit(void)
> +{
> +	return memblock.current_limit;
> +}
> +
>  static void __init_memblock memblock_dump(struct memblock_type *type, char *name)
>  {
>  	unsigned long long base, size;
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
