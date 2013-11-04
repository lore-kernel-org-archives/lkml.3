Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3KDMMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:12:02 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64670 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3KDMMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:12:00 -0500
MIME-Version: 1.0
In-Reply-To: <CANXG-LJ699jUyw19pVnSdAtXdHof4u+YRnvK1A6O9MMrtu+X0Q@mail.gmail.com>
References: <CANXG-LJ699jUyw19pVnSdAtXdHof4u+YRnvK1A6O9MMrtu+X0Q@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 4 Nov 2013 12:11:40 +0000
X-Google-Sender-Auth: zNRwhV8aPz5emWyFBYjnUBvaNo4
Message-ID: <CAHkRjk7N8-f5_oEkowqMRgppZQTQDxsR_OYGEhtjS34cTjw2=g@mail.gmail.com>
Subject: Re: [Patch] arm/arm64: Thumb=>ARM signal handling setup skips the a
 few instructions on Snapdragon S4/Krait
To: "T.J. Purtell" <tj@mobisocial.us>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rodrigo Kumpera <kumpera@xamarin.com>, Mark Probst <mark@xamarin.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing the Linux ARM kernel list)

On 25 October 2013 05:54, T.J. Purtell <tj@mobisocial.us> wrote:
> The ARM architecture reference specifies that the IT state bits in the
> PSR must be all zeros in ARM mode or behavior is unspecified.  On the
> Qualcomm Snapdragon S4/Krait architecture CPUs the processor continues
> to consider the IT state bits while in ARM mode.  This makes it so
> that some instructions are skipped by the CPU.

Good catch.

> diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
> index e393174..8f6c3be 100644
> --- a/arch/arm64/kernel/signal32.c
> +++ b/arch/arm64/kernel/signal32.c
> @@ -474,9 +474,11 @@ static void compat_setup_return(struct pt_regs
> *regs, struct k_sigaction *ka,
>   /* Check if the handler is written for ARM or Thumb */
>   thumb = handler & 1;
>
> + /* ARM spec requires this to be all 000s in ARM mode */
> + spsr &= ~COMPAT_PSR_IT_MASK;
> +
>   if (thumb) {
>   spsr |= COMPAT_PSR_T_BIT;
> - spsr &= ~COMPAT_PSR_IT_MASK;
>   } else {
>   spsr &= ~COMPAT_PSR_T_BIT;
>   }

Please send me a separate arm64 patch, I'll push it via my tree (and
cc stable as well).

Catalin
