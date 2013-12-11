Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079Ab3LKBd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:33:57 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46678 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3LKBd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:33:56 -0500
Message-ID: <52A7C0F4.1000209@linaro.org>
Date: Wed, 11 Dec 2013 09:33:40 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, fengguang.wu@intel.com, james.hogan@imgtec.com,
        jason.low2@hp.com, viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] nohz_full: update cpu load fix in nohz_full
References: <1386074112-30754-1-git-send-email-alex.shi@linaro.org> <1386074112-30754-4-git-send-email-alex.shi@linaro.org> <20131210140217.GA10633@localhost.localdomain>
In-Reply-To: <20131210140217.GA10633@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 10:02 PM, Frederic Weisbecker wrote:
>> >  		 * We were idle, this means load 0, the current load might be
>> >  		 * !0 due to remote wakeups and the sort.
>> > +		 * or we may has only one task and in NO_HZ_FULL, then still use
>> > +		 * normal cpu load.
>> >  		 */
>> > -		__update_cpu_load(this_rq, 0, pending_updates);
>> > +		if (this_rq->cfs.h_nr_running) {
>> > +			unsigned load = get_rq_runnable_load(this_rq);
>> > +			__update_cpu_load(this_rq, load, pending_updates);
>> > +		} else
>> > +			__update_cpu_load(this_rq, 0, pending_updates);
> But decay_load_missed() doesnt handle non 0 loads, right? It probably make more sense
> to first fix __update_cpu_load() to make it handle this kind of thing before fixing the caller.
> 
> Now you had patches that remove the cpu_load secondary idx I think? You should move this patc


Thanks for response!
Yes, after get your review, I plan to merge this patch with cpu_load
decay removing, if that patchset possible get to upstream. :)

-- 
Thanks
    Alex
