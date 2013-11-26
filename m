Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3KZAJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:09:56 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:51301 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KZAJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:09:55 -0500
Message-ID: <5293E6D0.3050604@gmail.com>
Date: Mon, 25 Nov 2013 16:09:52 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: Fix build error seen in some configurations
References: <1385421660-5608-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1385421660-5608-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 03:21 PM, Guenter Roeck wrote:
> The following build error is seen if CONFIG_32BIT is undefined,
> CONFIG_64BIT is defined, and CONFIG_MIPS32_O32 is undefined.
>
> asm/syscall.h: In function 'mips_get_syscall_arg':
> arch/mips/include/asm/syscall.h:32:16: error: unused variable 'usp' [-Werror=unused-variable]
> cc1: all warnings being treated as errors
>
> Fixes: c0ff3c53d4f9 ('MIPS: Enable HAVE_ARCH_TRACEHOOK')
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: David Daney <david.daney@cavium.com>

> ---
>   arch/mips/include/asm/syscall.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
> index 81c8913..33e8dbf 100644
> --- a/arch/mips/include/asm/syscall.h
> +++ b/arch/mips/include/asm/syscall.h
> @@ -29,7 +29,7 @@ static inline long syscall_get_nr(struct task_struct *task,
>   static inline unsigned long mips_get_syscall_arg(unsigned long *arg,
>   	struct task_struct *task, struct pt_regs *regs, unsigned int n)
>   {
> -	unsigned long usp = regs->regs[29];
> +	unsigned long usp __maybe_unused = regs->regs[29];
>
>   	switch (n) {
>   	case 0: case 1: case 2: case 3:
>

