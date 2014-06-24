Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaFXObO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:31:14 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43587 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaFXObM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:31:12 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Joe Perches <joe@perches.com>
Cc: Mathias Krause <minipli@googlemail.com>,
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
X-Hashcash: 1:20:140624:tglx@linutronix.de::UnTl3PUtyVrCXN7y:00000000000000000000000000000000000000000000QW0
X-Hashcash: 1:20:140624:rostedt@goodmis.org::iRVyzTln+Oq8KdDO:0000000000000000000000000000000000000000000Vc1
X-Hashcash: 1:20:140624:joe@perches.com::Rn8Bdt4rU6CvbDDP:000P2/
X-Hashcash: 1:20:140624:hpa@zytor.com::08YpDYRhvBVPnusi:00001Jea
X-Hashcash: 1:20:140624:minipli@googlemail.com::QSfu9jf64HmJlhpP:00000000000000000000000000000000000000024Ng
X-Hashcash: 1:20:140624:akpm@linux-foundation.org::Zns8clLwOkwXOBPq:0000000000000000000000000000000000001Wtm
X-Hashcash: 1:20:140624:linux-kernel@vger.kernel.org::DhqgsY381+WwgJf/:0000000000000000000000000000000004hCu
X-Hashcash: 1:20:140624:rjw@rjwysocki.net::bQmHrFggLFo5vkJA:000000000000000000000000000000000000000000007Nxi
X-Hashcash: 1:20:140624:mingo@redhat.com::JN2QYVO32msxB0s0:05ucf
X-Hashcash: 1:20:140624:gregkh@linuxfoundation.org::ISjVn5DbkufVxdlQ:0000000000000000000000000000000000093HJ
Date: Tue, 24 Jun 2014 16:31:08 +0200
In-Reply-To: <1403505219.18747.37.camel@joe-AO725> (Joe Perches's message of
	"Sun, 22 Jun 2014 23:33:39 -0700")
Message-ID: <87egyeqt03.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Mon, 2014-06-23 at 08:23 +0200, Mathias Krause wrote:
>> On 23 June 2014 00:56, Joe Perches <joe@perches.com> wrote:
>> > On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
>> >> [...] patch 2 adds some syntactical sugar for the most popular use
>> >> case, by providing pr_<level> alike macros, namely pi_<level> for __init
>> >> code and pe_<level> for __exit code. This hides the use of the marker
>> >> macros behind the commonly known printing functions -- with just a
>> >> single character changed.
>> >>
>> >> Patch 3 exemplarily changes all strings and format strings in
>> >> arch/x86/kernel/acpi/boot.c to use the new macros. It also addresses a
>> >> few styling issues, though. But this already leads to ~1.7 kB of r/o
>> >> data moved to the .init.rodata section, marking it for release after
>> >> init.
>> >>
>> >> [...]
>> >
>> > I once proposed a similar thing.
>> >
>> > https://lkml.org/lkml/2009/7/21/421
>> >
>> > Matt Mackall replied
>> >
>> > https://lkml.org/lkml/2009/7/21/463
>> >
>> 
>> Thanks for the pointers. Have you looked at patch 2 and 3? I don't
>> think it makes the printk() case ugly. In fact, using pi_<level>()
>> should be no less readable then pr_<level>, no?
>
> I don't think it's particularly less readable, but I
> do think using the plug-in mechanism might be a better
> option as it would need no manual markings at all.

gcc already seems to contain infrastructure for this kind of thing, so
maybe it doesn't even require a plugin, but simply a little coordination
with the gcc folks. This snippet from gcc internals seems relevant:

-- Target Hook: section * TARGET_ASM_FUNCTION_RODATA_SECTION (tree
          DECL)
     Return the readonly data section associated with 'DECL_SECTION_NAME
     (DECL)'.  The default version of this function selects
     '.gnu.linkonce.r.name' if the function's section is
     '.gnu.linkonce.t.name', '.rodata.name' if function is in
     '.text.name', and the normal readonly-data section otherwise.

Rasmus
