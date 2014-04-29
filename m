Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbaD2OLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:11:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48179 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbaD2OLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:11:17 -0400
Date: Tue, 29 Apr 2014 10:10:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/7] x86: Add C intrinsics for new rd/wr fs/gs base
 instructions
Message-ID: <20140429141058.GC11349@phenom.dumpdata.com>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398723161-21968-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 03:12:37PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Plus for swapgs.
> 
> Very straight forward. Used in followon patch.

follow on
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/fsgs.h | 43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 arch/x86/include/asm/fsgs.h
> 
> diff --git a/arch/x86/include/asm/fsgs.h b/arch/x86/include/asm/fsgs.h
> new file mode 100644
> index 0000000..a3a5cd3
> --- /dev/null
> +++ b/arch/x86/include/asm/fsgs.h
> @@ -0,0 +1,43 @@
> +#ifndef _ASM_FSGS_H
> +#define _ASM_FSGS_H 1
> +
> +static inline void swapgs(void)
> +{
> +	asm volatile("swapgs" ::: "memory");
> +}
> +
> +/* Must be protected by X86_FEATURE_FSGSBASE check. */
> +
> +static inline unsigned long rdgsbase(void)
> +{
> +	unsigned long gs;
> +	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xc8 # rdgsbaseq %%rax"
> +			: "=a" (gs)
> +			:: "memory");
> +	return gs;
> +}
> +
> +static inline unsigned long rdfsbase(void)
> +{
> +	unsigned long fs;
> +	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xc0 # rdfsbaseq %%rax"
> +			: "=a" (fs)
> +			:: "memory");
> +	return fs;
> +}
> +
> +static inline void wrgsbase(unsigned long gs)
> +{
> +	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xd8 # wrgsbaseq %%rax"
> +			:: "a" (gs)
> +			: "memory");
> +}
> +
> +static inline void wrfsbase(unsigned long fs)
> +{
> +	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xd0 # wrfsbaseq %%rax"
> +			:: "a" (fs)
> +			: "memory");
> +}
> +
> +#endif
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
