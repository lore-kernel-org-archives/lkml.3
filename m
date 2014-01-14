Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaANOas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:30:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54211 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaANOao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:30:44 -0500
Message-ID: <52D548B1.8000504@ti.com>
Date: Tue, 14 Jan 2014 09:24:49 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <qiuxishi@huawei.com>, <dhowells@redhat.com>, <daeseok.youn@gmail.com>,
        <liuj97@gmail.com>, <yinghai@kernel.org>, <zhangyanfei@cn.fujitsu.com>,
        <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH V3 2/2] mm/memblock: Add support for excluded memory areas
References: <1389618217-48166-1-git-send-email-phacht@linux.vnet.ibm.com> <1389618217-48166-3-git-send-email-phacht@linux.vnet.ibm.com> <52D538FD.8010907@ti.com>
In-Reply-To: <52D538FD.8010907@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 January 2014 08:17 AM, Grygorii Strashko wrote:
> Hi Philipp,
> 
> On 01/13/2014 03:03 PM, Philipp Hachtmann wrote:
>> Add a new memory state "nomap" to memblock. This can be used to truncate
>> the usable memory in the system without forgetting about what is really
>> installed.
> 
> 
> Sorry, but this solution looks a bit complex (and probably wrong - from design point of view))
> if you need just to fix memblock_start_of_DRAM()/memblock_end_of_DRAM() APIs.
> 
> More over, other arches use at least below APIs: 
> - memblock_is_region_memory() !!!
> - for_each_memblock(memory, reg) !!!
> - __next_mem_pfn_range() !!!
> - memblock_phys_mem_size()
> - memblock_mem_size()
> - memblock_start_of_DRAM()
> - memblock_end_of_DRAM()
> with assumption that "memory" regions array have been updated
> when mem block is stolen (no-mapped), as result this change may
> have unpredictable side effects :( if these new APIs
> will be re-used (for ARM arch, as example).
> 
> You can take a look on how ARM is using arm_memblock_steal() - 
> the stolen memory is not accounted any more.
> 
I was also wondering instead of nomap state, the memblock_add/remove()
will do the same trick. arm_memblock_steal() wrapper does achieve
similar functionality of reserving the DRAM without mapping it into
the Linux. Why not just use the same idea ?

Regards,
Santosh


