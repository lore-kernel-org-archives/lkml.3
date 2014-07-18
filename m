Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbaGRMlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:41:03 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11191 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbaGRMlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:41:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX185Affh87QrfQ+x2LuO2VzaJpR7bVotymw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0613C5AF559
Date: Fri, 18 Jul 2014 08:40:38 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Patch V1 21/30] mm, irqchip: Use
 cpu_to_mem()/numa_mem_id() to support memoryless node
Message-ID: <20140718124038.GE24496@titan.lakedaemon.net>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-22-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405064267-11678-22-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:37:38PM +0800, Jiang Liu wrote:
> When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
> may return a node without memory, and later cause system failure/panic
> when calling kmalloc_node() and friends with returned node id.
> So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
> memory for the/current cpu.
> 
> If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
> is the same as cpu_to_node()/numa_node_id().
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/irqchip/irq-clps711x.c |    2 +-
>  drivers/irqchip/irq-gic.c      |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Do you have anything depending on this?  Can apply it to irqchip?  If
you need to keep it with other changes,

Acked-by: Jason Cooper <jason@lakedaemon.net>

But please do let me know if I can take it.

thx,

Jason.
