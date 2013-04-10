Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3DJEkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 00:40:16 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:54644 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3DJEkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 00:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <m2k3ob1tar.fsf_-_@igel.home>
References: <CA+V-a8vYsBLVH-3Bm35Sv9K9ZMTcMB4_P_V3kBjyuEKDozPi5w@mail.gmail.com>
 <1363949290.3528.37.camel@linaro1.home> <m2ip48d62f.fsf@igel.home>
 <CA+V-a8srtwdf1H2JQwbkyMFhXopPEA90RM8Hy+UunM6Mm7-d1w@mail.gmail.com> <m2k3ob1tar.fsf_-_@igel.home>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 10 Apr 2013 10:09:51 +0530
Message-ID: <CA+V-a8th2UnnHf5wNyKg-w30yiJAsPv_BR6bspHe_Tbf4ri_Zw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: generate generic headers before recursing into scripts
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 11:27 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> The headers are now needed inside scripts/mod since 6543bec
> ("mod/file2alias: make modalias generation safe for cross compiling").
>
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Reported-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar

> ---
> Prabhakar Lad <prabhakar.csengg@gmail.com> writes:
>
>> Whats the status of it ?
>
> I think it has sufficiently been tested by now.
>
> Andreas.
> ---
>  Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 6db672b..11157bd 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -513,7 +513,8 @@ ifeq ($(KBUILD_EXTMOD),)
>  # Carefully list dependencies so we do not try to build scripts twice
>  # in parallel
>  PHONY += scripts
> -scripts: scripts_basic include/config/auto.conf include/config/tristate.conf
> +scripts: scripts_basic include/config/auto.conf include/config/tristate.conf \
> +        asm-generic
>         $(Q)$(MAKE) $(build)=$(@)
>
>  # Objects we will link into vmlinux / subdirs we need to visit
> --
> 1.8.2.1
>
>
> --
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
> "And now for something completely different."
