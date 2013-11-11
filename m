Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3KKMop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:44:45 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52057 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3KKMoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:44:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131111113218.GF15810@gmail.com>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
	<1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
	<20131111113218.GF15810@gmail.com>
Date: Mon, 11 Nov 2013 06:44:35 -0600
Message-ID: <CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 5:32 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> We want to calculate the blinks per second, and instead of making it 5
>> (1000 / (3600 / 18)), let's make it 4, so the user can see two blinks
>> per second.
>
> Please use the customary changelog style we use in the kernel:
>
>   " Current code does (A), this has a problem when (B).
>     We can improve this doing (C), because (D)."

A is explained, B is empty, C is explained, D is because it makes sense.

>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>  kernel/panic.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/panic.c b/kernel/panic.c
>> index 46e37ff..5a0bdaa 100644
>> --- a/kernel/panic.c
>> +++ b/kernel/panic.c
>> @@ -25,7 +25,7 @@
>>  #include <linux/nmi.h>
>>
>>  #define PANIC_TIMER_STEP 100
>> -#define PANIC_BLINK_SPD 18
>> +#define PANIC_BLINK_SPD 4
>
> Please while at it also do another patch that renames it to a sane name,
> PANIC_BLINK_SPEED or so.

If I can do that, I would rather use PANIC_BLINK_PER_SECOND.

>>  int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
>>  static unsigned long tainted_mask;
>> @@ -147,7 +147,7 @@ void panic(const char *fmt, ...)
>>                       touch_nmi_watchdog();
>>                       if (i >= i_next) {
>>                               i += panic_blink(state ^= 1);
>> -                             i_next = i + 3600 / PANIC_BLINK_SPD;
>> +                             i_next = i + 1000 / PANIC_BLINK_SPD;
>
> This changes a magic value to another magic value.

A magic value that is used all over the kernel, including
kernel/time.c and include/linux/delay.h. I'll change it to
MSEC_PER_SEC if that makes you happy.

-- 
Felipe Contreras
