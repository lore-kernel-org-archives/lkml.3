Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaBNSzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:55:16 -0500
Received: from smtp3.Stanford.EDU ([171.67.219.83]:59949 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751242AbaBNSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:55:14 -0500
Message-ID: <52FE6681.8090807@ccrma.stanford.edu>
Date: Fri, 14 Feb 2014 10:54:57 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: nando@ccrma.Stanford.EDU, linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12.9-rt13: BUG: soft lockup
References: <52FBF2F1.8040504@localhost> <alpine.DEB.2.02.1402132324230.21991@ionos.tec.linutronix.de> <52FD4D89.2000207@localhost> <alpine.DEB.2.02.1402140053000.21991@ionos.tec.linutronix.de> <52FDB71F.2020000@ccrma.stanford.edu> <alpine.DEB.2.02.1402141040460.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402141040460.21991@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 02:43 AM, Thomas Gleixner wrote:
> On Thu, 13 Feb 2014, Fernando Lopez-Lezcano wrote:
>> On 02/13/2014 03:55 PM, Thomas Gleixner wrote:
>>> On Thu, 13 Feb 2014, Fernando Lopez-Lezcano wrote:
>>>
>>>> On 02/13/2014 02:25 PM, Thomas Gleixner wrote:
>>>>> On Wed, 12 Feb 2014, Fernando Lopez-Lezcano wrote:
>>>>>> [771508.546449] RIP: 0010:[<ffffffff810dc60a>]  [<ffffffff810dc60a>]
>>>>>> smp_call_function_many+0x2ca/0x330
>>>>>
>>>>> Can you decode the exact location inside of smp_call_function_many via
>>>>> addr2line please ?
>>
>> # addr2line -e
>> /usr/lib/debug/lib/modules/3.12.9-301.rt13.1.fc20.ccrma.x86_64+rt/vmlinux
>> ffffffff810dc60e
>> /usr/src/debug/kernel-3.12.fc20.ccrma/linux-3.12.9-301.rt13.1.fc20.ccrma.x86_64/kernel/smp.c:108
>
> So it's stuck in csd_lock_wait(), which means that the csd of the
> target cpu is not free.
>
> Is the machine completely dead or can you still retrieve information
> from it?

After migrating to fc20/3.12.x-rtyy I started experiencing freezes in 
some workstations. This coincided with one of our students running high 
cpu load multi-core computations in them (he had been doing that before 
under 3.10.x-rtyy with no problems). In the morning I would find 
workstations unresponsive and catatonic. Probably his software was still 
eating up cpu as the machines were warm (ie: still under load). No pings 
back or keyboard/mouse/display response.

This was the only time I could get information from a machine while it 
was in the process of freezing up - but this might have been a different 
issue. I was ssh'd in and that terminal became unresponsive. I managed 
to ssh in again and looked at the logs. The machine was not completely 
frozen but it eventually became completely catatonic. For all I know 
this might be different from the locked machines syndrome as it left 
traces in the logs (I could forward you all the log entries if you want).

I could try to boot one of the machines into 3.12.xrtyy, replicate the 
conditions and wait. What should I look for if I can catch this in the act?

-- Fernando
