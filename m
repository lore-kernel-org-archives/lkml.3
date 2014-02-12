Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaBLQOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:14:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:19076 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaBLQOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:14:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,832,1384329600"; 
   d="scan'208";a="454271932"
Message-ID: <52FB9DEE.9020200@linux.intel.com>
Date: Wed, 12 Feb 2014 08:14:38 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com> <52EBC33A.6080101@linaro.org> <52EBC645.2040607@linux.intel.com> <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr> <20140203125441.GD19029@e103034-lin> <52EFA9D3.1030601@linux.intel.com> <20140203145605.GL8874@twins.programming.kicks-ass.net> <52EFC12B.50704@linux.intel.com> <20140212151626.GE28661@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140212151626.GE28661@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> sched_cpu_cache_wiped(int llc)
>>
>> that would be very nice for this; the menuidle side knows this
>> for some cases and thus can just call it. This would be a very
>> small and minimal change
>
> What do you mean by "menuidle side knows this for some cases" ?
> You mean you know that some C-state entries imply llc clean/invalidate ?

in the architectural idle code we can know if the llc got flushed
there's also the per core flags where we know with reasonable certainty
that the per core caches got flushed.


