Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaAFSk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:40:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34101 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbaAFSk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:40:58 -0500
Message-ID: <52CAF8BD.90201@arm.com>
Date: Mon, 06 Jan 2014 18:41:01 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chris Redpath <Chris.Redpath@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 5/8] sched: introduce common topology level init function
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com> <1386936688-29113-6-git-send-email-dietmar.eggemann@arm.com> <20131220140451.GV16438@laptop.programming.kicks-ass.net>
In-Reply-To: <20131220140451.GV16438@laptop.programming.kicks-ass.net>
X-OriginalArrivalTime: 06 Jan 2014 18:40:55.0583 (UTC) FILETIME=[D5770AF0:01CF0B0E]
X-MC-Unique: 114010618405600201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/12/13 14:04, Peter Zijlstra wrote:
>> +/*
>> + * SD_flags allowed in topology descriptions.
>> + *
>> + * SD_SHARE_CPUPOWER      - describes SMT topologies
>> + * SD_SHARE_PKG_RESOURCES - describes shared caches
>> + * SD_NUMA                - describes NUMA topologies
>> + *
>> + * Odd one out:
>> + * SD_ASYM_PACKING        - describes SMT quirks
>> + *
>> + * SD_PREFER_SIBLING      - describes preference for sibling domain
>> + */
>> +#define TOPOLOGY_SD_FLAGS         \
>> +	(SD_SHARE_CPUPOWER |      \
>> +	 SD_SHARE_PKG_RESOURCES | \
>> +	 SD_NUMA |                \
>> +	 SD_ASYM_PACKING |        \
>> +	 SD_PREFER_SIBLING)
> 
> See SD_PREFER_SIBLING is behavioural, the exact kinda thing we want to
> keep out of this mask,

Understood.

Since this flag is only set for the CPU level, it will only effect the
first NUMA level because sd->child has to have this flag set.
Unfortunately, I don't have a NUMA system.

AFAICS, we get some level of packing in sd->parent when this flag is set.

-- Dietmar

> 


