Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946108Ab3FUVXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:23:47 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47417 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946078Ab3FUVXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <51C47377.2000208@linux.intel.com>
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com>
 <20130614160522.GG32728@e103034-lin> <51C07ABC.2080704@linux.intel.com>
 <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz> <51C1D0BB.3040705@linux.intel.com>
 <20130619170042.GH5460@e103034-lin> <51C1E58D.9000408@linux.intel.com>
 <20130621085002.GJ5460@e103034-lin> <51C47377.2000208@linux.intel.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 21 Jun 2013 22:23:25 +0100
X-Google-Sender-Auth: PoP5tbovHIjgTN95m8DnfXm-saU
Message-ID: <CAHkRjk5G7XJxzjcWa4BqRxz0AtAAh_-Eomzk4+dQRaFk1=HQqA@mail.gmail.com>
Subject: Re: power-efficient scheduling design
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, David Lang <david@lang.hm>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "pjt@google.com" <pjt@google.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 June 2013 16:38, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 6/21/2013 1:50 AM, Morten Rasmussen wrote:
>> A hint when a task is moved to a new cpu is too late if the migration
>> shouldn't have happened at all. If the scheduler knows that the cpu is
>> able to switch to a higher p-state it can decide to wait for the p-state
>> change instead of migrating the task and waking up another cpu.
>
> oops sorry I misread your mail (lack of early coffee I suppose)
>
> I can see your point of having a thing for "did we ask for all the performance
> we could ask for" prior to doing a load balance (although, for power efficiency,
> if you have two tasks that could run in parallel, it's usually better to
> run them in parallel... so likely we should balance anyway)

Not necessarily, especially if parallel running implies powering up a
full cluster just for one CPU (it depends on the hardware but for
example a cluster may not be able to go in deeper sleep states unless
all the CPUs in that cluster are idle).

--
Catalin
