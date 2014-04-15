Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbaDOEp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:45:27 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:64700 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaDOEpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140414232218.GE1877@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
	<b38dda39bf6cd18df5fab86f7c7cc86a6979786f.1397492345.git.viresh.kumar@linaro.org>
	<20140414232218.GE1877@localhost.localdomain>
Date: Tue, 15 Apr 2014 10:15:24 +0530
Message-ID: <CAKohpomKrQydz12mXQnQe8sw3X-OotRqLDCxQFi5goyk6D9-=w@mail.gmail.com>
Subject: Re: [PATCH 29/38] tick-sched: remove wrapper around __tick_nohz_task_switch()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 04:52, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, Apr 14, 2014 at 09:53:51PM +0530, Viresh Kumar wrote:
>> __tick_nohz_task_switch() was called only from tick_nohz_task_switch() and there
>> is nothing much in tick_nohz_task_switch() as well. IOW, we don't need
>> unnecessary wrapper over __tick_nohz_task_switch() to be there. Merge all code
>> from __tick_nohz_task_switch() into tick_nohz_task_switch() and move it to
>> tick-sched.c.
>>
>> This also moves check for tick_nohz_tick_stopped() outside of irq_save()
>> context.
>
> No, the wrapper is there on purpose in order to optimize the full dynticks off case in
> the context switch path with the jump label'ed check on tick_nohz_full_enabled().

Just to clarify, you are saying that:

Wrapper was there to save an extra function call when tick_nohz_full_enabled()
returns false, as tick_nohz_task_switch() will be inlined ?

In this case probably we can move !can_stop_full_tick() as well to the wrapper ?
