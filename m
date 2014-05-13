Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaEMUSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:18:16 -0400
Received: from mout.gmx.net ([212.227.17.21]:58859 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaEMUSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:18:07 -0400
Message-ID: <53727DE8.7000105@gmx.de>
Date: Tue, 13 May 2014 22:17:44 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: lftan.linux@gmail.com, cltang@codesourcery.com,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH 17/25] parisc: Add 32 bit time_t and clock_t
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <1399971966-4598-1-git-send-email-lftan@altera.com>
In-Reply-To: <1399971966-4598-1-git-send-email-lftan@altera.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:s+tcSkS9iZc7r1wr9F+mwEsQ8Vn27Dj4IlV372Mtg2s9CvYdHA2
 BPzgD7xrOyzCvl0V/jhs4Y57AIB/OkOPodSWEaJKpFKTtwcMOJFbZfbKltQXoQf4RY7Vr7k
 UwCKAXZ7ipjsFyEuDlAfcZmpBnh0clH+VtR6S9HvVraoMQ2HXnxWEPYJq3kaIsQtCCtXX7L
 4SufCc6ZvQN/Bc7MCwgMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ley,

On 05/13/2014 11:06 AM, Ley Foon Tan wrote:
> Override time_t and clock_t in include/uapi/asm-generic.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  arch/parisc/include/uapi/asm/posix_types.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/parisc/include/uapi/asm/posix_types.h b/arch/parisc/include/uapi/asm/posix_types.h
> index b934425..21fcf1c 100644
> --- a/arch/parisc/include/uapi/asm/posix_types.h
> +++ b/arch/parisc/include/uapi/asm/posix_types.h
> @@ -19,6 +19,14 @@ typedef int			__kernel_suseconds_t;
>  typedef long long		__kernel_off64_t;
>  typedef unsigned long long	__kernel_ino64_t;
>  
> +#ifndef CONFIG_64BIT

We can't use CONFIG_64BIT for a userspace header file. Please use 
#if !defined(__LP64__)
instead.
But even then I'm not sure if it's all correct...

Helge 

> +typedef long	__kernel_time_t;
> +#define __kernel_time_t __kernel_time_t
> +
> +typedef long	__kernel_clock_t;
> +#define __kernel_clock_t __kernel_clock_t
> +#endif
> +
>  #include <asm-generic/posix_types.h>
>  
>  #endif
> 

