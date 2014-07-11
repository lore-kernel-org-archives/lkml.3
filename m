Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaGKUC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:02:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:43924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbaGKUC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:02:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,644,1400050800"; 
   d="scan'208";a="542185759"
Message-ID: <53C042C6.2020507@intel.com>
Date: Fri, 11 Jul 2014 13:02:14 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <20140711082956.GC20603@laptop.programming.kicks-ass.net> <20140711153314.GA6155@kroah.com>
In-Reply-To: <20140711153314.GA6155@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 08:33 AM, Greg KH wrote:
> On Fri, Jul 11, 2014 at 10:29:56AM +0200, Peter Zijlstra wrote:
>> > On Fri, Jul 11, 2014 at 03:37:17PM +0800, Jiang Liu wrote:
>>> > > Any comments are welcomed!
>> > 
>> > Why would anybody _ever_ have a memoryless node? That's ridiculous.
> I'm with Peter here, why would this be a situation that we should even
> support?  Are there machines out there shipping like this?

This is orthogonal to the problem Jiang Liu is solving, but...

The IBM guys have been hitting the CPU-less and memoryless node issues
forever, but that's mostly because their (traditional) hypervisor had
good NUMA support and ran multi-node guests.

I've never seen it in practice on x86 mostly because the hypervisors
don't have good NUMA support. I honestly think this is something x86 is
going to have to handle eventually anyway.  It's essentially a resource
fragmentation problem, and there are going to be times where a guest
needs to be spun up and hypervisor has nodes with either no spare memory
or no spare CPUs.

The hypervisor has 3 choices in this case:
1. Lie about the NUMA layout
2. Waste the resources
3. Tell the guest how it's actually arranged


