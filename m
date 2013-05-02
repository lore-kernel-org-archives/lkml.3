Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710Ab3EBSdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:33:21 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64561 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760743Ab3EBSdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <1367507873.30667.136.camel@gandalf.local.home>
References: <1367429751.30667.99.camel@gandalf.local.home>
	<CAMuHMdXguZknoR=A6Cpqoz4VYX6wuPtUWfV4yGhkBiGMQOdaYg@mail.gmail.com>
	<1367507873.30667.136.camel@gandalf.local.home>
Date: Thu, 2 May 2013 20:33:19 +0200
X-Google-Sender-Auth: vqrnU56g0NInuScPgXpBjvjLLRU
Message-ID: <CAMuHMdWX0kvVP09Ttrb8Q+HTR3HDndEDVnS2aEHnRS4SHcc=Fw@mail.gmail.com>
Subject: Re: [PATCH v2] init: Do not warn on non-zero initcall return
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 5:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2013-05-02 at 09:43 +0200, Geert Uytterhoeven wrote:
>> On Wed, May 1, 2013 at 7:35 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > --- a/init/main.c
>> > +++ b/init/main.c
>> > @@ -686,11 +686,8 @@ int __init_or_module do_one_initcall(initcall_t fn)
>> >
>> >         msgbuf[0] = 0;
>> >
>> > -       if (ret && ret != -ENODEV && initcall_debug)
>> > -               sprintf(msgbuf, "error code %d ", ret);
>> > -
>> >         if (preempt_count() != count) {
>> > -               strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
>> > +               sprintf(msgbuf, "preemption imbalance ");
>>
>> snprintf(), please?
>
> Why? The msgbuf is 64 bytes, this is the first occurrence and
> "preemption imbalance " is much less than 64 bytes.

The day after tomorrow, someone will modify the code, and cause a buffer
overflow.

I'm actually surprised (v)sprintf() is not tagged __deprecated.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
