Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbbAWEDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 23:03:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31157 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbbAWEDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 23:03:07 -0500
Message-ID: <54C1C7D2.906@oracle.com>
Date: Thu, 22 Jan 2015 23:02:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "davej@codemonkey.org.uk >> Dave Jones" <davej@codemonkey.org.uk>
Subject: Re: rcu, sched: WARNING: CPU: 30 PID: 23771 at kernel/rcu/tree_plugin.h:337
 rcu_read_unlock_special+0x369/0x550()
References: <54BBC084.2030604@oracle.com> <20150118232255.GD9719@linux.vnet.ibm.com> <54BE76B9.7070907@oracle.com> <20150121025754.GV9719@linux.vnet.ibm.com> <54BFC979.8040107@oracle.com> <20150122004305.GJ9719@linux.vnet.ibm.com> <54C1BFFD.9060707@oracle.com> <20150123035158.GP9719@linux.vnet.ibm.com>
In-Reply-To: <20150123035158.GP9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 10:51 PM, Paul E. McKenney wrote:
> On Thu, Jan 22, 2015 at 10:29:01PM -0500, Sasha Levin wrote:
>> > On 01/21/2015 07:43 PM, Paul E. McKenney wrote:
>>> > > On Wed, Jan 21, 2015 at 10:44:57AM -0500, Sasha Levin wrote:
>>>> > >> On 01/20/2015 09:57 PM, Paul E. McKenney wrote:
>>>>>>> > >>>>> So RCU believes that an RCU read-side critical section that ended within
>>>>>>>>> > >>>>>>> an interrupt handler (in this case, an hrtimer) somehow got preempted.
>>>>>>>>> > >>>>>>> Which is not supposed to happen.
>>>>>>>>> > >>>>>>>
>>>>>>>>> > >>>>>>> Do you have CONFIG_PROVE_RCU enabled?  If not, could you please enable it
>>>>>>>>> > >>>>>>> and retry?
>>>>>>> > >>>>>
>>>>>>> > >>>>> I did have CONFIG_PROVE_RCU, and didn't see anything else besides what I pasted here.
>>>>> > >>> OK, fair enough.  I do have a stack of RCU CPU stall-warning changes on
>>>>> > >>> their way in, please see v3.19-rc1..630181c4a915 in -rcu, which is at:
>>>>> > >>>
>>>>> > >>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
>>>>> > >>>
>>>>> > >>> These handle the problems that Dave Jones, yourself, and a few others
>>>>> > >>> located this past December.  Could you please give them a spin?
>>>> > >>
>>>> > >> They seem to be a part of -next already, so this testing already includes them.
>>>> > >>
>>>> > >> I seem to be getting them about once a day, anything I can add to debug it?
>>> > > 
>>> > > Could you please try reproducing with the following patch?
>> > 
>> > Yes, and I've got mixed results. It reproduced, and all I got was:
>> > 
>> > [  717.645572] ===============================
>> > [  717.645572] [ INFO: suspicious RCU usage. ]
>> > [  717.645572] 3.19.0-rc5-next-20150121-sasha-00064-g3c37e35-dirty #1809 Tainted: G        W
>> > [  717.645572] -------------------------------
>> > [  717.645572] kernel/rcu/tree_plugin.h:337 rcu_read_unlock() from irq or softirq with blocking in critical section!!!
>> > [  717.645572] !
>> > [  717.645572]
>> > [  717.645572] other info that might help us debug this:
>> > [  717.645572]
>> > [  717.645572]
>> > [  717.645572] rcu_scheduler_active = 1, debug_locks = 1
>> > [  717.645572] 3 locks held by trinity-c29/16497:
>> > [  717.645572]  #0:  (&sb->s_type->i_mutex_key){+.+.+.}, at: [<ffffffff81bec373>] lookup_slow+0xd3/0x420
>> > [  717.645572]  #1:
>> > [hang]
>> > 
>> > So the rest of the locks/stack trace didn't get printed, nor the pr_alert() which
>> > should follow that.
>> > 
>> > I've removed the lockdep call and will re-run it.
> Thank you!  You are keeping the pr_alert(), correct?

Yup, just the lockdep call goes away.


Thanks,
Sasha
