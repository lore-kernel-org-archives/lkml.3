Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaIKWNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:13:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:43876 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaIKWNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:13:48 -0400
Date: Fri, 12 Sep 2014 00:13:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 06/10] mips: sync struct siginfo with general
 version
In-Reply-To: <1410425210-24789-7-git-send-email-qiaowei.ren@intel.com>
Message-ID: <alpine.DEB.2.10.1409120007550.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-7-git-send-email-qiaowei.ren@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Qiaowei Ren wrote:

> Due to new fields about bound violation added into struct siginfo,
> this patch syncs it with general version to avoid build issue.

You completely fail to explain which build issue is addressed by this
patch. The code you added to kernel/signal.c which accesses _addr_bnd
is guarded by

+#ifdef SEGV_BNDERR

which is not defined my MIPS. Also why is this only affecting MIPS and
not any other architecture which provides its own struct siginfo ?

That patch makes no sense at all, at least not without a proper
explanation.

Thanks,

	tglx

> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/mips/include/uapi/asm/siginfo.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/include/uapi/asm/siginfo.h b/arch/mips/include/uapi/asm/siginfo.h
> index e811744..d08f83f 100644
> --- a/arch/mips/include/uapi/asm/siginfo.h
> +++ b/arch/mips/include/uapi/asm/siginfo.h
> @@ -92,6 +92,10 @@ typedef struct siginfo {
>  			int _trapno;	/* TRAP # which caused the signal */
>  #endif
>  			short _addr_lsb;
> +			struct {
> +				void __user *_lower;
> +				void __user *_upper;
> +			} _addr_bnd;
>  		} _sigfault;
>  
>  		/* SIGPOLL, SIGXFSZ (To do ...)	 */
> -- 
> 1.7.1
> 
> 
