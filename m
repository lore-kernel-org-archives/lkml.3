Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaEBKh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 06:37:59 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:56115 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEBKh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 06:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAFiDJ5_79UoFS0bbgyd6htRELXpsF4bD091Bg1EVsocXt76NEw@mail.gmail.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397845149-3141-1-git-send-email-lftan@altera.com>
	<1397845149-3141-3-git-send-email-lftan@altera.com>
	<201404221559.37560.arnd@arndb.de>
	<CAFiDJ5_79UoFS0bbgyd6htRELXpsF4bD091Bg1EVsocXt76NEw@mail.gmail.com>
Date: Fri, 2 May 2014 18:37:55 +0800
X-Google-Sender-Auth: lPp8DTV8erQ3h9eKc3OmrUsQ-4g
Message-ID: <CAFiDJ58MT1z-hw6_ZWBc5QcCJoEdNCdaVPfVgXE2BpUr9c9ztA@mail.gmail.com>
Subject: Re: [PATCH 07/28] nios2: I/O Mapping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 2:02 PM, Ley Foon Tan <lftan@altera.com> wrote:
> On Tue, Apr 22, 2014 at 9:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Friday 18 April 2014, Ley Foon Tan wrote:
>>
>>> +
>>> +#include <asm/pgtable-bits.h>
>>> +
>>> +#define IO_SPACE_LIMIT 0xffffffff
>>
>> Please use 0xffff here, this should work for almost any PCI bus.
> Ah, CONFIG_PCI is not enable in nios2. So, I think IO_SPACE_LIMIT
> should set to 0.
>
>
>>> +
>>> +/* Use "Duff's Device" to unroll the loops. */
>>> +#define __IO_OUT_LOOP(a, b, l)                               \
>>> +     do {                                            \
>>> +             if (l > 0) {                            \
>>> +                     int _n = (l + 7) / 8;           \
>>> +                     switch (l % 8) {                \
>>> +                     case 0:                         \
>>> +                             do {                    \
>>> +                                     *a = *b++;      \
>>
>> I would recommend just doing all of this in out-of-line implementations
>> rather than macros and inline functions.
> Okay. Will move the macros to out-of-line function.
I'm start working on this and found that it is better to keep it as
macros. This is because the input arguments "a" and "b" can be
byte/short/int pointers. Otherwise, we need to have separate function
calls for byte/short/int.

Regards
Ley Foon
