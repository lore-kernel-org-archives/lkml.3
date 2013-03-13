Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab3CMUup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:50:45 -0400
Received: from relay1.sgi.com ([192.48.179.29]:45057 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178Ab3CMUun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:50:43 -0400
Message-ID: <5140E6A1.20107@sgi.com>
Date: Wed, 13 Mar 2013 15:50:41 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
References: <51265E0F.6090209@sgi.com> <1361550275-5716-1-git-send-email-nzimmer@sgi.com> <3505617.pgqBjPDzlA@vostro.rjw.lan>
In-Reply-To: <3505617.pgqBjPDzlA@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 06:23 PM, Rafael J. Wysocki wrote:
> On Friday, February 22, 2013 10:24:33 AM Nathan Zimmer wrote:
>> I am noticing the cpufreq_driver_lock is quite hot.
>> On an idle 512 system perf shows me most of the system time is spent on this
>> lock.  This is quite significant as top shows 5% of time in system time.
>> My solution was to first convert the lock to a rwlock and then to the rcu.
>>
>> v2: Rebase
>>
>> v3: Read the RCU documentation instead of skimming it.  Also I based on
>> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.9-rc1
>> I assumed that was what you would prefer Rafael.
>>
>> v4: Removed an unnecessary syncronize_rcu().
>>
>>
>> Nathan Zimmer (2):
>>    cpufreq: Convert the cpufreq_driver_lock to a rwlock
>>    cpufreq: Convert the cpufreq_driver_lock to use the rcu
>>
>>   drivers/cpufreq/cpufreq.c | 286 ++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 211 insertions(+), 75 deletions(-)
> I'm going to take patch [1/2] for v3.10, but patch [2/2] still needs some
> work it seems.  Is that correct?  If so, are you going to send an update?
>
> Rafael
>

Viresh pointed out that cpufreq_cpu_data still needs a lock.
This means placing a vanilla spinlock back into __cpufreq_cpu_get which 
is what I need to avoid.  I haven't had the time I should to sort that out.


Nate


