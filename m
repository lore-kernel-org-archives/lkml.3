Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3IZUgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:36:13 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:43615 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3IZUgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:36:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130909084933.GA20140@gmail.com>
References: <20130906181532.GA31260@www.outflux.net>
	<20130909084933.GA20140@gmail.com>
Date: Thu, 26 Sep 2013 15:36:09 -0500
X-Google-Sender-Auth: 1zbdv8Ri4gblHSjE3aqID2Jp3iA
Message-ID: <CAGXu5jL8qzxGq49vBBH9f1+GgCtVUA8MK=ed-qmWMaq=TetPDg@mail.gmail.com>
Subject: Re: [PATCH] x86, build: move build output statistics away from stderr
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        David Woodhouse <David.Woodhouse@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 3:49 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> When building on x86, the final image building step always emits stats
>> to stderr, even though this information is neither a warning nor an error:
>>
>>   BUILD   arch/x86/boot/bzImage
>> Setup is 16188 bytes (padded to 16384 bytes).
>> System is 6368 kB
>> CRC cbe50c61
>>
>> Validating automated builds would be cleaner if stderr did not have to
>> filter out these lines. Instead, change how tools/build is called, and
>> make the zoffset header unconditional, and write to a specified file
>> instead of to stdout, which can then be used for statistics, leaving
>> stderr open for legitimate warnings and errors, like the output from
>> die().
>
> Nice, that output to stderr was always somewhat annoying.
>
>> +     /* Catch any delayed write failures */
>> +     if (fclose(dest))
>> +             die("Writing image failed");
>> +
>>       close(fd);
>
> Looks like the new code is not just reporting errors better, but it's more
> robust by catching and reporting fclose()-time failures as well, avoiding
> a corrupt kernel image in certain corner cases - the most common being a
> file system full error I suspect.

Quick ping on this; can someone pick it up in their tree?

Thanks!

-Kees

>
> Thanks,
>
>         Ingo



-- 
Kees Cook
Chrome OS Security
