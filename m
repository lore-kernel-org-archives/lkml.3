Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3BFGUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:20:25 -0500
Received: from mail.candelatech.com ([208.74.158.172]:52826 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3BFGUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:20:23 -0500
Message-ID: <5111F623.1090606@candelatech.com>
Date: Tue, 05 Feb 2013 22:20:19 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
References: <5111AD8D.1080005@candelatech.com> <20130206042611.GB9161@home.goodmis.org>
In-Reply-To: <20130206042611.GB9161@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 08:26 PM, Steven Rostedt wrote:
> On Tue, Feb 05, 2013 at 05:10:37PM -0800, Ben Greear wrote:
>>
>>
>> ===============================
>> [ INFO: suspicious RCU usage. ]
>> 3.7.6+ #4 Tainted: G         C O
>> -------------------------------
>> /home/greearb/git/linux-3.7.dev.y/kernel/rcutree.c:360 Illegal idle entry in RCU read-side critical section.!
>>
>> other info that might help us debug this:
>>
>>
>> RCU used illegally from idle CPU!
>> rcu_scheduler_active = 1, debug_locks = 1
>> RCU used illegally from extended quiescent state!
>> 1 lock held by swapper/1/0:
>>   #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81489632>] rcu_read_lock+0x0/0x6f
>>
>> stack backtrace:
>> Pid: 0, comm: swapper/1 Tainted: G         C O 3.7.6+ #4
>> Call Trace:
>>   <IRQ>  [<ffffffff810cecbd>] lockdep_rcu_suspicious+0xfc/0x105
>>   [<ffffffff810fe146>] rcu_eqs_enter_common+0xef/0x178
>>   [<ffffffff810fe24e>] rcu_irq_exit+0x7f/0xb0
>>   [<ffffffff8108edf5>] irq_exit+0xc0/0xcc
>>   [<ffffffff8100b635>] do_IRQ+0x97/0xae
>>   [<ffffffff815543b2>] common_interrupt+0x72/0x72
>>   <EOI>  [<ffffffff81011082>] ? mwait_idle+0x77/0x9f
>>   [<ffffffff81011079>] ? mwait_idle+0x6e/0x9f
>>   [<ffffffff81011379>] cpu_idle+0x68/0xbc
>>   [<ffffffff8154ce84>] start_secondary+0x1fc/0x203
>
> BTW, did the above error only happen when you added the dump of the
> locks, or was it always there? Is this the bug you were trying to debug?

It's often there, at least..and was from the beginning, and I
am interested in debugging it.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

