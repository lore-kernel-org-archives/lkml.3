Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbbAHQ7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:59:20 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58032 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbAHQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:59:18 -0500
Date: Thu, 8 Jan 2015 16:59:09 +0000
From: Will Deacon <will.deacon@arm.com>
To: Pratyush Anand <panand@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tixy@linaro.org" <tixy@linaro.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "wcohen@redhat.com" <wcohen@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>
Subject: Re: [RFC 4/8] ARM64: Add instruction_pointer_set function
Message-ID: <20150108165909.GR11583@arm.com>
References: <cover.1420038188.git.panand@redhat.com>
 <028aab951a24c56075b1060afa1c2b2d88c09083.1420038188.git.panand@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <028aab951a24c56075b1060afa1c2b2d88c09083.1420038188.git.panand@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 03:21:20PM +0000, Pratyush Anand wrote:
> instruction_pointer_set is needed for uprobe implementation. Hence
> define it for ARM64.
> 
> Signed-off-by: Pratyush Anand <panand@redhat.com>
> ---
>  arch/arm64/include/asm/ptrace.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index 24cc048ac3e7..29d9bf5e3635 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -206,6 +206,12 @@ static inline int valid_user_regs(struct user_pt_regs *regs)
>  #define instruction_pointer(regs)	((regs)->pc)
>  #define stack_pointer(regs)		((regs)->sp)
>  
> +static inline void instruction_pointer_set(struct pt_regs *regs,
> +					   unsigned long val)
> +{
> +	instruction_pointer(regs) = val;
> +}

Do you think we could make use of the asm-generic ptrace header to get
this for free? afaict, we just need to implement GET_USP and possibly
GET_FP for the compat case (although it may well be that we still handle
the compat case entirely separately).

Will
