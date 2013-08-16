Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3HPRJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:09:54 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:44023 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3HPRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130815180521.GV24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
	<20130815180521.GV24092@twins.programming.kicks-ass.net>
Date: Sat, 17 Aug 2013 02:09:48 +0900
Message-ID: <CAAmzW4PuVAwzdvriAyamSsS0JyJ-2mYwq7mj2JRy5SG5r-THsg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] sched: clean-up struct sd_lb_stat
From: JoonSoo Kim <js1304@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -     if (sds->max_load < sds->avg_load) {
>> +     if (busiest->avg_load < this->avg_load) {
>
> Tsk, inconsistency there.

Okay, this is my mistake.

>
>> -     max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
>> +     max_pull = min(busiest->avg_load - sds->sd_avg_load,
>> +                     load_above_capacity);
>
> you just made it possible for the above subtraction to become negative.
>
> Also not entirely sure why you renamed sds->avg_load; renaming it back.

Okay, sds->avg_load seems to be better :)

Thanks.
