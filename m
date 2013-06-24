Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab3FXXKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:10:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:22924 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3FXXKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:10:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,931,1363158000"; 
   d="scan'208";a="321967548"
Message-ID: <51C8D1E5.60804@linux.intel.com>
Date: Mon, 24 Jun 2013 16:10:29 -0700
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
References: <20130530134718.GB32728@e103034-lin>  <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin>  <51C07ABC.2080704@linux.intel.com>  <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>  <51C1D0BB.3040705@linux.intel.com> <20130619170042.GH5460@e103034-lin>  <51C1E58D.9000408@linux.intel.com> <20130621085002.GJ5460@e103034-lin>  <51C47377.2000208@linux.intel.com>  <CAHkRjk5G7XJxzjcWa4BqRxz0AtAAh_-Eomzk4+dQRaFk1=HQqA@mail.gmail.com>  <51C4C6C8.1050008@linux.intel.com> <1372030320.3944.114.camel@pasglop>  <51C8651D.4010607@linux.intel.com> <1372111148.3944.161.camel@pasglop>
In-Reply-To: <1372111148.3944.161.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/2013 2:59 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2013-06-24 at 08:26 -0700, Arjan van de Ven wrote:
>>
>> to bring the system back up if all cores in the whole system are idle and power gated,
>> memory in SR etc... is typically < 250 usec (depends on the exact version
>> of the cpu etc). But the moment even one core is running, that core will keep the system
>> out of such deep state, and waking up a consecutive entity is much faster
>>
>> to bring just a core out of power gating is more in the 40 to 50 usec range
>
> Out of curiosity, what happens to PCIe when you bring a package down
> like this ?

PCIe devices can communicate latency requirements (LTR) if they need something
more aggressive than this; otherwise 250 usec afaik falls within what doesn't
break (devices need to cope with arbitrage/etc delays anyway)
and with PCIe link power management there are delays regardless; once a PCIe link gets powered
back on the memory controller/etc also will come back online


