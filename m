Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3ANJRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:17:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:44397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab3ANJRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:17:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,466,1355126400"; 
   d="scan'208";a="276558457"
Message-ID: <50F3CD7B.3080500@intel.com>
Date: Mon, 14 Jan 2013 17:18:51 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: li guang <lig.fnst@cn.fujitsu.com>
CC: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>  <1357375071-11793-6-git-send-email-alex.shi@intel.com>  <20130109182102.GC2046@e103034-lin> <50EF7D07.6080006@intel.com>  <20130111100757.GH2046@e103034-lin> <1358153743.8818.9.camel@liguang.fnst.cn.fujitsu.com>
In-Reply-To: <1358153743.8818.9.camel@liguang.fnst.cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 04:55 PM, li guang wrote:
>>>>>> > > >> > -		/* while loop will break here if sd == NULL */
>>>> > > > I agree that this should be a major optimization. I just can't figure
>>>> > > > out why the existing recursive search for an idle cpu switches to the
>>>> > > > new cpu near the end and then starts a search for an idle cpu in the new
>>>> > > > cpu's domain. Is this to handle some exotic sched domain configurations?
>>>> > > > If so, they probably wouldn't work with your optimizations.
>>> > > 
>>> > > I did not find odd configuration that asking for old logical.
>>> > > 
>>> > > According to Documentation/scheduler/sched-domains.txt, Maybe never.
>>> > > "A domain's span MUST be a superset of it child's span (this restriction
>>> > > could be relaxed if the need arises), and a base domain for CPU i MUST
>>> > > span at least i."  etc. etc.
>> > 
>> > The reason for my suspicion is the SD_OVERLAP flag, which has something
>> > to do overlapping sched domains. I haven't looked into what it does or
>> > how it works. I'm just wondering if this optimization will affect the
>> > use of that flag.
> seems it did, SD_OVERLAP will not work after this change,
> though this flag is maybe scarcely used.
> because, this optimization assume all sched-domains span 
> is super-set over child domain.
> isn't it? Alex.
> 

As my understanding, overlap just said some cpu may appears in 2 or more
same level sub domains. If so, this change won't miss cpus.

Am I right, Peter?

-- 
Thanks Alex
