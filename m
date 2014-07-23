Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaGWDRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:17:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:60737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbaGWDRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:17:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577350165"
Message-ID: <53CF2925.3030803@linux.intel.com>
Date: Wed, 23 Jul 2014 11:16:53 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>, Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jianyu Zhan <nasa4836@gmail.com>, malc <av1474@comtv.ru>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Fabian Frederick <fabf@skynet.be>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 07/30] mm: Use cpu_to_mem()/numa_mem_id() to support
 memoryless node
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-8-git-send-email-jiang.liu@linux.intel.com> <20140711144205.GA27706@htj.dyndns.org> <alpine.DEB.2.11.1407111012210.25527@gentwo.org> <20140711152156.GB29137@htj.dyndns.org> <alpine.DEB.2.11.1407111056060.27349@gentwo.org> <20140711160152.GC30865@htj.dyndns.org> <alpine.DEB.2.11.1407111117560.27592@gentwo.org> <20140711162451.GD30865@htj.dyndns.org> <alpine.DEB.2.11.1407111220410.4511@gentwo.org> <20140711182814.GE30865@htj.dyndns.org> <alpine.DEB.2.11.1407111405280.5070@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1407111405280.5070@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun and Christoph,
	Thanks for your suggestions and discussion. Tejun really
gives a good point to hide memoryless node interface from normal
slab users. I will rework the patch set to go that direction.
Regards!
Gerry

On 2014/7/12 3:11, Christoph Lameter wrote:
> On Fri, 11 Jul 2014, Tejun Heo wrote:
> 
>> On Fri, Jul 11, 2014 at 12:29:30PM -0500, Christoph Lameter wrote:
>>> GFP_THISNODE is mostly used by allocators that need memory from specific
>>> nodes. The use of numa_mem_id() there is useful because one will not
>>> get any memory at all when attempting to allocate from a memoryless
>>> node using GFP_THISNODE.
>>
>> As long as it's in allocator proper, it doesn't matter all that much
>> but the changes are clearly not contained, are they?
> 
> Well there is a proliferation of memory allocators recently. NUMA is often
> a second thought in those.
> 
