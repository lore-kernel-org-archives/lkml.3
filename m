Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaJZSiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 14:38:46 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:60241 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJZSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 14:38:45 -0400
Date: Sun, 26 Oct 2014 19:38:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] all arches, signal: Move restart_block to struct
 task_struct
Message-ID: <20141026183826.GA18348@ravnborg.org>
References: <90d5683679179df27ffeef18c3e1010ed4e72695.1414342681.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90d5683679179df27ffeef18c3e1010ed4e72695.1414342681.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
> index 025c98446b1e..88719dbb12f5 100644
> --- a/arch/sparc/include/asm/thread_info_32.h
> +++ b/arch/sparc/include/asm/thread_info_32.h
> @@ -62,9 +62,6 @@ struct thread_info {
>  	.flags		=	0,			\
>  	.cpu		=	0,			\
>  	.preempt_count	=	INIT_PREEMPT_COUNT,	\
> -	.restart_block	= {				\
> -		.fn	=	do_no_restart_syscall,	\
> -	},						\
>  }
If this is deleted then the corresponding TI_RESTART_BLOCK should go as well


>  
>  #define init_thread_info	(init_thread_union.thread_info)
> diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
> index 798f0279a4b5..a11f1e551a58 100644
> --- a/arch/sparc/include/asm/thread_info_64.h
> +++ b/arch/sparc/include/asm/thread_info_64.h
> @@ -124,9 +124,6 @@ struct thread_info {
>  	.current_ds	=	ASI_P,			\
>  	.exec_domain	=	&default_exec_domain,	\
>  	.preempt_count	=	INIT_PREEMPT_COUNT,	\
> -	.restart_block	= {				\
> -		.fn	=	do_no_restart_syscall,	\
> -	},						\
>  }
When thread_info is modified the relevant TI_ constants needs to be updated.
And TI_RESTART_BLOCK shold be killed as it is no longer relevant.

This stuff is caught only at run-time - and not at build time which would
have been better.

	Sam
