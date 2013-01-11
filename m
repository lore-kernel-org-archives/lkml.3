Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3AKCp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:45:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:31865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab3AKCp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:45:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,447,1355126400"; 
   d="scan'208";a="275625131"
Message-ID: <50EF7D07.6080006@intel.com>
Date: Fri, 11 Jan 2013 10:46:31 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
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
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-6-git-send-email-alex.shi@intel.com> <20130109182102.GC2046@e103034-lin>
In-Reply-To: <20130109182102.GC2046@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 02:21 AM, Morten Rasmussen wrote:
>>  		new_cpu = find_idlest_cpu(group, p, cpu);
>> > -
>> > -		/* Now try balancing at a lower domain level of new_cpu */
>> > -		cpu = new_cpu;
>> > -		weight = sd->span_weight;
>> > -		sd = NULL;
>> > -		for_each_domain(cpu, tmp) {
>> > -			if (weight <= tmp->span_weight)
>> > -				break;
>> > -			if (tmp->flags & sd_flag)
>> > -				sd = tmp;
>> > -		}
>> > -		/* while loop will break here if sd == NULL */
> I agree that this should be a major optimization. I just can't figure
> out why the existing recursive search for an idle cpu switches to the
> new cpu near the end and then starts a search for an idle cpu in the new
> cpu's domain. Is this to handle some exotic sched domain configurations?
> If so, they probably wouldn't work with your optimizations.

I did not find odd configuration that asking for old logical.

According to Documentation/scheduler/sched-domains.txt, Maybe never.
"A domain's span MUST be a superset of it child's span (this restriction
could be relaxed if the need arises), and a base domain for CPU i MUST
span at least i."  etc. etc.


-- 
Thanks Alex
