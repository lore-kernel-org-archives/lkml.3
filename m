Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946127Ab3FUVeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:34:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:27622 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945979Ab3FUVeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:34:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,915,1363158000"; 
   d="scan'208";a="333565432"
Message-ID: <51C4C6C8.1050008@linux.intel.com>
Date: Fri, 21 Jun 2013 14:34:00 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, David Lang <david@lang.hm>,
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
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin> <51C07ABC.2080704@linux.intel.com> <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz> <51C1D0BB.3040705@linux.intel.com> <20130619170042.GH5460@e103034-lin> <51C1E58D.9000408@linux.intel.com> <20130621085002.GJ5460@e103034-lin> <51C47377.2000208@linux.intel.com> <CAHkRjk5G7XJxzjcWa4BqRxz0AtAAh_-Eomzk4+dQRaFk1=HQqA@mail.gmail.com>
In-Reply-To: <CAHkRjk5G7XJxzjcWa4BqRxz0AtAAh_-Eomzk4+dQRaFk1=HQqA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/2013 2:23 PM, Catalin Marinas wrote:
>>
>> oops sorry I misread your mail (lack of early coffee I suppose)
>>
>> I can see your point of having a thing for "did we ask for all the performance
>> we could ask for" prior to doing a load balance (although, for power efficiency,
>> if you have two tasks that could run in parallel, it's usually better to
>> run them in parallel... so likely we should balance anyway)
>
> Not necessarily, especially if parallel running implies powering up a
> full cluster just for one CPU (it depends on the hardware but for
> example a cluster may not be able to go in deeper sleep states unless
> all the CPUs in that cluster are idle).

I guess it depends on the system

the very first cpu needs to power on
* the core itself
* the "cluster" that you mention
* the memory controller
* the memory (out of self refresh)

while the second cpu needs
* the core itself
* maybe a second cluster

normally on Intel systems, the memory power delta is quite significant
which then means the efficiency of the second core is huge compared to
running things in sequence.
