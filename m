Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3LNApD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 19:45:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57554 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3LNApB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 19:45:01 -0500
Message-ID: <52ABA9EC.5070100@ti.com>
Date: Fri, 13 Dec 2013 19:44:28 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 07/23] mm/memblock: switch to use NUMA_NO_NODE instead
 of MAX_NUMNODES
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com> <1386625856-12942-8-git-send-email-santosh.shilimkar@ti.com> <20131213212912.GL27070@htj.dyndns.org>
In-Reply-To: <20131213212912.GL27070@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013 04:29 PM, Tejun Heo wrote:
> On Mon, Dec 09, 2013 at 04:50:40PM -0500, Santosh Shilimkar wrote:
>> +	if (nid == MAX_NUMNODES)
>> +		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
>> +			     __func__);
> 
> Why not just use WARN_ONCE()?  We'd want to know who the caller is
> anyway.  Also, wouldn't something like the following simpler?
> 
> 	if (WARN_ONCE(nid == MAX_NUMNODES, blah blah))
> 		nid = NUMA_NO_NODE;
> 
Agree.

>> @@ -768,6 +773,11 @@ void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
>>  	struct memblock_type *rsv = &memblock.reserved;
>>  	int mi = *idx & 0xffffffff;
>>  	int ri = *idx >> 32;
>> +	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
>> +
>> +	if (nid == MAX_NUMNODES)
>> +		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
>> +			     __func__);
> 
> Ditto.
>
OK.

> 
> Reviwed-by: Tejun Heo <tj@kernel.org>
> 
Thanks

