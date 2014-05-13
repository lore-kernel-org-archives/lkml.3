Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbaEMJt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:49:29 -0400
Received: from mail.southpole.se ([37.247.8.11]:55793 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760100AbaEMJtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:49:16 -0400
X-Greylist: delayed 1146 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2014 05:49:16 EDT
Message-ID: <5371E62F.9090203@southpole.se>
Date: Tue, 13 May 2014 11:30:23 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: lftan.linux@gmail.com, cltang@codesourcery.com, linux@openrisc.net
Subject: Re: [PATCH 16/25] openrisc: Add 32 bit time_t and clock_t
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <1399971958-4561-1-git-send-email-lftan@altera.com>
In-Reply-To: <1399971958-4561-1-git-send-email-lftan@altera.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.4.1(14097) on assp.southpole.se
X-Assp-ID: assp.southpole.se 73406-00162
X-Assp-Session: 7FF4E00483A8 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 11:05 AM, Ley Foon Tan wrote:
> Override time_t and clock_t in include/uapi/asm-generic.
> 
> diff --git a/arch/openrisc/include/uapi/asm/posix_types.h b/arch/openrisc/include/uapi/asm/posix_types.h
> new file mode 100644
> index 0000000..5ccf37d
> --- /dev/null
> +++ b/arch/openrisc/include/uapi/asm/posix_types.h
> @@ -0,0 +1,17 @@
> +#ifndef __ARCH_OPENRISC_POSIX_TYPES_H
> +#define __ARCH_OPENRISC_POSIX_TYPES_H
> +
> +/*
> + * This file is generally used by user-level software, so you need to
> + * be a little careful about namespace pollution etc. Also, we cannot
> + * assume GCC is being used.
> + */

I don't think the above comment needs to be copied to this file... given
that the file is in the uapi/ directory, we know the file is exported to
userspace, and the GCC comment isn't relevant given the rest of the
files contents.

But that's really just a nit!  Nice work, otherwise.

Acked-by: Jonas Bonn <jonas@southpole.se>

> +typedef long	__kernel_time_t;
> +#define __kernel_time_t __kernel_time_t
> +
> +typedef long	__kernel_clock_t;
> +#define __kernel_clock_t __kernel_clock_t
> +
> +#include <asm-generic/posix_types.h>
> +
> +#endif
> 
