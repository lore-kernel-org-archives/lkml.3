Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3I3QUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:20:50 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35570 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3I3QUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <1379375332.7083.3.camel@joe-AO722>
References: <20130916233720.GA3967@www.outflux.net>
	<1379375332.7083.3.camel@joe-AO722>
Date: Mon, 30 Sep 2013 12:20:48 -0400
X-Google-Sender-Auth: cG10lurgdQSwVleIzZasybvKXJU
Message-ID: <CAOcJUbxhwQQJudR1sz5rcEQb6V+AdcB0HUBAdsHZWoSZ2CBXmw@mail.gmail.com>
Subject: Re: [PATCH] dvb: fix potential format string leak
From: Michael Krufky <mkrufky@linuxtv.org>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 7:48 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-09-16 at 16:37 -0700, Kees Cook wrote:
>> Make sure that a format string cannot accidentally leak into the printk
>> buffer.
> []
>> diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
> []
>> @@ -649,7 +649,7 @@ static int dib9000_risc_debug_buf(struct dib9000_state *state, u16 * data, u8 si
>>       b[2 * (size - 2) - 1] = '\0';   /* Bullet proof the buffer */
>>       if (*b == '~') {
>>               b++;
>> -             dprintk(b);
>> +             dprintk("%s", b);
>>       } else
>>               dprintk("RISC%d: %d.%04d %s", state->fe_id, ts / 10000, ts % 10000, *b ? b : "<emtpy>");
>>       return 1;
>
> This looks odd.
>
> Perhaps this should be:
>
>         if (*b == '~')
>                 b++;
>         dprintk("etc...);
>
> It'd be nice to fix the <empty> typo too.

This *does* look odd, I agree.  Meanwhile, I do believe this patch
leaves things better than before.  I'm going to merge Kees' patch for
now, but it would be nice to see a better cleanup for that code block.

-Mike Krufky
