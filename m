Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbaGWDsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:48:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:20493 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237AbaGWDsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:48:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577360504"
Message-ID: <53CF306B.9080103@linux.intel.com>
Date: Wed, 23 Jul 2014 11:47:55 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Patch V1 21/30] mm, irqchip: Use cpu_to_mem()/numa_mem_id()
 to support memoryless node
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-22-git-send-email-jiang.liu@linux.intel.com> <20140718124038.GE24496@titan.lakedaemon.net>
In-Reply-To: <20140718124038.GE24496@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,
	Thanks for your review. According to review comments,
we need to rework the patch set in another direction and will
give up this patch.
Regards!
Gerry

On 2014/7/18 20:40, Jason Cooper wrote:
> On Fri, Jul 11, 2014 at 03:37:38PM +0800, Jiang Liu wrote:
>> When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
>> may return a node without memory, and later cause system failure/panic
>> when calling kmalloc_node() and friends with returned node id.
>> So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
>> memory for the/current cpu.
>>
>> If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
>> is the same as cpu_to_node()/numa_node_id().
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/irqchip/irq-clps711x.c |    2 +-
>>  drivers/irqchip/irq-gic.c      |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Do you have anything depending on this?  Can apply it to irqchip?  If
> you need to keep it with other changes,
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> 
> But please do let me know if I can take it.
> 
> thx,
> 
> Jason.
> 
