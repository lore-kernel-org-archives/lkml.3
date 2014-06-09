Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaFIBSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 21:18:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:17518 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753458AbaFIBSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 21:18:14 -0400
X-IronPort-AV: E=Sophos;i="4.98,1000,1392134400"; 
   d="scan'208";a="31627572"
Message-ID: <53950B92.6040504@cn.fujitsu.com>
Date: Mon, 9 Jun 2014 09:19:14 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] include/linux/memblock.h: add __init to memblock_set_bottom_up
References: <1402122084-25496-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1402122084-25496-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing from the code, it is OK.

Reviewed-by: Tang Chen<tangchen@cn.fujitsu.com>

Thanks.

On 06/07/2014 02:21 PM, Fabian Frederick wrote:
> memblock_set_bottom_up is only called by
> __init cmdline_parse_movable_node and __init numa_init.
>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: Tang Chen<tangchen@cn.fujitsu.com>
> Signed-off-by: Fabian Frederick<fabf@skynet.be>
> ---
> This is untested.
>
>   include/linux/memblock.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 8a20a51..4d6dfcf 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -198,7 +198,7 @@ phys_addr_t memblock_alloc(phys_addr_t size, phys_addr_t align);
>   /*
>    * Set the allocation direction to bottom-up or top-down.
>    */
> -static inline void memblock_set_bottom_up(bool enable)
> +static inline void __init memblock_set_bottom_up(bool enable)
>   {
>   	memblock.bottom_up = enable;
>   }
> @@ -213,7 +213,7 @@ static inline bool memblock_bottom_up(void)
>   	return memblock.bottom_up;
>   }
>   #else
> -static inline void memblock_set_bottom_up(bool enable) {}
> +static inline void __init memblock_set_bottom_up(bool enable) {}
>   static inline bool memblock_bottom_up(void) { return false; }
>   #endif
>
