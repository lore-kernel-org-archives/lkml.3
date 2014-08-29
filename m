Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaH2UvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:51:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42735 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaH2UvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:51:07 -0400
Message-ID: <5400E7B8.9050906@codeaurora.org>
Date: Fri, 29 Aug 2014 13:51:04 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] nosave: Consolidate __nosave_{begin,end} in <asm/sections.h>
References: <1409343731-5292-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1409343731-5292-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/14 13:22, Geert Uytterhoeven wrote:
> The different architectures used their own (and different) declarations:
>
>     extern __visible const void __nosave_begin, __nosave_end;
>     extern const void __nosave_begin, __nosave_end;
>     extern long __nosave_begin, __nosave_end;
>
> Consolidate them using the first variant in <asm/sections.h>.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> This has been sent before, as part of the series "[PATCH 00/17] <asm/sections.h>
> related cleanups", almost one year ago (https://lkml.org/lkml/2013/11/12/510).
>
>  arch/mips/include/asm/suspend.h   | 7 -------
>  arch/mips/power/cpu.c             | 2 +-
>  arch/powerpc/kernel/suspend.c     | 4 +---
>  arch/s390/kernel/suspend.c        | 6 +-----
>  arch/sh/include/asm/sections.h    | 1 -
>  arch/sparc/power/hibernate.c      | 4 +---
>  arch/unicore32/include/mach/pm.h  | 3 ---
>  arch/unicore32/kernel/hibernate.c | 1 +
>  arch/x86/power/hibernate_32.c     | 4 +---
>  arch/x86/power/hibernate_64.c     | 4 +---
>  include/asm-generic/sections.h    | 4 ++++
>  11 files changed, 11 insertions(+), 29 deletions(-)
>  delete mode 100644 arch/mips/include/asm/suspend.h
>

There's one in arch/arm/kernel/hibernate.c now. Can we update ARM too?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

