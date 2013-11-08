Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3KHBeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:34:15 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:57701 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab3KHBeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:34:13 -0500
MIME-Version: 1.0
In-Reply-To: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org>
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 7 Nov 2013 19:34:13 -0600
Message-ID: <CAL_JsqJ9zbJFJePk2FHH8UhrUP2J7fuuiZLb+NhuTovRodqrCA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
From: Rob Herring <robherring2@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 1:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> If we're running on a v7 ARM CPU, detect if the CPU supports the
> sdiv/udiv instructions and replace the signed and unsigned
> division library functions with an sdiv/udiv instruction.

[snip]

> diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> index bd454b0..6ed6496 100644
> --- a/arch/arm/lib/Makefile
> +++ b/arch/arm/lib/Makefile
> @@ -15,6 +15,9 @@ lib-y         := backtrace.o changebit.o csumipv6.o csumpartial.o   \
>                    io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
>                    call_with_stack.o
>
> +lib-$(CONFIG_CPU_V7) += div-v7.o
> +CFLAGS_div-v7.o := -march=armv7-a

Won't this fail to build if the compiler doesn't have armv7-a support.
Perhaps we don't care about compilers that old.

Rob
