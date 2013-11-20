Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3KTQi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:38:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:22714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab3KTQix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:38:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438620390"
Message-ID: <528CE59C.1040600@linux.intel.com>
Date: Wed, 20 Nov 2013 08:38:52 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com,
        rui.zhang@intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        hpa@zytor.com
Subject: Re: [PATCH] x86, acpi, idle: Restructure the mwait idle routines
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net> <20131119090859.GC3694@twins.programming.kicks-ass.net> <20131119113153.GD3694@twins.programming.kicks-ass.net> <528B7433.7020507@linux.intel.com> <20131119145143.GK10022@twins.programming.kicks-ass.net> <20131119151338.GF3694@twins.programming.kicks-ass.net> <20131119130630.487da962@ultegra> <20131120102803.GO10022@twins.programming.kicks-ass.net> <20131120105837.GH3694@twins.programming.kicks-ass.net> <528CE24F.5000604@linux.intel.com> <20131120163313.GR10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131120163313.GR10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 8:33 AM, Peter Zijlstra wrote:
> On Wed, Nov 20, 2013 at 08:24:47AM -0800, Arjan van de Ven wrote:
>> On 11/20/2013 2:58 AM, Peter Zijlstra wrote:
>>> So pretty silly actually; you cannot do a store (any store) in between
>>> monitor and mwait.
>>
>> you can
>> just not to the cacheline you are watching (or things that alias with that)
>
> Ah indeed, the thread_info::status is in the same cacheline.
>

you told it to wake on any write to that cacheline
and then you write to it ;-)

