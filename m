Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaBGOoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:44:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaBGOoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:44:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, wad@chromium.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org, arndb@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: Add seccomp support
Date: Fri, 07 Feb 2014 15:44:15 +0100
Message-ID: <2659759.AA5HtBcWYl@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1391767892-5395-2-git-send-email-takahiro.akashi@linaro.org>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org> <1391767892-5395-2-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JfQEvkfEhBeJOFvk05V3Uom6Yb8mF8pus1Af7xKZTUP
 81OjGqALLQpfSyLaGNba1lYyEE5pyEAA6gDYt9i0ewsTWOykau
 NoImWBBFIFmClvQZqrH0B9xKciHxtKtoUI0LoJyVO+4U9A5Tyk
 vNYr9HEmUL0cRcyLBMRwpT2WLsODaLrA0aOqImRf2H+NsnyBpc
 qwb/Fek08wjkjT5clj1JO7fIYZLA3suFv002ukIPFaItb9qdYA
 BDCXExAGeo+GVn9vl7zL98v54H1ybshRhYcQzhhIy/p7jkjx5u
 B09S4qqeY3kY1YneUJijAPp9cH7sbl+xAT8TPsbDEnRsMxR6da
 AN7st8dfffMXzKtM4f2w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 February 2014 19:11:31 AKASHI Takahiro wrote:
> diff --git a/arch/arm64/include/asm/seccomp.h b/arch/arm64/include/asm/seccomp.h
> new file mode 100644
> index 0000000..3482155
> --- /dev/null
> +++ b/arch/arm64/include/asm/seccomp.h
> @@ -0,0 +1,28 @@
> +/*
> + * arch/arm64/include/asm/seccomp.h
> + *
> + * Copyright (C) 2014 Linaro Limited
> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef _ASM_SECCOMP_H
> +#define _ASM_SECCOMP_H
> +
> +#include <asm/unistd.h>
> +
> +#ifdef CONFIG_COMPAT
> +#define __NR_seccomp_read_32           __NR_compat_read
> +#define __NR_seccomp_write_32          __NR_compat_write
> +#define __NR_seccomp_exit_32           __NR_compat_exit
> +#define __NR_seccomp_sigreturn_32      __NR_compat_sigreturn
> +#endif /* CONFIG_COMPAT */
> +
> +#define __NR_seccomp_read              __NR_read
> +#define __NR_seccomp_write             __NR_write
> +#define __NR_seccomp_exit              __NR_exit
> +#define __NR_seccomp_sigreturn         __NR_rt_sigreturn
> +
> +#endif /* _ASM_SECCOMP_H */
> 

This file looks extremely generic and can be shared by every
architecture other than MIPS for all I can tell.

Please add it to include/asm-generic instead of arch/arm64,
and add a line to arch/arm64/include/asm/Kbuild.

	Arnd
