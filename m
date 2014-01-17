Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaAQTuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:50:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaAQTt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:49:59 -0500
Date: Fri, 17 Jan 2014 14:42:24 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, arndb@arndb.de,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        patches@linaro.org
Subject: Re: [PATCH] audit: Modify a set of system calls in audit class
 definitions
Message-ID: <20140117194224.GB7084@madcap2.tricolour.ca>
References: <1389945903-4326-1-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389945903-4326-1-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/17, AKASHI Takahiro wrote:
> Each asm-generic/audit_xx.h defines a set of system calls for respective
> audit permssion class (read, write, change attribute or exec).
> This patch changes two entries:
> 
> 1) fchown in audit_change_attr.h
>   Make fchown included by its own because in asm-generic/unistd.h, for example,
>   fchown always exists while chown is optional. This change is necessary at
>   least for arm64.
> 
> 2) truncate64 in audit_write.h
>   Add missing truncate64/ftruncate64 as well as truncate/ftruncate
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  include/asm-generic/audit_change_attr.h |    4 +++-
>  include/asm-generic/audit_write.h       |    6 ++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/audit_change_attr.h b/include/asm-generic/audit_change_attr.h
> index 89b73e5..a186553 100644
> --- a/include/asm-generic/audit_change_attr.h
> +++ b/include/asm-generic/audit_change_attr.h
> @@ -4,9 +4,11 @@ __NR_chmod,
>  __NR_fchmod,
>  #ifdef __NR_chown
>  __NR_chown,
> -__NR_fchown,
>  __NR_lchown,
>  #endif
> +#ifdef __NR_fchown
> +__NR_fchown,
> +#endif
>  __NR_setxattr,
>  __NR_lsetxattr,
>  __NR_fsetxattr,
> diff --git a/include/asm-generic/audit_write.h b/include/asm-generic/audit_write.h
> index e7020c5..274575d 100644
> --- a/include/asm-generic/audit_write.h
> +++ b/include/asm-generic/audit_write.h
> @@ -10,6 +10,12 @@ __NR_truncate,
>  #ifdef __NR_truncate64
>  __NR_truncate64,
>  #endif
> +#ifdef __NR_ftruncate
> +__NR_ftruncate,
> +#endif
> +#ifdef __NR_ftruncate64
> +__NR_ftruncate64,
> +#endif
>  #ifdef __NR_bind
>  __NR_bind,		/* bind can affect fs object only in one way... */
>  #endif
> -- 
> 1.7.9.5
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
