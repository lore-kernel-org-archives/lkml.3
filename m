Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab3AaIZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:25:11 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48154 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3AaIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:25:08 -0500
Message-ID: <510A2A50.1090207@linux.vnet.ibm.com>
Date: Thu, 31 Jan 2013 16:24:48 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de> <1359580757-4121-3-git-send-email-bigeasy@linutronix.de> <5109D313.1020409@linux.vnet.ibm.com>	<8738xiue31.fsf@sejong.aot.lge.com> <510A1198.2070803@linux.vnet.ibm.com>	<87txpxu9cx.fsf@sejong.aot.lge.com> <510A1D7A.3050408@linux.vnet.ibm.com> <87pq0lu7ew.fsf@sejong.aot.lge.com>
In-Reply-To: <87pq0lu7ew.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013108-5816-0000-0000-0000067E4C75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 03:40 PM, Namhyung Kim wrote:
> On Thu, 31 Jan 2013 15:30:02 +0800, Michael Wang wrote:
>> On 01/31/2013 02:58 PM, Namhyung Kim wrote:
>>> But AFAIK the number of states in cpuidle is usually less than 10 so maybe
>>> we can change the weight then, but there's no promise...
>>
>> And I just got another case we should take care:
>>
>> 	group 0		cpu 0			cpu 1
>> 			power index 8		power index 8
>>
>>
>> 	group 1		cpu 2			cpu 3
>> 			power index 0		load 15
>>
>> so load of group 0 is 16 and group 1 is 15, but group 0 is better...
> 
> Maybe it's not.  The cpus in group 0 are in a lower power state so that
> there will be a benefit to select cpu 2 from the power' PoV IMHO.  Also
> such a low power state has a longer exit latency so that we should
> choose cpu2 to get a better performance and it's the basic idea of this
> patchset I believe.

Well, this case is just to notify that, we may face the comparison
between load and index, not between index and index, I just doubt there
won't be a rule which could take care both, besides, comparison between
load and index is strange...

Regards,
Michael Wang

> 
> Thanks,
> Namhyung
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

