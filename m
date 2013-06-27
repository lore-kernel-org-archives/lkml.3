Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3F0J2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:28:21 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54007 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3F0J2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:28:19 -0400
MIME-Version: 1.0
In-Reply-To: <51CBFDED.9090203@asianux.com>
References: <51CBA43F.9050000@asianux.com>
	<51CBAA1E.8000206@asianux.com>
	<51CBB1A9.5080203@asianux.com>
	<51CBC186.3080401@asianux.com>
	<CAMuHMdVCv=MOJ8C4U=QHntQKZ=rThoKvXorgcR6jFRCA8hLULQ@mail.gmail.com>
	<51CBFDED.9090203@asianux.com>
Date: Thu, 27 Jun 2013 11:28:19 +0200
X-Google-Sender-Auth: 6LgTNTcODoPDIccDFOMXriVLr6E
Message-ID: <CAMuHMdWGgUCmvd9EGagzXi_ttiaPzKSPp=ekwdOeNFJ+0TD0Hw@mail.gmail.com>
Subject: Re: [PATCH] arch: m32r: include: asm: add ioread*_rep() and iowrite*_rep()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hirokazu Takata <takata@linux-m32r.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:55 AM, Chen Gang <gang.chen@asianux.com> wrote:
> On 06/27/2013 03:07 PM, Geert Uytterhoeven wrote:
>> On Thu, Jun 27, 2013 at 6:37 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> --- a/arch/m32r/include/asm/io.h
>>> +++ b/arch/m32r/include/asm/io.h
>>> @@ -169,6 +169,20 @@ static inline void _writel(unsigned long l, unsigned long addr)
>>>  #define iowrite16 writew
>>>  #define iowrite32 writel
>>>
>>> +#define ioread8_rep(p, dst, count) \
>>> +       insb((unsigned long) (p), (dst), (count))
>>
>> As ioread8() is mapped to readb() (I/O memory space), not inb() (I/O
>> port space),
>> ioread8_rep() should map to readsb() (which m32r doesn't have yet
>> BTW), not insb().
>> For m32r this does matter, as inb() and readb() use different mechanisms
>> internally.
>>
>
> Reasonable, but excuse me, I am not quite familiar with it, can any
> other members (or maintainer) to help implement it ?
>
> Thanks firstly.
>
> :-)
>
>> It seems include/asm-generic/io.h also has this wrong?
>>
>
> I think it need improvement, if readsb has been defined, it should use
> readsb() instead, or just use insb().

I think m32r can mostly use asm-generic/io.h.
I.e. arch/m32r/include/asm/io.h has to #define all the operations it implements
itself, and defer the rest to asm-generic/io.h.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
