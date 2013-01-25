Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3AYOFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:05:23 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:51519 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3AYOFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:05:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAKfTPtCY7v7Er-bHj+-k3AQst075WOwfqY9rpVHv3k4nsM4E8Q@mail.gmail.com>
References: <1354537588-25831-1-git-send-email-vincent.guittot@linaro.org>
	<1354537588-25831-2-git-send-email-vincent.guittot@linaro.org>
	<CAFTL4hxPPddCmhcPrdZgWVSy3Z+9_Jr9ruT9L5qhq6yFuuEDNQ@mail.gmail.com>
	<CAKfTPtBJVwKurUjUkUfJefpzYpFi7KVfee9-4-OX2o_mmtW+Ag@mail.gmail.com>
	<CAKfTPtBbdKM3R__M+x7P9v4cLObbr=FF6QE+-mEkgx0DtcQefA@mail.gmail.com>
	<CAFTL4hxHJ+XKqHWAHVKmd6bHycr15mSdn6cLxh8wT=OHGD82uQ@mail.gmail.com>
	<CAKfTPtCY7v7Er-bHj+-k3AQst075WOwfqY9rpVHv3k4nsM4E8Q@mail.gmail.com>
Date: Fri, 25 Jan 2013 15:05:19 +0100
Message-ID: <CAFTL4hxk-aMGxL6X9=t4SKdZ2e83EnTZFqm4-YAQFLRQN0gtiQ@mail.gmail.com>
Subject: Re: [PATCH Resend 1/3] sched: fix nr_busy_cpus with coupled cpuidle
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        ccross@android.com, peterz@infradead.org, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/25 Vincent Guittot <vincent.guittot@linaro.org>:
>
> Le 25 janv. 2013 13:00, "Frederic Weisbecker" <fweisbec@gmail.com> a écrit :
>
>
>>
>> 2013/1/25 Vincent Guittot <vincent.guittot@linaro.org>:
>> > This sequence is not the right one
>> >
>> >> I'm going to look for the saved trace to check the sequence above
>> >
>> > I haven't been able to reproduce the bug that this patch was supposed to
>> > solved. The patch 2 and 3 seem enough to fix the nr_busy_cpus field. I
>> > will
>> > continue to try to reproduce it but it seems that it was a side effect
>> > of
>> > the 2 others fixes of the series
>>
>> Ok. I just checked again as well and I can't find a scenario where
>> this can happen. If you find it out or trigger the bug again, don't
>> hesitate to resend this patch.
>
> Ok. I'm going to update the patch serie without this patch

Actually your second patch may cause this, as it clears the NOHZ_IDLE
flag on CPUs that are idle on boot and which could stay that way for a
while. And your second patch is spotting something serious. I'll reply
on it after more thoughts.
