Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaGQBub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:50:31 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:60732 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaGQBu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:50:28 -0400
Message-ID: <53C72BFE.4040207@gmail.com>
Date: Wed, 16 Jul 2014 21:50:54 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of atomic_add_return(0,
 v)
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com> <20140709000701.GJ4603@linux.vnet.ibm.com> <CAJhHMCBS2y_f28UO6SOp7LjnX3owm+C5_qCjzYANEaU__8jxng@mail.gmail.com> <20140709195650.GZ4603@linux.vnet.ibm.com> <CAJhHMCCO9aR6YvVHnc7XFXGv1REW5tGtNqSEosf+x+8O=tVy3w@mail.gmail.com> <20140711094333.GG16041@linux.vnet.ibm.com> <CAJhHMCDRRoRfBuw85tqgiudOJX3Lb21yjZNWp0fhn7XG2-RrSQ@mail.gmail.com> <20140712120806.GA16041@linux.vnet.ibm.com> <CAJhHMCA7crMuM=owe4T0S5FUZi1SGZPo5OFRtb6Cr5_veJzd+A@mail.gmail.com> <20140716131403.GS8690@linux.vnet.ibm.com>
In-Reply-To: <20140716131403.GS8690@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 09:14 AM, Paul E. McKenney wrote:
> On Mon, Jul 14, 2014 at 09:27:00AM -0400, Pranith Kumar wrote:
>> On Sat, Jul 12, 2014 at 8:08 AM, Paul E. McKenney wrote:
>>>
>>> They ensure that any RCU read-side critical sections that took place before
>>> the current (or previous) idle/userspace period on the remote CPU in
>>> question are seen as having completed before the completion of the current
>>> grace period.  It also ensures that any RCU read-side critical sections
>>> that extend beyond the end of the current grace period (thus starting
>>> after the current (or previous) idle/userspace period) see any updates
>>> that were carried out before the beginning of the current grace period.
>>>
>>> Of course, that is also the purpose of many of RCU's memory barriers,
>>> so this probably doesn't help much.  An alternative explanation is that
>>> it ensures a coherent view of the ->dynticks counter, but I am quite
>>> sure that this helps even less.
>>>
>>> So here is the problem we are having:
>>>
>>> The dyntick_save_progress_counter() and rcu_implicit_dynticks_qs()
>>> functions are really bad places to start reading the RCU code.  I would
>>> say that starting there is like learning to swim by diving into the deep
>>> end of a swimming pool, but that doesn't really capture it.  Instead,
>>> it is more like learning to swim by diving from the top of this waterfall:
>>>
>>> http://blog.pacificnorthwestphotography.com/wp-content/uploads/2011/03/54.jpg
>>>
>>> To understand these functions, you will first need to understand how
>>> the rest of RCU works.  These functions are tiny cogs in RCU's energy
>>> efficiency optimization mechanism, which fits into the larger grace-period
>>> detection mechanism.  The purpose of the two atomic operations is to
>>> preserve the memory-ordering guarantees called out in the docbook header
>>> comments for call_rcu() and synchronize_rcu(), and I must confess that
>>> it is not clear to me that you actually read these header comments.
>>> Even so, these two functions interact with lots of other accesses to
>>> implement these guarantees -- so again, it is really really difficult
>>> to understand these two functions in isolation.
>>>
>>> Please see the end of this message for my suggested order of learning
>>> the RCU code.  A study plan, if you will.
>>
>> This guide helps a lot, thank you for the detailed study plan. I will
>> make sure to go slow and steady. :)
> 
> Best of everything with it!
> 

Thanks a lot, Paul, for taking the time to help me understand. Hopefully one of
these days, after reading the study list, I actually will :)

--
Pranith.
