Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbbATFqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:46:19 -0500
Received: from ozlabs.org ([103.22.144.67]:55449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbbATFqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:46:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH 7/8] module: add core_param_unsafe
In-Reply-To: <1421451197-19723-8-git-send-email-dmitry.torokhov@gmail.com>
References: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com> <1421451197-19723-8-git-send-email-dmitry.torokhov@gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Jan 2015 16:13:38 +1030
Message-ID: <87vbk2atx1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> Similarly to module_param_unsafe(), add the helper to be used by core
> code wishing to expose unsafe debugging or testing parameters that taint
> the kernel when set.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.

> ---
>  include/linux/moduleparam.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 1392370..6480dca 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -310,6 +310,15 @@ static inline void __kernel_param_unlock(void)
>  #define core_param(name, var, type, perm)				\
>  	param_check_##type(name, &(var));				\
>  	__module_param_call("", name, &param_ops_##type, &var, perm, -1, 0)
> +
> +/**
> + * core_param_unsafe - same as core_param but taints kernel
> + */
> +#define core_param_unsafe(name, var, type, perm)		\
> +	param_check_##type(name, &(var));				\
> +	__module_param_call("", name, &param_ops_##type, &var, perm,	\
> +			    -1, KERNEL_PARAM_FL_UNSAFE)
> +
>  #endif /* !MODULE */
>  
>  /**
> -- 
> 2.2.0.rc0.207.ga3a616c
