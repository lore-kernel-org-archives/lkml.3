Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3LNAxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 19:53:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51276 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab3LNAxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 19:53:08 -0500
Message-ID: <52ABABDA.4020808@ti.com>
Date: Fri, 13 Dec 2013 19:52:42 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 08/23] mm/memblock: Add memblock memory allocation
 apis
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com> <1386625856-12942-9-git-send-email-santosh.shilimkar@ti.com> <20131213213735.GM27070@htj.dyndns.org>
In-Reply-To: <20131213213735.GM27070@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013 04:37 PM, Tejun Heo wrote:
> On Mon, Dec 09, 2013 at 04:50:41PM -0500, Santosh Shilimkar wrote:
>> Introduce memblock memory allocation APIs which allow to support
>> PAE or LPAE extension on 32 bits archs where the physical memory
>> start address can be beyond 4GB. In such cases, existing bootmem
>> APIs which operate on 32 bit addresses won't work and needs
>> memblock layer which operates on 64 bit addresses.
> 
> The overall API looks good to me.  Thanks for doing this!
> 
>> +static void * __init memblock_virt_alloc_internal(
>> +				phys_addr_t size, phys_addr_t align,
>> +				phys_addr_t min_addr, phys_addr_t max_addr,
>> +				int nid)
>> +{
>> +	phys_addr_t alloc;
>> +	void *ptr;
>> +
>> +	if (nid == MAX_NUMNODES)
>> +		pr_warn("%s: usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE\n",
>> +			__func__);
> 
> Why not use WARN_ONCE()?  Also, shouldn't nid be set to NUMA_NO_NODE
> here?
> 
You want all the users using MAX_NUMNODES to know about it so that
the wrong usage can be fixed. WARN_ONCE will hide that.

> ...
>> +	if (nid != NUMA_NO_NODE) {
> 
> Otherwise, the above test is broken.
> 
So the idea was just to warn the users and allow them to fix
the code. Well we are just allowing the existing users of using
either MAX_NUMNODES or NUMA_NO_NODE continue to work. Thats what
we discussed, right ?

