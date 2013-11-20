Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3KTQY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:24:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:30385 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab3KTQY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:24:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438612621"
Message-ID: <528CE24F.5000604@linux.intel.com>
Date: Wed, 20 Nov 2013 08:24:47 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com,
        rui.zhang@intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        hpa@zytor.com
Subject: Re: [PATCH] x86, acpi, idle: Restructure the mwait idle routines
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net> <20131119090859.GC3694@twins.programming.kicks-ass.net> <20131119113153.GD3694@twins.programming.kicks-ass.net> <528B7433.7020507@linux.intel.com> <20131119145143.GK10022@twins.programming.kicks-ass.net> <20131119151338.GF3694@twins.programming.kicks-ass.net> <20131119130630.487da962@ultegra> <20131120102803.GO10022@twins.programming.kicks-ass.net> <20131120105837.GH3694@twins.programming.kicks-ass.net>
In-Reply-To: <20131120105837.GH3694@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 2:58 AM, Peter Zijlstra wrote:
> On Wed, Nov 20, 2013 at 11:28:03AM +0100, Peter Zijlstra wrote:
>> On Tue, Nov 19, 2013 at 01:06:30PM -0800, Jacob Pan wrote:
>>> I applied this patch on top of upstream kernel (801a760) and found out
>>> my machine completely failed to enter idle when nothing is running.
>>> turbostate shows 100% C0. ftrace shows kernel coming in and out of idle
>>> frequently.
>>>
>>> Both ACPI idle and intel_idle behaves the same way. I have to do the
>>> following change to allow entering C-states again.
>
>> That doesn't make any sense; current_set_polling_and_test() returns the
>> same thing need_resched() does.
>>
>> But you're right, intel_idle resides 100% in C0 and acpi_idle has 100%
>> C1 residency... most weird.
>
> So pretty silly actually; you cannot do a store (any store) in between
> monitor and mwait.

you can
just not to the cacheline you are watching (or things that alias with that)

