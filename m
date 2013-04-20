Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3DTWNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 18:13:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab3DTWNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 18:13:45 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=HDHRMR3qEqgA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=uejNskSoYpIA:10 a=cm27Pg_UAAAA:8 a=pGLkceISAAAA:8 a=DfNHnWVPAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=l_iSkseOcH3F4hjkPakA:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=zv9_9hqRWm8A:10 a=MSl-tDqOz04A:10 a=lBRciGGoxdUA:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Sat, 20 Apr 2013 17:14:42 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] signal: stop info leak via the tkill and the tgkill
 syscalls
Message-ID: <20130420221442.GB25043@austin.hallyn.com>
References: <1366226365-15594-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366226365-15594-1-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> From: Emese Revfy <re.emese@gmail.com>
> 
> This fixes a kernel memory contents leak via the tkill and tgkill syscalls
> for compat processes.
> 
> This is visible in the siginfo_t->_sifields._rt.si_sigval.sival_ptr field
> when handling signals delivered from tkill.
> 
> The place of the infoleak:
> 
> int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
> {
>         ...
>         put_user_ex(ptr_to_compat(from->si_ptr), &to->si_ptr);
>         ...
> }
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

Sorry, not sure if this is applied yet,

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Reviewed-by: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> ---
>  kernel/signal.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index dd72567..598dc06 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2948,7 +2948,7 @@ do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
>  
>  static int do_tkill(pid_t tgid, pid_t pid, int sig)
>  {
> -	struct siginfo info;
> +	struct siginfo info = {};
>  
>  	info.si_signo = sig;
>  	info.si_errno = 0;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
