Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915AbaGXXco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:32:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39986 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934568AbaGXXcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:32:42 -0400
Date: Thu, 24 Jul 2014 16:32:30 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-hotplug@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
Message-ID: <20140724233230.GD24458@linux.vnet.ibm.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <20140721172331.GB4156@linux.vnet.ibm.com>
 <CA+8MBbK+ZdisT_yXh_jkWSd4hWEMisG614s4s0EyNV3j-7YOow@mail.gmail.com>
 <20140721175736.GG4156@linux.vnet.ibm.com>
 <53CF7048.20302@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF7048.20302@linux.intel.com>
X-Operating-System: Linux 3.13.0-32-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072423-0320-0000-0000-00000013476B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2014 [16:20:24 +0800], Jiang Liu wrote:
> 
> 
> On 2014/7/22 1:57, Nishanth Aravamudan wrote:
> > On 21.07.2014 [10:41:59 -0700], Tony Luck wrote:
> >> On Mon, Jul 21, 2014 at 10:23 AM, Nishanth Aravamudan
> >> <nacc@linux.vnet.ibm.com> wrote:
> >>> It seems like the issue is the order of onlining of resources on a
> >>> specific x86 platform?
> >>
> >> Yes. When we online a node the BIOS hits us with some ACPI hotplug events:
> >>
> >> First: Here are some new cpus
> > 
> > Ok, so during this period, you might get some remote allocations. Do you
> > know the topology of these CPUs? That is they belong to a
> > (soon-to-exist) NUMA node? Can you online that currently offline NUMA
> > node at this point (so that NODE_DATA()) resolves, etc.)?
> Hi Nishanth,
> 	We have method to get the NUMA information about the CPU, and
> patch "[RFC Patch V1 30/30] x86, NUMA: Online node earlier when doing
> CPU hot-addition" tries to solve this issue by onlining NUMA node
> as early as possible. Actually we are trying to enable memoryless node
> as you have suggested.

Ok, it seems like you have two sets of patches then? One is to fix the
NUMA information timing (30/30 only). The rest of the patches are
general discussions about where cpu_to_mem() might be used instead of
cpu_to_node(). However, based upon Tejun's feedback, it seems like
rather than force all callers to use cpu_to_mem(), we should be looking
at the core VM to ensure fallback is occuring appropriately when
memoryless nodes are present. 

Do you have a specific situation, once you've applied 30/30, where
kmalloc_node() leads to an Oops?

Thanks,
Nish

