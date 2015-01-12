Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbbALVSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:18:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbbALVSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:18:09 -0500
Date: Mon, 12 Jan 2015 22:18:02 +0100
From: Borislav Petkov <bp@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, oleg@redhat.com, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 01/11] x86,fpu: document the data structures a little
Message-ID: <20150112211802.GE5016@pd.tnic>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
 <1421012793-30106-2-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421012793-30106-2-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 04:46:23PM -0500, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Add some documentation to data structures used for FPU context
> switching.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  arch/x86/include/asm/processor.h | 9 +++++++--
>  arch/x86/kernel/cpu/common.c     | 1 +
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index a092a0c..17bd8a0 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -400,6 +400,11 @@ struct xsave_struct {
>  	/* new processor state extensions will go here */
>  } __attribute__ ((packed, aligned (64)));
>  
> +/*
> + * The FPU state used depends on the capabilities of the hardware; the
> + * registers used for vector instructions on newer hardware are included
> + * in the FPU state.
> + */
>  union thread_xstate {
>  	struct i387_fsave_struct	fsave;
>  	struct i387_fxsave_struct	fxsave;
> @@ -408,8 +413,8 @@ union thread_xstate {
>  };
>  
>  struct fpu {
> -	unsigned int last_cpu;
> -	unsigned int has_fpu;
> +	unsigned int last_cpu;		/* FPU state last loaded on this CPU */

Isn't that the last CPU which had the FPU?

> +	unsigned int has_fpu;		/* FPU state in current use on CPU */

I understand ->has_fpu as this thread has the FPU. See comment over
user_has_fpu().

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
