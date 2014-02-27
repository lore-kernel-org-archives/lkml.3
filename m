Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaB0Uza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:55:30 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33897 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaB0Uz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:55:28 -0500
MIME-Version: 1.0
In-Reply-To: <1393533563.24588.127.camel@joe-AO722>
References: <1393462087.24588.50.camel@joe-AO722>
	<530E8C2E.7080307@zytor.com>
	<1393466619.24588.65.camel@joe-AO722>
	<20140227022857.GC23659@thin>
	<1393469594.24588.71.camel@joe-AO722>
	<20140227025845.GA25145@thin>
	<530EB103.5070406@zytor.com>
	<1393472326.24588.82.camel@joe-AO722>
	<20140227040050.GA8449@nicira.com>
	<530EBCED.9020705@zytor.com>
	<20140227042636.GA9592@nicira.com>
	<530EBFC7.9030309@zytor.com>
	<CANeU7Q=RNXR00bQcPzJYTOcZmRSn3U31ZcadPTHu6Y_Uk0UnYw@mail.gmail.com>
	<faa9e231-d561-417b-8b8b-95192cb0e56a@email.android.com>
	<1393533563.24588.127.camel@joe-AO722>
Date: Thu, 27 Feb 2014 12:55:28 -0800
X-Google-Sender-Auth: EmqN4o-kZGXxvL2PMy3w62lmnMw
Message-ID: <CANeU7QnZika4XsdS_=UwPc5uZgv2-m5vMdmZLyCynKK2YNKLvQ@mail.gmail.com>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: Christopher Li <sparse@chrisli.org>
To: Joe Perches <joe@perches.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ben Pfaff <blp@nicira.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:39 PM, Joe Perches <joe@perches.com> wrote:
> Please use V3 as I stuffed up the alphabetic order
> of sizeof and shadow.

Please send it your V3 then :-)

>
> I'm not sure it matters much, but the linux-kernel
> Makefile wouldn't need to be changed if Wsizeof_bool
> is default 0.

It seems default to off is the right thing to do.

>
> Here's a couple of other nits:
>
> Maybe the evaluate.c "size = bits_in_char;" assignment
>
>         if (size == 1 && is_bool_type(type)) {
> -               warning(expr->pos, "expression using sizeof bool");
> +               if (Wsizeof_bool)
> +                       warning(expr->pos, "expression using sizeof bool");
>                 size = bits_in_char;
>         }
>
> should be
>
>         size = sizeof(_Bool) * 8;

The reason to use bits_in_xxxx is to allow sparse application to over write
the size of int etc. If you don't like the bits_in_char here. You can introduce
bits_in_bool and set that to sizeof(Bool)*8 by default. That way you don't
hard code it.

> And also, in sparse.1, Josh Triplett is shown as
> the maintainer.  Maybe that should be changed to
> Christopher Li

Maybe a separate patch.

Waiting for your V3.

Chris
