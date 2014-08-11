Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaHKNay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:30:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65375 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbaHKNax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:30:53 -0400
Date: Mon, 11 Aug 2014 14:30:55 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liu hua <sdu.liu@huawei.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/8] ARM: mm: allow text and rodata sections to be
 read-only
Message-ID: <20140811133055.GA15853@arm.com>
References: <1407423713-4160-1-git-send-email-keescook@chromium.org>
 <1407423713-4160-9-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407423713-4160-9-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 04:01:53PM +0100, Kees Cook wrote:
> This introduces CONFIG_DEBUG_RODATA, making kernel text and rodata
> read-only. Additionally, this splits rodata from text so that rodata can
> also be NX, which may lead to wasted memory when aligning to SECTION_SIZE.
> The read-only areas are made writable during ftrace updates and kexec.

[...]

> diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
> index 1ac184f2bdd8..4423a565ef6f 100644
> --- a/arch/arm/kernel/machine_kexec.c
> +++ b/arch/arm/kernel/machine_kexec.c
> @@ -164,11 +164,11 @@ void machine_kexec(struct kimage *image)
>  	reboot_code_buffer = page_address(image->control_code_page);
>  
>  	/* Prepare parameters for reboot_code_buffer*/
> +	set_kernel_text_rw();
>  	kexec_start_address = image->start;
>  	kexec_indirection_page = page_list;
>  	kexec_mach_type = machine_arch_type;
> -	kexec_boot_atags = dt_mem ?: image->start
> -				     - KEXEC_ARM_ZIMAGE_OFFSET
> +	kexec_boot_atags = dt_mem ?: image->start - KEXEC_ARM_ZIMAGE_OFFSET
>  				     + KEXEC_ARM_ATAGS_OFFSET;

Minor nit: but this patch and the kexec patch earlier in the series seem to
move this line around in different ways without actually changing the code.
I guess you just got a screwy rebase?

Will
