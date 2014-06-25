Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaFYHfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:35:54 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38193 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaFYHfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:35:41 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mathias Krause <minipli@googlemail.com>
Cc: Joe Perches <joe@perches.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
Organization: D03
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403477762.18747.14.camel@joe-AO725>
	<CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	<1403505219.18747.37.camel@joe-AO725>
	<87egyeqt03.fsf@rasmusvillemoes.dk>
	<CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	<1403638620.29061.35.camel@joe-AO725>
	<CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
	<1403641843.29061.51.camel@joe-AO725>
	<CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
	<1403643440.29061.56.camel@joe-AO725>
	<CA+rthh9gKVWix4E0ENPFBXgUMpjnb8_+aeNUi3iZpAnqzo8C1w@mail.gmail.com>
	<1403646310.29061.61.camel@joe-AO725>
	<CA+rthh8anKnxA7XuZb4BHB4a7w=Oo3LhUuD2UOwGfv2SGxLs0w@mail.gmail.com>
X-Hashcash: 1:20:140625:gregkh@linuxfoundation.org::/JjoELSP4t8OjNLo:000000000000000000000000000000000000OjV
X-Hashcash: 1:20:140625:joe@perches.com::kEoyCnECZFNWsRbT:000Iy8
X-Hashcash: 1:20:140625:hpa@zytor.com::7siGke/k2QhFfz5l:00000vPy
X-Hashcash: 1:20:140625:minipli@googlemail.com::nKZ54ARkh7KPd3yJ:0000000000000000000000000000000000000001PRx
X-Hashcash: 1:20:140625:mingo@redhat.com::IoB/laHC/27/clxC:02q08
X-Hashcash: 1:20:140625:rjw@rjwysocki.net::WiUpeJ5cpXCYepht:000000000000000000000000000000000000000000003+4u
X-Hashcash: 1:20:140625:tglx@linutronix.de::Wz2FezmrQUttNHS9:00000000000000000000000000000000000000000003RwG
X-Hashcash: 1:20:140625:akpm@linux-foundation.org::PBeH7xItTg5p+xt+:00000000000000000000000000000000000046C9
X-Hashcash: 1:20:140625:linux-kernel@vger.kernel.org::G2ESKd2a+Z4mo2zX:0000000000000000000000000000000005rvz
X-Hashcash: 1:20:140625:rostedt@goodmis.org::gOq41nWOoq4Q05q4:0000000000000000000000000000000000000000007MYY
Date: Wed, 25 Jun 2014 09:35:36 +0200
In-Reply-To: <CA+rthh8anKnxA7XuZb4BHB4a7w=Oo3LhUuD2UOwGfv2SGxLs0w@mail.gmail.com>
	(Mathias Krause's message of "Wed, 25 Jun 2014 07:55:47 +0200")
Message-ID: <877g45qw53.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias Krause <minipli@googlemail.com> writes:

> On 24 June 2014 16:31, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>> gcc already seems to contain infrastructure for this kind of thing, so
>> maybe it doesn't even require a plugin, but simply a little coordination
>> with the gcc folks. This snippet from gcc internals seems relevant:
>>
>> -- Target Hook: section * TARGET_ASM_FUNCTION_RODATA_SECTION (tree
>>           DECL)
>>      Return the readonly data section associated with 'DECL_SECTION_NAME
>>      (DECL)'.  The default version of this function selects
>>      '.gnu.linkonce.r.name' if the function's section is
>>      '.gnu.linkonce.t.name', '.rodata.name' if function is in
>>      '.text.name', and the normal readonly-data section otherwise.
>>
>
> I don't think it's that easy. You cannot simply put all strings into
> the .init.rodata section when code currently gets emitted to
> .init.text. The reason is because strings used in __init code might be
> referenced later on, too. For example, the name passed to
> class_create() won't be copied.

Right, didn't think about that, so yes, the source would need
to be annotated some way or other, or gcc would need to learn the
semantics of certain kernel functions.

Speaking of dangling pointers: A similar disaster would happen if some
code containing pi_* calls gets copy-pasted to some non-__init
function. Could checkpatch learn to warn about calling these functions
from the wrong context?


Mathias Krause <minipli@googlemail.com> writes:

> Merging strings across multiple compilation units does not happen,
> anyway -- not now, not with the new macros.

Certainly string merging seems to happen, at least at -O1 and higher:

$ grep . *.c
a.c:const char *a(void) { return "654321"; }
b.c:const char *b(void) { return "4321"; }
c.c:const char *c(void) { return "654321"; }
main.c:#include <stdio.h>
main.c:const char *a(void);
main.c:const char *b(void);
main.c:const char *c(void);
main.c:int main(void)
main.c:{
main.c: printf("%p\n", a());
main.c: printf("%p\n", b());
main.c: printf("%p\n", c());
main.c: return 0;
main.c:}
$ gcc -O1 -c a.c && gcc -O1 -c b.c && gcc -O1 -c c.c
$ gcc -O1 main.c a.o b.o c.o
$ ./a.out 
0x400630
0x400632
0x400630

So not only are identical strings merged; suffixes are also optimized.

Rasmus
