Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaEOVbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:31:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:29177 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbaEOVbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:31:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1062,1389772800"; 
   d="scan'208";a="541232242"
From: Andi Kleen <andi@firstfloor.org>
To: Erik Bosman <erik@minemu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: SROP mitigation: implement signal canaries
References: <20140515211004.GA9575@pizzadoos.com>
Date: Thu, 15 May 2014 14:31:40 -0700
In-Reply-To: <20140515211004.GA9575@pizzadoos.com> (Erik Bosman's message of
	"Thu, 15 May 2014 23:10:04 +0200")
Message-ID: <87vbt6rao3.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Bosman <erik@minemu.org> writes:

>  
> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
> index 2206757..1a9285a 100644
> --- a/arch/x86/ia32/ia32_signal.c
> +++ b/arch/x86/ia32/ia32_signal.c
> @@ -212,9 +212,18 @@ asmlinkage long sys32_sigreturn(void)
>  	struct sigframe_ia32 __user *frame = (struct sigframe_ia32 __user *)(regs->sp-8);
>  	sigset_t set;
>  	unsigned int ax;
> +#ifdef CONFIG_SIGNAL_CANARY
> +	u32 canary;
> +#endif

Don't you completely break the ABI here? I'm sure there are programs out
there who hard code the offset into the FP state.

I think you either need to put it at the total end or somewhere
currently unused

Besides that I would remove the CONFIG_* once it works and just do it
unconditionally.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
