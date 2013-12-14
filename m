Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3LNTsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:48:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47815 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab3LNTsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:48:51 -0500
Message-ID: <52ACB608.3050802@ti.com>
Date: Sat, 14 Dec 2013 14:48:24 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 08/23] mm/memblock: Add memblock memory allocation
 apis
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com> <1386625856-12942-9-git-send-email-santosh.shilimkar@ti.com> <20131213213735.GM27070@htj.dyndns.org> <52ABABDA.4020808@ti.com> <20131214110844.GB17954@htj.dyndns.org>
In-Reply-To: <20131214110844.GB17954@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 December 2013 06:08 AM, Tejun Heo wrote:
> Hello, Santosh.
> 
> On Fri, Dec 13, 2013 at 07:52:42PM -0500, Santosh Shilimkar wrote:
>>>> +static void * __init memblock_virt_alloc_internal(
>>>> +				phys_addr_t size, phys_addr_t align,
>>>> +				phys_addr_t min_addr, phys_addr_t max_addr,
>>>> +				int nid)
>>>> +{
>>>> +	phys_addr_t alloc;
>>>> +	void *ptr;
>>>> +
>>>> +	if (nid == MAX_NUMNODES)
>>>> +		pr_warn("%s: usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE\n",
>>>> +			__func__);
>>>
>>> Why not use WARN_ONCE()?  Also, shouldn't nid be set to NUMA_NO_NODE
>>> here?
>>>
>> You want all the users using MAX_NUMNODES to know about it so that
>> the wrong usage can be fixed. WARN_ONCE will hide that.
> 
> Well, it doesn't really help anyone to be printing multiple messages
> without any info on who was the caller and if this thing is gonna be
> in mainline triggering of the warning should be rare anyway.  It's
> more of a tool to gather one-off cases in the wild.  WARN_ONCE()
> usually is the better choice as otherwise the warnings can swamp the
> machine and console output in certain cases.
>
Fair enough.
 
>>> ...
>>>> +	if (nid != NUMA_NO_NODE) {
>>>
>>> Otherwise, the above test is broken.
>>>
>> So the idea was just to warn the users and allow them to fix
>> the code. Well we are just allowing the existing users of using
>> either MAX_NUMNODES or NUMA_NO_NODE continue to work. Thats what
>> we discussed, right ?
> 
> Huh?  Yeah, sure.  You're testing @nid against MAX_NUMNODES at the
> beginning of the function.  If it's MAX_NUMNODES, you print a warning
> but nothing else, so the if() conditional above, which should succeed,
> would fail.  Am I missing sth here?
> 
I get it now. Sorry I missed your point in first part. We will fix this.

Regards,
Santosh

