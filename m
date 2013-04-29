Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab3D2Vnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:43:45 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36604 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932908Ab3D2Vnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:43:41 -0400
Message-ID: <517EE98C.40300@sgi.com>
Date: Mon, 29 Apr 2013 16:43:40 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-next v8] cpufreq: convert the cpufreq_driver to
 use the rcu
References: <515C5AB6.5090109@sgi.com> <3218775.0Qs2EbHdzR@vostro.rjw.lan> <20130429213728.GR3780@linux.vnet.ibm.com> <2810635.tjpGLjVH1J@vostro.rjw.lan>
In-Reply-To: <2810635.tjpGLjVH1J@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 04:47 PM, Rafael J. Wysocki wrote:
> On Monday, April 29, 2013 02:37:28 PM Paul E. McKenney wrote:
>> On Mon, Apr 29, 2013 at 12:22:32AM +0200, Rafael J. Wysocki wrote:
>>> On Thursday, April 04, 2013 09:57:19 PM Viresh Kumar wrote:
>>>> On 4 April 2013 20:23, Nathan Zimmer <nzimmer@sgi.com> wrote:
>>>>> We eventually would like to remove the rwlock cpufreq_driver_lock or convert
>>>>> it back to a spinlock and protect the read sections with RCU.  The first step in
>>>>> that is moving the cpufreq_driver to use the rcu.
>>>>> I don't see an easy wasy to protect the cpufreq_cpu_data structure with the
>>>>> RCU, so I am leaving it with the rwlock for now since under certain configs
>>>>> __cpufreq_cpu_get is hot spot with 256+ cores.
>>>>>
>>>>> v5: Go a different way and split up the lock and use the rcu
>>>>> v6: use bools instead of checking function pointers
>>>>>      covert the cpufreq_data_lock to a rwlock
>>>>> v7: Rebase to use the already accepted half
>>>>> v8: Correct have_governor_per_policy
>>>>>      Reviewed location of rcu_read_(un)lock in several spots
>>>> Sorry for long delay or too many versions of this patch :)
>>>>
>>>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>>> Unfortunately, I had to revert this one, because it is obviously buggy.  Why?
>>> Because it adds rcu_read_lock()/rcu_read_unlock() around sysfs_create_file()
>>> which may sleep due to a GFP_KERNEL memory allocation.  Sorry for failing to
>>> notice that earlier.
>> One workaround might be to use SRCU, which allows sleeping in its
>> critical sections.
> Agreed, but at this point of the cycle I'd just preferred to do the revert and
> start over.
>
> Thanks,
> Rafael
>
>
Agreed, I think that would be cleanest.  I probably won't have time to 
get to it this week though.

Nate

