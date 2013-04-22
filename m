Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3DVQ6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:58:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:36729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3DVQ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:58:35 -0400
Message-ID: <51756C24.8060505@infradead.org>
Date: Mon, 22 Apr 2013 09:58:12 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: vinayakm.list@gmail.com
CC: linux-mm@kvack.org, akpm@linux-foundation.org, rientjes@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add an option to disable bounce
References: <1366644180-6140-1-git-send-email-vinayakm.list@gmail.com>
In-Reply-To: <1366644180-6140-1-git-send-email-vinayakm.list@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/13 08:23, vinayakm.list@gmail.com wrote:
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

	                              HIGHMEM

> +	  may say n to override this.
>  
>  # On the 'tile' arch, USB OHCI needs the bounce pool since tilegx will often
>  # have more than 4GB of memory, but we don't currently use the IOTLB to present
> 


-- 
~Randy
