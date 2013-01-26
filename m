Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3AZOiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 09:38:20 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51453 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3AZOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 09:38:17 -0500
MIME-Version: 1.0
In-Reply-To: <1359163444.2079.12.camel@joe-AO722>
References: <1353057890-24234-1-git-send-email-lig.fnst@cn.fujitsu.com>
	<CAFTL4hzLu5RN-PSuP6NRwx2sMKXh5OZ7gNqLnUQQvKTK4n9i1Q@mail.gmail.com>
	<1359163444.2079.12.camel@joe-AO722>
Date: Sat, 26 Jan 2013 15:38:16 +0100
Message-ID: <CAFTL4hwhAkZUVyYoMriRsy4DZ4Br-PCihC4O1SyqBZXyXaWYKg@mail.gmail.com>
Subject: Re: [PATCH]cputime: make bool type for steal ticks
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: liguang <lig.fnst@cn.fujitsu.com>, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/26 Joe Perches <joe@perches.com>:
> On Sat, 2013-01-26 at 01:45 +0100, Frederic Weisbecker wrote:
>> > diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> []
>> > @@ -282,7 +282,7 @@ static __always_inline bool steal_account_process_tick(void)
> []
>> > -               return st;
>> > +               return !!st;
>>
>> I would expect gcc to perform the semantic "!!" cast implicitly. I
>> just did some basic tests locally and it does.
>> I prefer to be paranoid and not do any assumption though, unless I'm
>> told gcc always guarantees this correct implicit cast. I'm queuing
>> this patch and will send it to Ingo.
>
> It's unnecessary.
>
> 6.3.1.2p1:
>
> "When any scalar value is converted to _Bool, the result is 0
> if the value compares equal to 0; otherwise, the result is 1."

Ok then I'll ignore this patch. If somebody oppose, raise your hand.

Thanks.
