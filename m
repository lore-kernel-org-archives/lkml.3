Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbbAFJPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:15:54 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50960 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbAFJPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:15:51 -0500
Date: Tue, 6 Jan 2015 09:15:48 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        leif.lindholm@linaro.org, roy.franz@linaro.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com, matt.fleming@intel.com,
        bp@alien8.de, dyoung@redhat.com, msalter@redhat.com,
        grant.likely@linaro.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] memblock: add physmem to memblock_dump_all() output
Message-ID: <20150106091548.GH3163@console-pimps.org>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
 <1419275322-29811-4-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419275322-29811-4-git-send-email-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Andrew, linux-mm and lkml)

On Mon, 22 Dec, at 07:08:37PM, Ard Biesheuvel wrote:
> If CONFIG_HAVE_MEMBLOCK_PHYS_MAP is set, there is a third memblock
> map called 'physmem'. Add it to the output of memblock_dump_all().
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  mm/memblock.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 252b77bdf65e..c27353beb260 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1522,6 +1522,9 @@ void __init_memblock __memblock_dump_all(void)
>  
>  	memblock_dump(&memblock.memory, "memory");
>  	memblock_dump(&memblock.reserved, "reserved");
> +#ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
> +	memblock_dump(&memblock.physmem, "physmem");
> +#endif
>  }
>  
>  void __init memblock_allow_resize(void)
> -- 
> 1.8.3.2
> 

-- 
Matt Fleming, Intel Open Source Technology Center
