Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaDEHSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 03:18:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:8430 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbaDEHSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 03:18:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,799,1389772800"; 
   d="scan'208";a="507462929"
Message-ID: <533FAE29.4080209@intel.com>
Date: Sat, 05 Apr 2014 15:18:01 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 1935 at kernel/timer.c:1621 migrate_timer_list()
References: <20140404031928.GC11828@localhost> <CAKohponbGFFo+W7X24e4h3ub2L8Tkb89eP6_F17CRYELk0yeRQ@mail.gmail.com> <533E635F.9050803@intel.com> <CAKohpon+THY2NXEEOcWRbmrpfQUZYbHfO+Lw=D9TaJWk+_-J2g@mail.gmail.com> <533F86D4.10007@intel.com> <CAKohpokStOgdO-KFn8hcyV+neaNCvHLSG9od=qyi2-4rV62DRw@mail.gmail.com>
In-Reply-To: <CAKohpokStOgdO-KFn8hcyV+neaNCvHLSG9od=qyi2-4rV62DRw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2014 02:26 PM, Viresh Kumar wrote:
> On 5 April 2014 10:00, Jet Chen <jet.chen@intel.com> wrote:
>> vmlinuz from our build system doesn't have debug information. It is hard to
>> use objdump to identify which routine is timer->function.
>
> I see...
>
>> But after several times trials, I get below dmesg messages.
>> It is clear to see address of "timer->function" is 0xffffffff810d7010.
>> In calling stack, " [<ffffffff810d7010>] ?
>> clocksource_watchdog_kthread+0x40/0x40 ". So I guess timer->function is
>> clocksource_watchdog_kthread.
>
> Hmm.. not exactly this function as this isn't timer->function for any timer.
> But I think I have found the right function with this hint:
> clocksource_watchdog()
>
> Can you please try to test the attached patch, which must fix it.

Your patch fixes it!

> Untested. I will
> then post it with your Tested-by :)

Thank you

>
> --
> viresh
>


