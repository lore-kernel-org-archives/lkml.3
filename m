Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3DKGB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 02:01:56 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:51699 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3DKGBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:01:55 -0400
Message-ID: <516651C8.307@linux.vnet.ibm.com>
Date: Thu, 11 Apr 2013 14:01:44 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1365583873.30071.31.camel@laptop> <51652F43.7000300@linux.vnet.ibm.com>
In-Reply-To: <51652F43.7000300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041105-5816-0000-0000-00000782078F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 05:22 PM, Michael Wang wrote:
> Hi, Peter
> 
> Thanks for your reply :)
> 
> On 04/10/2013 04:51 PM, Peter Zijlstra wrote:
>> On Wed, 2013-04-10 at 11:30 +0800, Michael Wang wrote:
>>> | 15 GB   |      32 | 35918 |   | 37632 | +4.77% | 47923 | +33.42% |
>>> 52241 | +45.45%
>>
>> So I don't get this... is wake_affine() once every milisecond _that_
>> expensive?
>>
>> Seeing we get a 45%!! improvement out of once every 100ms that would
>> mean we're like spending 1/3rd of our time in wake_affine()? that's
>> preposterous. So what's happening?
> 
> Not all the regression was caused by overhead, adopt curr_cpu not
> prev_cpu for select_idle_sibling() is a more important reason for the
> regression of pgbench.
> 
> In other word, for pgbench, we waste time in wake_affine() and make the
> wrong decision at most of the time, the previously patch show
> wake_affine() do pull unrelated tasks together, that's good if current
> cpu still cached hot data for wakee, but that's not the case of the
> workload like pgbench.

Please let me know if I failed to express my thought clearly.

I know it's hard to figure out why throttle could bring so many benefit,
since the wake-affine stuff is a black box with too many unmeasurable
factors, but that's actually the reason why we finally figure out this
throttle idea, not the approach like wakeup-buddy, although both of them
help to stop the regression.

It's fortunate that there is a benchmark could help to find out the
regression, and now we have a simple and efficient approach ready for
action ;-)

Regards,
Michael Wang

> 
> The workload just don't satisfied the decision changed by wake-affine,
> the more wake-affine active, the more it suffered, that's why 100ms show
> better results than 1ms, but when reached some rate, the benefit and
> lost of wake-affine will be balanced.
> 
> Regards,
> Michael Wang
> 
>>
>>
>>
> 

