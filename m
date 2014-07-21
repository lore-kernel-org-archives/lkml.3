Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaGUWl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:41:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:1770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbaGUWlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:41:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,705,1400050800"; 
   d="scan'208";a="576682134"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Mon, 21 Jul 2014 15:41:42 -0700
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
From: Darren Hart <dvhart@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
CC: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
Message-ID: <CFF2E3D6.9D525%dvhart@linux.intel.com>
Thread-Topic: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
 <8761iq3bp3.fsf@tassilo.jf.intel.com>
 <871tte3bjw.fsf@tassilo.jf.intel.com>
 <CFF29A00.9D44A%dvhart@linux.intel.com>
 <CFF29E4A.9D44E%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop>
 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
 <alpine.DEB.2.10.1407212344130.20847@nanos>
In-Reply-To: <alpine.DEB.2.10.1407212344130.20847@nanos>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/14, 14:47, "Thomas Gleixner" <tglx@linutronix.de> wrote:

>On Mon, 21 Jul 2014, Andy Lutomirski wrote:
>> On Mon, Jul 21, 2014 at 2:27 PM, Peter Zijlstra <peterz@infradead.org>
>>wrote:
>> > All this is predicated on the fact that syscalls are 'expensive'.
>> > Weren't syscalls only 100s of cycles? All this bitmap mucking is far
>> > more expensive due to cacheline misses, which due to the size of the
>> > things is almost guaranteed.
>> 
>> 120 - 300 cycles for me, unless tracing happens, and I'm working on
>> reducing the incidence of tracing.
>
>So it's a non issue indeed and definitely not worth the trouble of
>that extra storage, the scheduler overhead, etc.
>
>Summary: Once you can't take it atomically in user space, you've lost
>	 anyway. And we are better off to do the magic spinning in
>	 kernel where we have all the information accessible already.

And we have such an implementation with the FUTEX_LOCK_ADAPTIVE code we
discussed back in Oct 2010 (purely kernel, no VDSO), updated with some of
your and other's comments:

http://git.infradead.org/users/dvhart/linux.git/shortlog/refs/heads/futex/f
utex-lock/v7


I can work on forward porting this series to current mainline (post recent
security fixes) and cleaning up the commentary and such if people are
interested in seeing this implementation (based on Peter Z's spinning
mutex work iirc) resurrected...

-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



