Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbaJaQOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:14:41 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47919 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaJaQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:14:40 -0400
MIME-Version: 1.0
In-Reply-To: <86lhnw66yi.fsf@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me>
References: <1414672901-29118-1-git-send-email-eternal.n08@gmail.com>
	<CAGXu5jLG_c8vZ5_v7WMaZxKgLdJXhorarCFGcB4fFLUYmLK--Q@mail.gmail.com>
	<86lhnw66yi.fsf@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me>
Date: Fri, 31 Oct 2014 09:14:39 -0700
X-Google-Sender-Auth: JYVf6CKdkR2GVb7QffCZlNi_tzg
Message-ID: <CAGXu5jL94ADSu=PAsbfhpiTc4iK1YCWiQ679BoHHRkhHBtekAQ@mail.gmail.com>
Subject: Re: [PATCH] x86, kaslr: Prevent .bss from overlaping initrd
From: Kees Cook <keescook@chromium.org>
To: Eternal <eternal.n08@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 12:20 AM, Eternal <eternal.n08@gmail.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
> I use the following function to print an arbitrary number in hexadecimal
> in aslr.c and misc.c:
>
> void print_hex(unsigned long value) {
>         char c[2];
>         int i;
>
>         c[1] = '\0';
>         for (i = 60; i >= 0; i -= 4) {
>                 unsigned long digit = (addr >> i) & 0xf;
>                 if (digit <= 9) {
>                         c[0] = '0' + digit;
>                 } else {
>                         c[0] = 'a' + (digit - 10);
>                 }
>                 debug_putstr(c);
>         }
> }

Hah! Yes, this is nearly line-for-line identical to a similar function
I wrote when debugging kASLR during its development. :) I had asked
because I was hoping I wasn't missing some existing way to print hex
values. :)

I will send that, since we clearly keep needing this functionality.

>> Should mkpiggy.c do the work itself instead of taking an argument?
>
> Both ways are ok to me. I'm not sure which way is better, though.

Yeah, after spending time looking at it, your way seemed the cleanest.

-Kees

-- 
Kees Cook
Chrome OS Security
