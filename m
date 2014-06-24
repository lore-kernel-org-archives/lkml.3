Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbaFXUlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:41:36 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43421 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbaFXUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:41:34 -0400
MIME-Version: 1.0
In-Reply-To: <1403641843.29061.51.camel@joe-AO725>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403477762.18747.14.camel@joe-AO725>
	<CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	<1403505219.18747.37.camel@joe-AO725>
	<87egyeqt03.fsf@rasmusvillemoes.dk>
	<CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	<1403638620.29061.35.camel@joe-AO725>
	<CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
	<1403641843.29061.51.camel@joe-AO725>
Date: Tue, 24 Jun 2014 22:41:32 +0200
Message-ID: <CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
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

On 24 June 2014 22:30, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-06-24 at 22:10 +0200, Mathias Krause wrote:
>> I would like to handle the easy ones, too. E.g. strings used in
>> parameter parsing, i.e. strcmp()s.
>
> Sure, but that change is separable from printk conversions.

Yes. Those need to be marked manually, based on auditing the code for
reuses of those strings in non-init code.

>
> Any idea how much would be changed treewide and whether
> or not those strings are not already in rodata?

No, sorry. I haven't looked for those specifically yet. There is even
more to look for: calls to panic() in __init code, or the name of
kmem_cache_create() -- it get's copied. So there is more to optimize
if one is patient enough ;)
And all of those strings should be in the .rodata section, now. But
why you're asking?

>
> Looking at it, I see generic strings like "on", "off",
> "device", "high", "low".  All these are likely to be
> duplications of strings in rodata.

Yes. My vanilla vmlinux build has quite a lot of copies of "off" in
it. But I doubt any linker would merge those. Does LTO do so?

Mathias
