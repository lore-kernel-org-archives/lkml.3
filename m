Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3KRPIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:08:30 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60238 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3KRPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:08:22 -0500
Message-ID: <528A2D59.3080001@ti.com>
Date: Mon, 18 Nov 2013 09:08:09 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ceh@ti.com>,
        Tobias Diedrich <ranma+xen@tdiedrich.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] cpufreq: stats: Do not populate stats when policy->cur
 has no exact match
References: <1384561243-30391-1-git-send-email-nm@ti.com> <1423628.uM8DtnYzDe@vostro.rjw.lan> <5287010F.9000508@linaro.org>
In-Reply-To: <5287010F.9000508@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 11:22 PM, viresh kumar wrote:
> On Saturday 16 November 2013 06:40 AM, Rafael J. Wysocki wrote:
>> On Friday, November 15, 2013 06:20:43 PM Nishanth Menon wrote:
> 
>>> So, instead of having a statistics information that never ever
>>> reflects valid data in the mentioned case and scratching our heads, we
>>> instead, refuse to populate any of the statistics entries and note in
>>> kernel log the error condition for developers to fix. The only useable
> 
> s/useable/usable
> 
>>> information are the available frequencies which is already available
>>> in other cpufreq sysfs entries.
> 
>> I like this one.  Any objections from anyone?
> 
> Well nothing against the patch but I have other thoughts. There are platforms
> which might have no choice of fixing this issue as their bootloaders might be
> setting boot freq to any value outside of our freq table.
> 
> And those might not have a chance to fix that in driver as well in case they are
> using something like cpufreq-cpu0..
> 
> So, eventually this patch wouldn't do anything except giving a boot time error
> and not initializing any stats at all..
> 
> Wouldn't it be better to create another frequency in all these tables, which
> will be an *Invalid* frequency.. With a value of -1 (i.e. largest value of an
> unsigned int) ??
> 
> And so nobody will ever miss stats again, even if they are running on invalid
> frequencies. We will capture that information too:
> - we have moved from/to invalid frequency to/from a valid/invalid frequency this
> much times.
> - We have stayed at valid/invalid frequencies for this much time.
> 
> I have a untested patch for this. If this looks okay, Nishant can you please try
> below patch? With some fixups from your side :)

http://pastebin.mozilla.org/3628975

I agree that it does show something, but would we not rather prefer to
stick with the entries available in freq_table than have to deal with
invalid frequencies that may be provided by the driver? for example:
how do we in stat know that there will only be one invalid frequency
request?


> 

[..]
> (@Rafael: Finally I have moved to thunderbird, found a way out, so no more
> crappy attachments from me :))
> 
there are some patch wrapping that thunderbird tends to do - I prefer
mutt that way, when I need to send inline patches :).

-- 
Regards,
Nishanth Menon
