Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaJTTOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:14:04 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:63385 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJTTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <20141020182818.GE9913@krava.brq.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
	<1411774636-6870-9-git-send-email-andi@firstfloor.org>
	<20141020182818.GE9913@krava.brq.redhat.com>
Date: Mon, 20 Oct 2014 21:13:58 +0200
X-Google-Sender-Auth: YRoRJHFDPrK0Hs8tjCdNSuz9OKM
Message-ID: <CAMuHMdUdSK=ibgLowJcsduWykcfS7JacHO8wOcYb0hMLtKCwpQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] tools, perf: Add asprintf replacement
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        namhyung@kernel.org, acme@kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 8:28 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> +int vasprintf(char **str, const char *fmt, va_list ap)
>> +{
>> +     char buf[1024];
>
> could you please make it work for generic buf len?

The actual size above doesn't matter, except for stack usage.
It could be 1 (are there any bugs triggered when using zero? ;-).
The real buffer is allocated by malloc() below.

>> +     int len = vsnprintf(buf, sizeof buf, fmt, ap);
>
> WARNING: sizeof buf should be sizeof(buf)
>
>> +
>> +     *str = malloc(len + 1);
>> +     if (!*str)
>> +             return -1;
>> +     strcpy(*str, buf);
>> +     return len;
>> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
