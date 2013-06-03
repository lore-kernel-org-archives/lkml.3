Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3FCKsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:48:24 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61015 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3FCKsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <51AC6472.3060606@asianux.com>
References: <51A71E49.1000707@asianux.com>
	<CAMuHMdUz8o4d=RiAMW8-pCrnZyfoH9EETVqjcb7E1GqCgYmQ7g@mail.gmail.com>
	<51A93FA0.1050203@biophys.uni-duesseldorf.de>
	<51A94281.7050708@biophys.uni-duesseldorf.de>
	<51AC6472.3060606@asianux.com>
Date: Mon, 3 Jun 2013 12:48:18 +0200
X-Google-Sender-Auth: 3qdiP_pVsqlWKWmKHqRUT95FJMs
Message-ID: <CAMuHMdVLA_zgeGxTTzfXnBYZiihH3w+LLcW0cRzVk_dvkFojgg@mail.gmail.com>
Subject: Re: [PATCH] arch: m68k: include: asm: the 3rd parameter of 'insl' and
 'outsl' need '<< 2'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: schmitz <schmitz@biophys.uni-duesseldorf.de>,
        Greg Ungerer <gerg@uclinux.org>, schmitz@debian.org,
        Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 11:40 AM, Chen Gang <gang.chen@asianux.com> wrote:
> On 06/01/2013 08:38 AM, schmitz wrote:
>>>>> The related git number:
>>>>>   for parport.h: "4914802 m68k,m68knommu: merge header files" in 2009
>>>>>   for io_mm.h: "84b16b7 m68k/atari: ROM port ISA adapter support" in
>>>>> Apr 6 2013
>>>>>
>>>>> The related warning (make EXTRA_CFLAG=-W ARCH=m68k allmodconfig):
>>>>>   arch/m68k/include/asm/parport.h:14:0: warning: "insl" redefined
>>>>> [enabled by default]
>>>>>   arch/m68k/include/asm/io_mm.h:403:0: note: this is the location of
>>>>> the previous definition
>>>>>   arch/m68k/include/asm/parport.h:15:0: warning: "outsl" redefined
>>>>> [enabled by default]
>>>>>   arch/m68k/include/asm/io_mm.h:406:0: note: this is the location of
>>>>> the previous definition
>>>>>
>>> Is that the same problem Thorsten reported recently? parport.h should
>>> either use what the arch io.h include defined, or (in the case of Q40
>>> on m68k) undef and redefine as needed.
>> It appears this is the same issue, see message ID
>> loom.20130511T171757-995@post.gmane.org to linux-m68k (May 12th, by
>> Thorsten Glaser).
>>
>> This _only_ applies to use of insl/outsl macros in parport_pc.h, which
>> is only used by Q40 on m68k. I see no reason to change anything in io.h
>> to cope with this warning.
>
> It sounds reasonable.
>
> And excuse me, could you provide the related link directly ?  I don't
> know how to see the detail of 'loom.20130511T171757-995@post.gmane.org'.

http://www.spinics.net/lists/linux-m68k/msg06041.html

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
