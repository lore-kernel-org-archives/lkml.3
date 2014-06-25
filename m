Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaFYFzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:55:50 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:35504 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaFYFzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:55:48 -0400
MIME-Version: 1.0
In-Reply-To: <1403646310.29061.61.camel@joe-AO725>
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
Date: Wed, 25 Jun 2014 07:55:47 +0200
Message-ID: <CA+rthh8anKnxA7XuZb4BHB4a7w=Oo3LhUuD2UOwGfv2SGxLs0w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2014 23:45, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-06-24 at 23:06 +0200, Mathias Krause wrote:
>> On 24 June 2014 22:57, Joe Perches <joe@perches.com> wrote:
>> > On Tue, 2014-06-24 at 22:41 +0200, Mathias Krause wrote:
>> >> And all of those strings should be in the .rodata section, now. But
>> >> why you're asking?
>> > Because now they will be duplicated in .rodata
>> > and the __init section no?
>> No. A string marked with __init_str() will only life in the
>> .init.rodata section. No duplication.
>
> Unless the same string is used in another bit
> of code.  Then there's duplication.

Rather, unless the same string gets used in an __init and a non-__init
section of the same compilation unit. Otherwise it would be only in
one section. But having the same string used in two sections of the
same compilation unit should be a rather rare case. Merging strings
across multiple compilation units does not happen, anyway -- not now,
not with the new macros.

>
>> Having duplicated strings in .rodata and .init.rodata is also no
>> problem as the latter will be freed.
>
> They increase image size.

But as this is a rare case, it shouldn't matter, really. The
compression should compensate that, compressing multiple occurrences
of the same string efficiently.

In the more likely case, strings used only in __init code, we would
have no image size increase but an increase of free memory after
initialization.


Thanks,
Mathias
