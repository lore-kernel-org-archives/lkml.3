Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576Ab3BMRtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:49:08 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:50508 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934405Ab3BMRtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:49:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAKfTPtCuj4xZi2mBZP_Vz-zzySwBLKPn2aNkdqf6g8sVJoyS+A@mail.gmail.com>
References: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
	<20130213061853.GA4043@brouette>
	<CAKfTPtDCPKeQpcS4mQc7Jp7+wK2EuvnCUqAzL7SOELVVL3jztw@mail.gmail.com>
	<20130213092154.GA4481@brouette>
	<CAKfTPtDprVAA0o6sTugYk8RiaUkGXUmSvd4RJbTEhNkKj7B-5A@mail.gmail.com>
	<20130213140843.GA21308@brouette>
	<CAKfTPtCuj4xZi2mBZP_Vz-zzySwBLKPn2aNkdqf6g8sVJoyS+A@mail.gmail.com>
Date: Wed, 13 Feb 2013 18:49:03 +0100
Message-ID: <CAKfTPtDrTyof40Lk7MzdqEon2dkN=RZNEvP5BQSJVKP-EYsCXw@mail.gmail.com>
Subject: Re: [PATCH] sched: fix env->src_cpu for active migration
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Damien Wyart <damien.wyart@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 February 2013 15:28, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> On 13 February 2013 15:08, Damien Wyart <damien.wyart@gmail.com> wrote:
>> * Vincent Guittot <vincent.guittot@linaro.org> [2013-02-13 13:08]:
>>> Damien,
>>> Regarding your sched_domain config and especially the flags field, you
>>> should not be impacted by my patch because
>>> - need_active_balance is the only new place that use env->src_cpu in
>>> the load_balance function
>>> - and your machine will never test the condition: "env->src_cpu >
>>> env->dst_cpu" in need_active_balance because  SD_ASYM_PACKING is not
>>> set in your config
>>
>>> Have you tested the patch with others that could have modified the
>>> load_balance function ?
>>
>> Yes, sorry, I should have been more precise in my initial report: your
>> patch was not applied on top of vanilla 3.8-rc7, but a few other patches
>> were also present. Seems the ones impacting load_balance are from
>> Frederic's nohz work
>> (http://git.kernel.org/?p=linux/kernel/git/frederic/linux-dynticks.git;a=shortlog;h=refs/heads/3.8-rc6-nohz4)
>>
>
> ok
> thanks for the pointer. i'm going to have a look
>
>
>> The patches from there modifying load_balance are:
>> - "sched: Update nohz rq clock before searching busiest group on load balancing"
>> - "sched: Update clock of nohz busiest rq before balancing"
>>
>> In this test, I did not use any kernel parameter related to this
>> patchset (full_nohz, etc.).
>>
>> I am adding Frederic in Cc, not sure if the breakage is to be
>> investigated on your side or his...
>
> probably both

I have look into Frederic's tree but i didn't find any reason that
could explain your problem. May be Frederic will have some ideas
I have also tested his branch with and without my patch and both
kernel are booting (on an ARM platform without using the full_nohz
feature ).
I have faced a conflict when i have applied my patch on his branch as
we insert code at the same place. You should have faced the same
conflict. How have you solved it ?

Vincent
>
>>
>>
>> Thanks for your explanations,
>> --
>> Damien
