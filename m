Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaIFONi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 10:13:38 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50725 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaIFONc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 10:13:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: behanw@converseincode.com, catalin.marinas@arm.com, jays.lee@samsung.com,
        will.deacon@arm.com, kgene.kim@samsung.com, steve.capper@linaro.org,
        linux-kernel@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>,
        sungjinn.chung@samsung.com
Subject: Re: [PATCH] arm64: LLVMLinux: Add missing abort() for AARCH64
Date: Sat, 06 Sep 2014 16:12:57 +0200
Message-ID: <53558632.2D4ZDSZcaf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409959302-13976-1-git-send-email-behanw@converseincode.com>
References: <1409959302-13976-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:th7OK/lnrO5PjLh8lMtjdKQ4WDI0xg6bcAqKTfYkAB8
 QoBsG1MAU9Ozap3Nq7FI3Il5b2iNBuDxLBjwYS0J9Edaqm78Ni
 sxRGKaKHpjbN+g26+LziITSyjHQDgdghzU/wx1kgjnEq7dJZ2L
 ftw6SHM4XpNHXxpGUjby/hZqiB+rdEz6aobqlV0h0P+gss6X++
 tQWIfpTg+gBpHjP48Gwop1oqQVVLvIJNQOet4aA6zK/CSDaIDh
 OrtQk51TiVpB/u98jGJtWQQ2ThxMIHd1861W0NFJa9BPkzmW/j
 Y6QZOcLHgtBnaPsxCr2kS4739TCElPueR8IrWG29JL9rAudznT
 ZrMH7jcLFq792lFyZWwU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 16:21:42 behanw@converseincode.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
> 
> Add missing abort for arch aarch64.
> 
> This patch makes the aarch64 kernel able to compile with gcc or clang.
> 
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>

You don't describe why this is needed. When does clang emit an abort()
call? Is that the expected behavior when not linking against a full
C library?

>  arch/arm64/kernel/traps.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 02cd3f0..123cd6e 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -349,6 +349,15 @@ void __pgd_error(const char *file, int line, unsigned long val)
>         pr_crit("%s:%d: bad pgd %016lx.\n", file, line, val);
>  }
>  
> +void abort(void)
> +{
> +       BUG();
> +
> +       /* if that doesn't kill us, halt */
> +       panic("Oops failed to kill thread");
> +}
> +EXPORT_SYMBOL(abort);

I don't see the point in doing both BUG() and panic(). Doesn't panic()
already print all the information you want in this case?

	Arnd
