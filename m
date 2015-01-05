Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbbAEJ6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:58:32 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:52638 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbbAEJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:58:29 -0500
MIME-Version: 1.0
In-Reply-To: <53767FB9.5040508@infradead.org>
References: <53700D71.1090201@landley.net>
	<53767FB9.5040508@infradead.org>
Date: Mon, 5 Jan 2015 10:58:27 +0100
X-Google-Sender-Auth: Nxfq1zSqlK94Nra8EqXVZEwdbyI
Message-ID: <CAMuHMdVnUqc+gyqok_OAUWT++K-O=9kRQkyUkHduPGxQUQ20oA@mail.gmail.com>
Subject: Re: Building sh4 without CONFIG_EXPERT.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:14 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 05/11/2014 04:53 PM, Rob Landley wrote:
>> I got sh4 to work under QEMU years ago as part of my aboriginal linux
>> project, which builds the smallest Linux system capable of rebuilding
>> itself natively from source code. (You can download and run the system
>> images from http://landley.net/aboriginal/bin if you're curious.)
>>
>> One of the goals of Aboriginal is to make different architectures behave
>> the same way, and one of the ways I do that is by having a basic kernel
>> miniconfig file defining the config symbols common across platforms:
>>
>>   http://landley.net/hg/aboriginal/file/1651/sources/baseconfig-linux
>>
>> And then append target-specific chunks, ala the LINUX_CONFIG sections
>> from each of:
>>
>>   http://landley.net/hg/aboriginal/file/1651/sources/targets
>>
>> The problem is, the sh4 target's target-specific chunk is an INSANE 45
>> config symbols (armv5l needs 15 symbols, powerpc needs 16, i686 needs 7,
>> mips needs 6...) and the reason for the verbosity is that sh4 forces on
>> CONFIG_EXPERT.
>>
>> As far as I can tell, the only reason sh4 is forcing on CONFIG_EXPERT is
>> to get CONFIG_PATA_PLATFORM. The patch to make sh4 _not_ force on
>> CONFIG_EXPERT is just:
>>
>> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
>> index 834b67c..7d0d44d 100644
>> --- a/arch/sh/Kconfig
>> +++ b/arch/sh/Kconfig
>> @@ -1,7 +1,7 @@
>>  config SUPERH
>>       def_bool y
>>       select ARCH_MIGHT_HAVE_PC_PARPORT
>> -     select EXPERT
>> +     select HAVE_PATA_PLATFORM
>>       select CLKDEV_LOOKUP
>>       select HAVE_IDE if HAS_IOPORT_MAP
>>       select HAVE_MEMBLOCK
>
> Since PATA_PLATFORM is:
>
> config PATA_PLATFORM
>         tristate "Generic platform device PATA support"
>         depends on EXPERT || PPC || HAVE_PATA_PLATFORM
>
> then any of EXPERT, PPC, or HAVE_PATA_PLATFORM should be sufficient.
> and using HAVE_PATA_PLATFORM is more direct and obvious.
>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Note that you have to resent to akpm to get sh-patches applied.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
