Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaBVMKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 07:10:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbaBVMKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 07:10:14 -0500
Message-ID: <5308938A.8070506@redhat.com>
Date: Sat, 22 Feb 2014 13:09:46 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, davem@davemloft.net,
        ffusco@redhat.com, tgraf@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com>
In-Reply-To: <53073986020000780011E2E1@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 11:33 AM, Jan Beulich wrote:
> ... to match its two callers (i.e. the alternative would have been to
> swap the arguments at the call sites).
>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Francesco Fusco <ffusco@redhat.com>
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Cc: Thomas Graf <tgraf@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>   arch/x86/lib/hash.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- 3.14-rc3-x86-hash-crc32.orig/arch/x86/lib/hash.c
> +++ 3.14-rc3-x86-hash-crc32/arch/x86/lib/hash.c
> @@ -37,7 +37,7 @@
>   #include <asm/cpufeature.h>
>   #include <asm/hash.h>
>
> -static inline u32 crc32_u32(u32 crc, u32 val)
> +static inline u32 crc32_u32(u32 val, u32 crc)
>   {
>   #ifdef CONFIG_AS_CRC32
>   	asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));

Can you elaborate?

Sorry, I need to ask here (even if it's a stupid question ;)) if this
change is safe to do; are referring to a cleanup or fixing a concrete
bug? The code is a modified version of the DPDK hash which you can find
in [1]. Arguments of the caller are in the correct order, afaik.

   [1] http://dpdk.org/browse/dpdk/tree/lib/librte_hash/rte_hash_crc.h
