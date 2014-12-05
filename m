Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLER2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:28:54 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:46598 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaLER2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:28:53 -0500
Message-ID: <5481EB52.6060706@gmail.com>
Date: Fri, 05 Dec 2014 09:28:50 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: linux-mips@linux-mips.org, Zubair.Kakakhel@imgtec.com,
        geert+renesas@glider.be, david.daney@cavium.com, peterz@infradead.org,
        paul.gortmaker@windriver.com, davidlohr@hp.com, macro@linux-mips.org,
        chenhc@lemote.com, cl@linux.com, mingo@kernel.org, richard@nod.at,
        zajec5@gmail.com, james.hogan@imgtec.com, keescook@chromium.org,
        tj@kernel.org, alex@alex-smith.me.uk, pbonzini@redhat.com,
        blogic@openwrt.org, paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        markos.chandras@imgtec.com, dengcheng.zhu@imgtec.com,
        manuel.lauss@gmail.com, lars.persson@axis.com
Subject: Re: [PATCH v3 3/3] MIPS: set stack/data protection as non-executable
References: <20141203015537.13886.50830.stgit@linux-yegoshin> <20141203015824.13886.74616.stgit@linux-yegoshin>
In-Reply-To: <20141203015824.13886.74616.stgit@linux-yegoshin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 05:58 PM, Leonid Yegoshin wrote:
> This is a last step of 3 patches which shift FPU emulation out of
> stack into protected area. So, it disables a default executable stack.
>
> Additionally, it sets a default data area non-executable protection.
>
> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>

NAK!

Some programs require an executable stack, this patch will break them.

You can only select a non-executable stack in response to PT_GNU_STACK 
program headers in the ELF file of the executable program.

David Daney


> ---
>   arch/mips/include/asm/page.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
> index 3be81803595d..d49ba81cb4ed 100644
> --- a/arch/mips/include/asm/page.h
> +++ b/arch/mips/include/asm/page.h
> @@ -230,7 +230,7 @@ extern int __virt_addr_valid(const volatile void *kaddr);
>   #define virt_addr_valid(kaddr)						\
>   	__virt_addr_valid((const volatile void *) (kaddr))
>
> -#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
> +#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
>   				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
>
>   #define UNCAC_ADDR(addr)	((addr) - PAGE_OFFSET + UNCAC_BASE)
>
>
>
>

