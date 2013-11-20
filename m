Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3KTLCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:02:32 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63917 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTLCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:02:30 -0500
MIME-Version: 1.0
In-Reply-To: <1384944598.95627.YahooMailNeo@web163903.mail.gq1.yahoo.com>
References: <1384934391.56931.YahooMailNeo@web163904.mail.gq1.yahoo.com>
	<CAMuHMdW-j=FOAo9ZAFFJBiFqBn111Ebng6wTM-t7a3fGhjXsDg@mail.gmail.com>
	<1384944598.95627.YahooMailNeo@web163903.mail.gq1.yahoo.com>
Date: Wed, 20 Nov 2013 12:02:29 +0100
X-Google-Sender-Auth: JkvvRN2fCOoOAZsxCcjLqdxSFLY
Message-ID: <CAMuHMdUqfqxfxHxuMY1W1jfovun3WvXy05wsYUHz53Pwrio+jw@mail.gmail.com>
Subject: Re: Having troubles in updating MTD partitions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Suki Buryani <sukiburyani@yahoo.com>
Cc: "uclinux-dev@uclinux.org" <uclinux-dev@uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 11:49 AM, Suki Buryani <sukiburyani@yahoo.com> wrote:
>>5824 is the usable size of the file system on mtdblock3, i.e. after subtracting
> the overhead for file system bookkeeping.
>
> By default mtd partitions were like
>
> cat /proc/partitions
> major minor  #blocks  name
>
>   31     0       8192 mtdblock0
>   31     1        256 mtdblock1
>   31     2       2048 mtdblock2
>   31     3       5824 mtdblock3
>   31     4         64 mtdblock4
>
> mtdblock3 was having 5824 blocks and 5824 blocks were able to use,
>
> I think you are missing my point, i have increase size of mtdblock3 but i am unable use whole partion and idk why

Sorry, I indeed misunderstood you.

Could it be that jffs2 requires a minimum granularity for file system sizes?
Probably the size needs to be a multiple of the eraseblock size?

$ factor 5824
5824: 2 2 2 2 2 2 7 13
$ factor 5884
5884: 2 2 1471

I.e. the former is a multiple of 64 (KiB), the latter is a multiple of 4 (KiB).

> there is one more thing, Can any one tell me how i can change eraseblock for a partition, i > believe i also having wrong eraseblock for mtdblock3

Sorry, I don't know.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
