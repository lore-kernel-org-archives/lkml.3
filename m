Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBCP2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:28:09 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:38400 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaBCP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:28:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAN7rbOti4ODDz9h_oMQpqdB5JWwL0wpB-7rzcbKxho_46pKawg@mail.gmail.com>
References: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
	<CAN7rbOstSYgZ39o68AA+z62Uj6KYzNhDkyX+sbHPr=xc-rRjRg@mail.gmail.com>
	<CAFrcx1nSDD4Sts7uDxxyG9LpyQiwFhby8oLEpWW-qotyWPpGpw@mail.gmail.com>
	<CAN7rbOti4ODDz9h_oMQpqdB5JWwL0wpB-7rzcbKxho_46pKawg@mail.gmail.com>
Date: Mon, 3 Feb 2014 16:28:06 +0100
Message-ID: <CAFrcx1mdRb6M24TsNWaZ6eEp2QFke3xvxqC2F96G7mdJ29t7JQ@mail.gmail.com>
Subject: Re: [Libunwind-devel] [RFC PATCH 0/3] Add support for dwarf compat
 mode unwinding
From: Jean Pihet <jean.pihet@linaro.org>
To: Arun Sharma <arun@sharma-home.net>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        libunwind-devel <libunwind-devel@nongnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On 22 January 2014 06:15, Arun Sharma <arun@sharma-home.net> wrote:
> On Tue, Jan 21, 2014 at 12:16 AM, Jean Pihet <jean.pihet@linaro.org> wrote:
>
>>>> This is the case when e.g. profiling an ARMv7 binary that runs on an
>>>> ARMv8 (aka AARCH64) platform.
>>>
>>> Why not configure libunwind for ARMv7 in that case?
>>>
>>> I'm trying to understand how is your use case different from using
>>> x86_32 libunwind to do local unwinding on a x86_64 machine.
>> Can you give more details on the use case and how to configure
>> libunwind?
>
> You could either build libunwind on a ARMv7 machine and copy it over
> or setup a 32 bit chroot on a 64 bit kernel and compile libunwind
> inside that.
>
>> The provided patches dynamically detect the target binary
>> address size and parse the debug info accordingly, all that in a
>> single library.
>
> This is generally called cross-unwinding in libunwind lingo. Some
> description here:
>
> http://www.nongnu.org/libunwind/man/libunwind%283%29.html#section_4
>
>>
>> Note: my use case is to call libunwind from the perf utility in order
>> to unwind from the dwarf info.
>>
>
> You could link in two copies of libunwind into the perf binary:
> * libunwind.a for local (host == target) unwinding
> * libunwind-arm.a for 32 bit cross-unwinding
>
> Doing cross-unwinding requires you to write a bunch of "accessors" on
> how to access the address space of a non-local thread.
>
> Something like ./configure --target=arm on aarch64.

Thanks for the link and info.

Is there a concrete example of cross-unwinding with multiple targets,
for example on x86_64 using native and x86_32 libunwind libraries
simultaneously?
I am trying to assess the impact of multiple unwinding libs in the perf code.

Jiri, Arnaldo,
How is that done on x86? I do not think this can be done with the
current perf code, am I correct?

>
>  -Arun

Regards,
Jean
