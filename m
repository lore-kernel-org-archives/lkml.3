Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbaGURUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:20:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:64958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbaGURUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:20:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,702,1400050800"; 
   d="scan'208";a="546741490"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Mon, 21 Jul 2014 10:20:17 -0700
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
From: Darren Hart <dvhart@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Message-ID: <CFF29805.9D436%dvhart@linux.intel.com>
Thread-Topic: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <871tte3bjw.fsf@tassilo.jf.intel.com>
In-Reply-To: <871tte3bjw.fsf@tassilo.jf.intel.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/14, 9:45, "Andi Kleen" <andi@firstfloor.org> wrote:

>Andi Kleen <andi@firstfloor.org> writes:
>
>> Waiman Long <Waiman.Long@hp.com> writes:
>>
>>> This patch series introduces two new futex command codes to support
>>> a new optimistic spinning futex for implementing an exclusive lock
>>> primitive that should perform better than the same primitive using
>>> the wait-wake futex in cases where the lock owner is actively working
>>> instead of waiting for I/O completion.
>>
>> How would you distinguish those two cases automatically?
>
>Also BTW traditionally the spinning was just done in user space.
>
>This would be always even more efficient, because it would
>even avoid the syscall entry path.
>
>Given the glibc adaptive mutexes are not very good, but I'm sure those
>could be improved.

I presented on something along these lines a few years back, and various
people have asked for the sample code over the years. Andi is right, doing
this from user-space has the potential to be more efficient, the challenge
is getting access to privileged information, such as the state of the
mutex owner. You don't want to spin if the owner is sleeping. I did this
by adding a tidrunning call to the vdso. My somewhat hacked solution is
still available here:

http://git.infradead.org/users/dvhart/linux.git/shortlog/refs/heads/futex/t
idrunning/dev


I abandoned the spinning in the kernel thing due to the overhead of the
system call if I remember correctly. Also available here:

http://git.infradead.org/users/dvhart/linux.git/shortlog/refs/heads/futex/f
utex-lock-adaptive



-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



