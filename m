Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3FXP00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:26:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:48068 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab3FXP0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:26:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,929,1363158000"; 
   d="scan'208";a="354913176"
Message-ID: <51C8651D.4010607@linux.intel.com>
Date: Mon, 24 Jun 2013 08:26:21 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        David Lang <david@lang.hm>,
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
References: <20130530134718.GB32728@e103034-lin>  <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin>  <51C07ABC.2080704@linux.intel.com>  <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>  <51C1D0BB.3040705@linux.intel.com> <20130619170042.GH5460@e103034-lin>  <51C1E58D.9000408@linux.intel.com> <20130621085002.GJ5460@e103034-lin>  <51C47377.2000208@linux.intel.com>  <CAHkRjk5G7XJxzjcWa4BqRxz0AtAAh_-Eomzk4+dQRaFk1=HQqA@mail.gmail.com>  <51C4C6C8.1050008@linux.intel.com> <1372030320.3944.114.camel@pasglop>
In-Reply-To: <1372030320.3944.114.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I guess it depends on the system
>
> Sort-of. We have something similar with threads on ppc. IE, the core can
> only really stop if all threads are. From a Linux persepctive it's a
> matter of how we define the scope of that 'cluster' Catalin is talking
> about. I'm sure you do too.
>
> Then there is the package, which adds MC etc...
>
>> the very first cpu needs to power on
>> * the core itself
>> * the "cluster" that you mention
>> * the memory controller
>> * the memory (out of self refresh)
>>
>> while the second cpu needs
>> * the core itself
>> * maybe a second cluster
>>
>> normally on Intel systems, the memory power delta is quite significant
>> which then means the efficiency of the second core is huge compared to
>> running things in sequence.
>
> What's your typical latency for bringing an MC back (and memory out of
> self refresh) ? IE. Basically bringing a package back up ?

to bring the system back up if all cores in the whole system are idle and power gated,
memory in SR etc... is typically < 250 usec (depends on the exact version
of the cpu etc). But the moment even one core is running, that core will keep the system
out of such deep state, and waking up a consecutive entity is much faster

to bring just a core out of power gating is more in the 40 to 50 usec range

