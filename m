Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaEBMWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:22:38 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52710 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaEBMWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:22:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 07/28] nios2: I/O Mapping
Date: Fri, 02 May 2014 14:22:30 +0200
Message-ID: <5393488.r5N1ijHzS4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ58MT1z-hw6_ZWBc5QcCJoEdNCdaVPfVgXE2BpUr9c9ztA@mail.gmail.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <CAFiDJ5_79UoFS0bbgyd6htRELXpsF4bD091Bg1EVsocXt76NEw@mail.gmail.com> <CAFiDJ58MT1z-hw6_ZWBc5QcCJoEdNCdaVPfVgXE2BpUr9c9ztA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0ReEYoteS3HtMyP6tevtwsEz/Z+uG0pf/3x21N2T5qS
 qLdJn4P0J1b+KI1PBE9nkQfP95QJchmn2TMOa1ctMMgWE4xGc3
 3xsethDDAj3IDwZ8lzK+X0qAiXxpwzaUBOPpbuWOyfTIomce7S
 JuCP8wzDlUlOhG4Y0AfkFpba5oOQcDjA152Xpl2ZNHpSQSpy5/
 3xMCGIYbbCJQeou3dtvIaZNZNndpiX2phOtiqyJtu103xT1Z0h
 5QPxIrwbxoUhAY0f2yIco4TKTA2Ig6pdRNx/GRVrWdENxUeTbf
 +jKkFi4Xyix9AaUEehN7WxO5NIGlC6J8obwun/GBZmhPH6rRzA
 F/dpf8v6CRva0zDsrZiY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2014 18:37:55 Ley Foon Tan wrote:
> On Thu, Apr 24, 2014 at 2:02 PM, Ley Foon Tan <lftan@altera.com> wrote:
> > On Tue, Apr 22, 2014 at 9:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Friday 18 April 2014, Ley Foon Tan wrote:
> >>
> >>> +
> >>> +#include <asm/pgtable-bits.h>
> >>> +
> >>> +#define IO_SPACE_LIMIT 0xffffffff
> >>
> >> Please use 0xffff here, this should work for almost any PCI bus.
> > Ah, CONFIG_PCI is not enable in nios2. So, I think IO_SPACE_LIMIT
> > should set to 0.
> >
> >
> >>> +
> >>> +/* Use "Duff's Device" to unroll the loops. */
> >>> +#define __IO_OUT_LOOP(a, b, l)                               \
> >>> +     do {                                            \
> >>> +             if (l > 0) {                            \
> >>> +                     int _n = (l + 7) / 8;           \
> >>> +                     switch (l % 8) {                \
> >>> +                     case 0:                         \
> >>> +                             do {                    \
> >>> +                                     *a = *b++;      \
> >>
> >> I would recommend just doing all of this in out-of-line implementations
> >> rather than macros and inline functions.
> > Okay. Will move the macros to out-of-line function.
>
> I'm start working on this and found that it is better to keep it as
> macros. This is because the input arguments "a" and "b" can be
> byte/short/int pointers. Otherwise, we need to have separate function
> calls for byte/short/int.

But with the inline implementation, you have a separate instance for each
caller, which seems more wasteful.

You can put the function into a "lib" file to make sure it doesn't get linked
in if there are no callers though. And of course you can keep the macro
in the file implementing it so you don't have to write the same code
three times.

	Arnd

