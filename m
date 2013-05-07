Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3EGLU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:20:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33490 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab3EGLU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:20:57 -0400
Date: Tue, 7 May 2013 13:20:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable A20 gate
Message-ID: <20130507112053.GA21162@gmail.com>
References: <CANymLzXWFy8N6cthuU7U6oywURFSoqeT4RnYvcxSrkM8bn7nMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANymLzXWFy8N6cthuU7U6oywURFSoqeT4RnYvcxSrkM8bn7nMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Syed Salman Mansoor <syed.salman.mansoor@gmail.com> wrote:

> From a5e4cd6cb1956d288b5a001f60699dc8b5528963 Mon Sep 17 00:00:00 2001
> From: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
> Date: Tue, 7 May 2013 12:49:24 +0500
> Subject: [PATCH] Enable A20 gate
>  This is a patch to the a20.c file that fixes following
> warnings/errors found by the checkpatch.pl tool
>  i)  WARNING: please, no spaces at the start of a line
>  ii) WARNING: suspect code indent for conditional statements
>  iii) ERROR: trailing whitespace
> Signed-off-by: Syed Salman Mansoor <syed.salman.mansoor@gmail.com>
> 
> ---
>  arch/x86/boot/a20.c |   46 +++++++++++++++++++++++-----------------------
>  1 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
> index 64a31a6..911d729 100644
> --- a/arch/x86/boot/a20.c
> +++ b/arch/x86/boot/a20.c
> @@ -129,37 +129,37 @@ static void enable_a20_fast(void)
> 
>  int enable_a20(void)
>  {
> -       int loops = A20_ENABLE_LOOPS;
> -       int kbc_err;
> + int loops = A20_ENABLE_LOOPS;
> + int kbc_err;
> 
> -       while (loops--) {
> -       /* First, check to see if A20 is already enabled
> + while (loops--) {
> + /* First, check to see if A20 is already enabled
>    (legacy free, etc.) */
> -       if (a20_test_short())
> -       return 0;
> -
> + if (a20_test_short())
> + return 0;
> +
>         /* Next, try the BIOS (INT 0x15, AX=0x2401) */
>         enable_a20_bios();
> -       if (a20_test_short())
> -       return 0;
> -
> + if (a20_test_short())
> + return 0;
> +
>         /* Try enabling A20 through the keyboard controller */
>         kbc_err = empty_8042();
> 
> -       if (a20_test_short())
> -       return 0; /* BIOS worked, but with delayed reaction */
> -
> -       if (!kbc_err) {
> -       enable_a20_kbc();
> -       if (a20_test_long())
> -       return 0;
> + if (a20_test_short())
> + return 0; /* BIOS worked, but with delayed reaction */
> +
> + if (!kbc_err) {
> + enable_a20_kbc();
> + if (a20_test_long())
> + return 0;
>         }
> -
> +
>         /* Finally, try enabling the "fast A20 gate" */
>         enable_a20_fast();
> -       if (a20_test_long())
> -       return 0;
> -       }
> -
> -       return -1;
> + if (a20_test_long())
> + return 0;
> + }
> +
> + return -1;
>  }
> --
> 1.7.2.5

The patch is probably corrupted or not against latest upstream, and the 
title of the patch has no relation to what the patch actually does.

Thanks,

	Ingo
