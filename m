Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3EaOn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:43:27 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62447 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3EaOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130505220822.GA7819@p100.box>
References: <20130505220822.GA7819@p100.box>
Date: Fri, 31 May 2013 17:43:19 +0300
Message-ID: <CAG8Ei1o51ErECB9Y=hQKFmz=CtRjm=BPZ3FcF_1pt1MiqWy2UQ@mail.gmail.com>
Subject: Re: [PATCH] MPILIB: disable usage of floating point registers on parisc
From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. I am not at @intel.com any more. Did not see it.
Will handle.

- Dmitry


On Mon, May 6, 2013 at 1:08 AM, Helge Deller <deller@gmx.de> wrote:
> The umul_ppmm() macro for parisc uses the xmpyu assembler statement
> which does calculation via a floating point register.
>
> But usage of floating point registers inside the Linux kernel are not
> allowed and gcc will stop compilation due to the -mdisable-fpregs
> compiler option.
>
> Fix this by disabling the umul_ppmm() and udiv_qrnnd() macros. The
> mpilib will then use the generic built-in implementations instead.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
>
> diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
> index 095ab15..d411355 100644
> --- a/lib/mpi/longlong.h
> +++ b/lib/mpi/longlong.h
> @@ -318,7 +318,8 @@ extern UDItype __udiv_qrnnd();
>              "rM" ((USItype)(bh)), \
>              "rM" ((USItype)(al)), \
>              "rM" ((USItype)(bl)))
> -#if defined(_PA_RISC1_1)
> +#if 0 && defined(_PA_RISC1_1)
> +/* xmpyu uses floating point register which is not allowed in Linux kernel. */
>  #define umul_ppmm(wh, wl, u, v) \
>  do { \
>         union {UDItype __ll; \
> @@ -337,7 +338,7 @@ do { \
>  #define UMUL_TIME 40
>  #define UDIV_TIME 80
>  #endif
> -#ifndef LONGLONG_STANDALONE
> +#if 0 /* #ifndef LONGLONG_STANDALONE */
>  #define udiv_qrnnd(q, r, n1, n0, d) \
>  do { USItype __r; \
>         (q) = __udiv_qrnnd(&__r, (n1), (n0), (d)); \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
