Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaJMLwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:52:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbaJMLwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:52:16 -0400
Message-ID: <543BBCEA.4080202@redhat.com>
Date: Mon, 13 Oct 2014 07:52:10 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <CAKohpomk0GNJcGKxLX3HuaMBgPiSNzFp5BniyNgRbtoLqPm6bQ@mail.gmail.com>
In-Reply-To: <CAKohpomk0GNJcGKxLX3HuaMBgPiSNzFp5BniyNgRbtoLqPm6bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/13/2014 06:43 AM, Viresh Kumar wrote:
> On 1 August 2014 22:48, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 08/01/14 03:27, Prarit Bhargava wrote:
>>>
>>> Can you send me the test and the trace of the deadlock?  I'm not creating it with:
>>>
>>
>> This was with conservative as the default, and switching to ondemand
>>
>> # cd /sys/devices/system/cpu/cpu2/cpufreq
>> # ls
>> affected_cpus                  scaling_available_governors
>> conservative                   scaling_cur_freq
>> cpuinfo_cur_freq               scaling_driver
>> cpuinfo_max_freq               scaling_governor
>> cpuinfo_min_freq               scaling_max_freq
>> cpuinfo_transition_latency     scaling_min_freq
>> related_cpus                   scaling_setspeed
>> scaling_available_frequencies  stats
>> # cat conservative/down_threshold
>> 20
>> # echo ondemand > scaling_governor
>>
>>  ======================================================
>>  [ INFO: possible circular locking dependency detected ]
>>  3.16.0-rc3-00039-ge1e38f124d87 #47 Not tainted
>>  -------------------------------------------------------
>>  sh/75 is trying to acquire lock:
>>   (s_active#9){++++..}, at: [<c0358a94>] kernfs_remove_by_name_ns+0x3c/0x84
> 
> Can you please retry this on mainline? I wasn't able to reproduce it
> now over 3.17.
> I am trying this on Exynos b.L implementation..

I have 100% reproducibility on latest mainline.

Viresh, please see my next post on the locking issues in cpufreq.

P.

> 
