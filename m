Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaFFRJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:09:01 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:41572 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFFRJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <CACkGtriM1jwP9OSED21mNrKWPubeJp9YjL-8uetLqhjqfoH=Lg@mail.gmail.com>
References: <CACkGtriM1jwP9OSED21mNrKWPubeJp9YjL-8uetLqhjqfoH=Lg@mail.gmail.com>
Date: Fri, 6 Jun 2014 10:08:59 -0700
Message-ID: <CACkGtrincr-oEu5Aq2EpYmbJDVSzuzwLguOaUvRY4uBqz=5-6A@mail.gmail.com>
Subject: Re: "." in vmlinux.lds.S
From: =?UTF-8?B?SMOhbiBTaMSbbiAo5rKI5ra1KQ==?= <shenhan@google.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A gentle ping?

On Tue, Jun 3, 2014 at 2:46 PM, Hán Shěn (沈涵) <shenhan@google.com> wrote:
> Hi we are trying to boot up a x86_64 chrome book using binutils 2.24 and
> kernel 3.8, but failed.
>
> After some triage work, we found that a 2-year-old binutil CL changed the
> interpretation of "." in linker script （short story: absolute -> relative,
> long story: https://sourceware.org/ml/binutils/2012-06/msg00155.html).
>
> After some further work, we are able to boot the kernel with a kernel patch
> pasted at EOM. I am curious, why the upstream kernel is never hit by this
> behavior? We enabled "CONFIG_DEBUG_RODATA", so we were hit, is this some
> macro not usually turned on?
>
> Patch here ----
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index d329fc4..d5dc570 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -58,7 +58,7 @@ jiffies_64 = jiffies;
>
>  #define X64_ALIGN_DEBUG_RODATA_END                             \
>                 . = ALIGN(HPAGE_SIZE);                          \
> -               __end_rodata_hpage_align = .;
> +               __end_rodata_hpage_align = ABSOLUTE(.);
>
>  #else
>
> @@ -159,7 +159,7 @@ SECTIONS
>  #ifdef CONFIG_X86_64
>
>         . = ALIGN(PAGE_SIZE);
> -       __vvar_page = .;
> +       __vvar_page = ABSOLUTE(.);
>
>         .vvar : AT(ADDR(.vvar) - LOAD_OFFSET) {
>                 /* work around gold bug 13023 */
> @@ -325,7 +325,7 @@ SECTIONS
>                 __brk_limit = .;
>         }
>
> -       _end = .;
> +       _end = ABSOLUTE(.);
>
>          STABS_DEBUG
>          DWARF_DEBUG
>



-- 
Han Shen |  Software Engineer |  shenhan@google.com |  +1-650-440-3330
