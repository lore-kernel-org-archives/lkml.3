Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3C0E5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:57:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:6908 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab3C0E5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:57:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="276466459"
Message-ID: <51527C17.3070901@intel.com>
Date: Wed, 27 Mar 2013 12:56:55 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org> <1364302359.5053.21.camel@laptop> <CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com> <1364308932.5053.46.camel@laptop> <CAKfTPtDo3dmEZU-R62unQH9j5CxZWJj+Ws5CTBptOzTohkNJMA@mail.gmail.com>
In-Reply-To: <CAKfTPtDo3dmEZU-R62unQH9j5CxZWJj+Ws5CTBptOzTohkNJMA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 11:55 PM, Vincent Guittot wrote:
>> > So extrapolating that to a 4+4 big-little you'd get something like:
>> >
>> >       |   little  A9  ||   big A15     |
>> >       | 0 | 1 | 2 | 3 || 4 | 5 | 6 | 7 |
>> > ------+---+---+---+---++---+---+---+---+
>> > buddy | 0 | 0 | 0 | 0 || 0 | 4 | 4 | 4 |
>> >
>> > Right?
> yes
> 
>> >
>> > So supposing the current ILB is 6, we'll only check 4, not 0-3, even
>> > though there might be a perfectly idle cpu in there.
> We will check 4,5,7 at MC level in order to pack in the group of A15
> (because they are not sharing the same power domain). If none of them
> are idle, we will look at CPU level and will check CPUs 0-3.

So you increase a fixed step here.
> 
>> >
>> > Also, your scheme fails to pack when cpus 0,4 are filled, even when
>> > there's idle cores around.
> The primary target is to pack the tasks only when we are in a not busy
> system so you will have a power improvement without performance
> decrease. is_light_task function returns false and  is_buddy_busy
> function true before the buddy is fully loaded and the scheduler will
> fall back into the default behavior which spreads tasks and races to
> idle.
> 
> We can extend the buddy CPU and the packing mechanism to fill one CPU
> before filling another buddy but it's not always the best choice for
> performance and/or power and thus it will imply to have a knob to
> select this full packing mode.

Just one buddy to pack tasks for whole level cpus definitely has
scalability problem. That is not good for powersaving in most of scenarios.


-- 
Thanks Alex
