Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966195AbaFTJyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:54:31 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:24548 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815AbaFTJya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:54:30 -0400
Message-ID: <53A404D2.3030303@imgtec.com>
Date: Fri, 20 Jun 2014 10:54:26 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sorin Dumitru <sdumitru@ixiacom.com>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>
CC: <ralf@linux-mips.org>
Subject: Re: [PATCH] mips: n32: use compat getsockopt syscall
References: <1403250786-9763-1-git-send-email-sdumitru@ixiacom.com>
In-Reply-To: <1403250786-9763-1-git-send-email-sdumitru@ixiacom.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/14 08:53, Sorin Dumitru wrote:
> Signed-off-by: Sorin Dumitru <sdumitru@ixiacom.com>

A little more commit message wouldn't hurt. Did it break a particular
program?

It's consistent with compat_sys_socketcall(), include/uapi/asm/unistd.h,
and commit 515c7af85ed9 (which does same thing for x32) though so it
looks good to me.

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
>  arch/mips/kernel/scall64-n32.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
> index c1dbcda..e543861 100644
> --- a/arch/mips/kernel/scall64-n32.S
> +++ b/arch/mips/kernel/scall64-n32.S
> @@ -162,7 +162,7 @@ EXPORT(sysn32_call_table)
>  	PTR	sys_getpeername
>  	PTR	sys_socketpair
>  	PTR	compat_sys_setsockopt
> -	PTR	sys_getsockopt
> +	PTR	compat_sys_getsockopt
>  	PTR	__sys_clone			/* 6055 */
>  	PTR	__sys_fork
>  	PTR	compat_sys_execve
> 
