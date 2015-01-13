Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbbAMR7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:59:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbbAMR7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:59:03 -0500
Date: Tue, 13 Jan 2015 18:58:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to
	userspace
Message-ID: <20150113175804.GA29851@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-5-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-5-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, riel@redhat.com wrote:
>
> Defer restoring the FPU state, if so desired, until the task returns to
> userspace.

And yet another concern ;) Although I feel that I am totally confused and
probably wrong.

> --- a/arch/x86/include/asm/fpu-internal.h
> +++ b/arch/x86/include/asm/fpu-internal.h
> @@ -382,6 +382,7 @@ static inline void drop_init_fpu(struct task_struct *tsk)
>  		else
>  			fxrstor_checking(&init_xstate_buf->i387);
>  	}
> +	clear_thread_flag(TIF_LOAD_FPU);
>  }

OK, but shouldn't (say) restore_user_xstate() clear TIF_LOAD_FPU too?
Otherwise, can't switch_fpu_finish() restore the wrong context later?

Or. Perhaps switch_fpu_finish() should do nothing if fpu.has_fpu == T,
I dunno.

Oleg.

