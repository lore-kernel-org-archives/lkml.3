Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbaKTJKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:10:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:12061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbaKTJKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:10:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,422,1413270000"; 
   d="scan'208";a="640288240"
Date: Thu, 20 Nov 2014 16:49:32 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH v5] sched/deadline: support dl task migration during cpu
 hotplug
Message-ID: <20141120084932.GA3818@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1415754413-13988-1-git-send-email-wanpeng.li@linux.intel.com>
 <1415809626.15631.35.camel@tkhai>
 <20141112225636.GA23249@kernel>
 <1415873444.15631.42.camel@tkhai>
 <546485A2.7050501@gmail.com>
 <1415874091.15631.44.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415874091.15631.44.camel@tkhai>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peterz, Juri,
On Thu, Nov 13, 2014 at 01:21:31PM +0300, Kirill Tkhai wrote:
>> > Also, we should think about the following situation.
>> >
>> > DL task is left on dead rq. In your scheme it will be moved by the timer.
>> > But what will be if somebody changes the class of the task (before timer)?
>> 
>> I think timer will be cancelled in switched_from_dl().
>
>Yeah, but nobody will move this task to alive rq.
>
>> > In this case the task still remains on dead rq.
>> >
>> > We should handle this situation in some way.

I think pang's patch handle the exclusive cpusets rd->span issue, the concern 
which Kirill mentioned above maybe the last one block the patch merged, is 
there any idea or proposal from you experts?

Regards,
Wanpeng Li 

>> >
>> > Kirill
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> 
>
