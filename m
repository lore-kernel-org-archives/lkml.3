Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab3LFRfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:35:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab3LFRfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:35:32 -0500
Message-ID: <52A20AD6.8080706@redhat.com>
Date: Fri, 06 Dec 2013 18:35:18 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH v2 3/3] X86, mpx: Intel MPX xstate feature definition
References: <1386375658-2191-1-git-send-email-qiaowei.ren@intel.com> <1386375658-2191-3-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1386375658-2191-3-git-send-email-qiaowei.ren@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/12/2013 01:20, Qiaowei Ren ha scritto:
> This patch defines xstate feature and extends struct xsave_hdr_struct
> to support Intel MPX.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/include/asm/processor.h |   12 ++++++++++++
>  arch/x86/include/asm/xsave.h     |    5 ++++-
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 987c75e..2fe2e75 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -370,6 +370,15 @@ struct ymmh_struct {
>  	u32 ymmh_space[64];
>  };
>  
> +struct bndregs_struct {
> +	u64 bndregs[8];
> +} __packed;
> +
> +struct bndcsr_struct {
> +	u64 cfg_reg_u;
> +	u64 status_reg;
> +} __packed;
> +
>  struct xsave_hdr_struct {
>  	u64 xstate_bv;
>  	u64 reserved1[2];
> @@ -380,6 +389,9 @@ struct xsave_struct {
>  	struct i387_fxsave_struct i387;
>  	struct xsave_hdr_struct xsave_hdr;
>  	struct ymmh_struct ymmh;
> +	u8 lwp_area[128];

Sorry for the back-and-forth, but I think this and the removal of
XSTATE_FLEXIBLE (perhaps XSTATE_LAZY?) makes your v2 worse than v1.

Since Peter already said the same, please undo these changes.

Also, how is XSTATE_EAGER used?  Should MPX be disabled when xsaveopt is
disabled on the kernel command line?  (Liu, how would this affect the
KVM patches, too?)

Paolo

> +#define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)
>  /*
>   * These are the features that the OS can handle currently.
>   */
> -#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
> +#define XCNTXT_MASK    (XSTATE_FP | XSTATE_SSE | XSTATE_YMM | XSTATE_EAGER)
>  
>  #ifdef CONFIG_X86_64
>  #define REX_PREFIX	"0x48, "
> 

