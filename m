Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab3D2UqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:46:21 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56031 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187Ab3D2UqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:46:20 -0400
Message-ID: <517EDC19.7020705@gmail.com>
Date: Mon, 29 Apr 2013 16:46:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: vinayakm.list@gmail.com
CC: linux-mm@kvack.org, akpm@linux-foundation.org, rientjes@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] mm: add an option to disable bounce
References: <1366644180-6140-1-git-send-email-vinayakm.list@gmail.com>
In-Reply-To: <1366644180-6140-1-git-send-email-vinayakm.list@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/22/13 11:23 AM), vinayakm.list@gmail.com wrote:
> From: Vinayak Menon <vinayakm.list@gmail.com>
> 
> There are times when HIGHMEM is enabled, but
> we don't prefer CONFIG_BOUNCE to be enabled.
> CONFIG_BOUNCE can reduce the block device
> throughput, and this is not ideal for machines
> where we don't gain much by enabling it. So
> provide an option to deselect CONFIG_BOUNCE. The
> observation was made while measuring eMMC throughput
> using iozone on an ARM device with 1GB RAM.
> 
> Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
> ---
>  mm/Kconfig |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 3bea74f..29f9736 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -263,8 +263,14 @@ config ZONE_DMA_FLAG
>  	default "1"
>  
>  config BOUNCE
> +	bool "Enable bounce buffers"
>  	def_bool y
>  	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
> +	help
> +	  Enable bounce buffers for devices that cannot access
> +	  the full range of memory available to the CPU. Enabled
> +	  by default when ZONE_DMA or HIGMEM is selected, but you
> +	  may say n to override this.

This should depend on CONFIG_EXPERT. Because this makes typically worse result
on typical desktop machine.






