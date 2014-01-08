Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbaAHUHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:07:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119AbaAHUHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:07:00 -0500
Date: Wed, 8 Jan 2014 15:06:52 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, dsaxena@linaro.org,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] audit: correct a type mismatch in audit_syscall_exit()
Message-ID: <20140108200652.GA23577@madcap2.tricolour.ca>
References: <1387938953-15667-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387938953-15667-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/25, AKASHI Takahiro wrote:
> audit_syscall_exit() saves a result of regs_return_value() in intermediate
> "int" variable and passes it to __audit_syscall_exit(), which expects its
> second argument as a "long" value.
> This will result in truncating the value returned by a system call and
> making a wrong audit record.
> I don't know why gcc compiler doesn't complain about this, but anyway it
> causes a problem at runtime on arm64 (and probably most 64-bit archs).
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

Thanks for catching this, Takakiro.

> ---
>  include/linux/audit.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index c49a312..3dcb3f0 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -144,7 +144,7 @@ static inline void audit_syscall_exit(void *pt_regs)
>  {
>  	if (unlikely(current->audit_context)) {
>  		int success = is_syscall_success(pt_regs);
> -		int return_code = regs_return_value(pt_regs);
> +		long return_code = regs_return_value(pt_regs);
>  
>  		__audit_syscall_exit(success, return_code);
>  	}

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
