Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaFWGXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:23:50 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49854 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFWGXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:23:49 -0400
MIME-Version: 1.0
In-Reply-To: <1403477762.18747.14.camel@joe-AO725>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	<1403477762.18747.14.camel@joe-AO725>
Date: Mon, 23 Jun 2014 08:23:47 +0200
Message-ID: <CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Mathias Krause <minipli@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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

On 23 June 2014 00:56, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
>> [...] patch 2 adds some syntactical sugar for the most popular use
>> case, by providing pr_<level> alike macros, namely pi_<level> for __init
>> code and pe_<level> for __exit code. This hides the use of the marker
>> macros behind the commonly known printing functions -- with just a
>> single character changed.
>>
>> Patch 3 exemplarily changes all strings and format strings in
>> arch/x86/kernel/acpi/boot.c to use the new macros. It also addresses a
>> few styling issues, though. But this already leads to ~1.7 kB of r/o
>> data moved to the .init.rodata section, marking it for release after
>> init.
>>
>> [...]
>
> I once proposed a similar thing.
>
> https://lkml.org/lkml/2009/7/21/421
>
> Matt Mackall replied
>
> https://lkml.org/lkml/2009/7/21/463
>

Thanks for the pointers. Have you looked at patch 2 and 3? I don't
think it makes the printk() case ugly. In fact, using pi_<level>()
should be no less readable then pr_<level>, no?

Thanks,
Mathias
