Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaGGFtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:49:11 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:52632 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaGGFtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAB1dqC7BqsaDtXVYx24M5R9eaY7ZfpEtu3bxbJHXNHYhAbJETg@mail.gmail.com>
References: <1404668531-31550-1-git-send-email-mina86@mina86.com>
	<CAB1dqC7BqsaDtXVYx24M5R9eaY7ZfpEtu3bxbJHXNHYhAbJETg@mail.gmail.com>
Date: Mon, 7 Jul 2014 07:49:07 +0200
Message-ID: <CABPqkBTmqiQCMD6rCoyrd5NumvaH11Bi+DUs3-M3608z_+LRDw@mail.gmail.com>
Subject: Re: [PATCH] tools: perf: prefer clarity in setup_pager
From: Stephane Eranian <eranian@google.com>
To: Michael Lentine <mlentine@google.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 2:40 AM, Michael Lentine <mlentine@google.com> wrote:
> Unless I'm missing something this removes defaulting the pager to cat if
> nothing is found which is very useful for devices/oses without less or
> pager.
>
>
I think you are correct Michael.
I don't quite understand the value of this patch.
But by oversimplifying, it should not change the logic of the code.

> On Sun, Jul 6, 2014 at 10:42 AM, Michal Nazarewicz <mina86@mina86.com>
> wrote:
>>
>> “!(pager || access(…))” is indeed pretty smart way to write
>> “!pager && access(…) == 0” but other than being clever it gives
>> no advantages and merely confuses the reader who needs to wonder
>> what is actually going on.
>>
>> As such, replace the checks with much cleaner ones.
>>
>> Also, while at it, merge the lest “!pager” test with the next
>> test that yields true after the “!pager” if's body is executed.
>> ---
>>  tools/perf/util/pager.c | 8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
>> index 31ee02d..14da1b0 100644
>> --- a/tools/perf/util/pager.c
>> +++ b/tools/perf/util/pager.c
>> @@ -57,13 +57,11 @@ void setup_pager(void)
>>         }
>>         if (!pager)
>>                 pager = getenv("PAGER");
>> -       if (!(pager || access("/usr/bin/pager", X_OK)))
>> +       if (!pager && access("/usr/bin/pager", X_OK) == 0)
>>                 pager = "/usr/bin/pager";
>> -       if (!(pager || access("/usr/bin/less", X_OK)))
>> +       if (!pager && access("/usr/bin/less", X_OK) == 0)
>>                 pager = "/usr/bin/less";
>> -       if (!pager)
>> -               pager = "cat";
>> -       if (!*pager || !strcmp(pager, "cat"))
>> +       if (!pager || !*pager || !strcmp(pager, "cat"))
>>                 return;
>>
>>         spawned_pager = 1; /* means we are emitting to terminal */
>> --
>> 2.0.0.526.g5318336
>>
>
