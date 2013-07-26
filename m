Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab3GZO7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:59:05 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:36609 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162Ab3GZO67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:58:59 -0400
Message-ID: <51F28EAD.2080705@intel.com>
Date: Fri, 26 Jul 2013 15:58:53 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Roy Franz <roy.franz@linaro.org>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] correct call to free_pages to specify memory size in
 pages, not bytes.
References: <1374713324-23670-1-git-send-email-roy.franz@linaro.org> <1374713324-23670-2-git-send-email-roy.franz@linaro.org>
In-Reply-To: <1374713324-23670-2-git-send-email-roy.franz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/13 01:48, Roy Franz wrote:
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index d606463..b7388a4 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -225,7 +225,7 @@ static void low_free(unsigned long size, unsigned long addr)
>  	unsigned long nr_pages;
>  
>  	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> -	efi_call_phys2(sys_table->boottime->free_pages, addr, size);
> +	efi_call_phys2(sys_table->boottime->free_pages, addr, nr_pages);
>  }
>  
>  static void find_bits(unsigned long mask, u8 *pos, u8 *size)

Thanks Roy. I pulled this into my urgent queue, as it's obviously a bug
and I don't fancy our chances if we ask the firmware to free more memory
than it initially allocated.
