Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3GEGpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:45:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:59345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3GEGpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:45:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1000,1363158000"; 
   d="scan'208";a="340808031"
Message-ID: <51D66B48.4010205@intel.com>
Date: Fri, 05 Jul 2013 14:44:24 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 3/3] clocksource: fix can not set tsc as clocksource bug
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-4-git-send-email-alex.shi@intel.com> <alpine.DEB.2.02.1307041227470.11637@ionos.tec.linutronix.de> <alpine.DEB.2.02.1307041419560.11637@ionos.tec.linutronix.de> <51D63413.5020809@intel.com> <alpine.DEB.2.02.1307050732330.11637@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307050732330.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 01:41 PM, Thomas Gleixner wrote:
>>>>> > >> > Unlikely, but if we have 3 watched clocksources which have the HRES
>>>>> > >> > bit set, you'd call 3 times clocksource_select().
>>> > > Also the reselect must be called outside the watchdog_lock region.
>> > 
>> > Sorry for stupid, the watchdog_lock used protect watchdog related
>> > resource. but clocksource_select doesn't touch them. So, I know it isn't
>> > necessary to put reselect under this lock. Just don't know why the
>> > reselect *must* be called outside of it?
>   clocksource_select()
>     timekeeping_notify()
>       stop_machine()
>         get_online_cpus()
> 	  might_sleep()
> 	  mutex_lock()
> 
> So we need to be in preemptible context when we call clocksource_select().

understand! many thanks!

-- 
Thanks
    Alex
