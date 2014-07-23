Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaGWDVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:21:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:53340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbaGWDU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:20:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577351432"
Message-ID: <53CF29F4.7040700@linux.intel.com>
Date: Wed, 23 Jul 2014 11:20:20 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC Patch V1 15/30] mm, igb: Use cpu_to_mem()/numa_mem_id()
 to support memoryless node
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-16-git-send-email-jiang.liu@linux.intel.com> <20140721174218.GD4156@linux.vnet.ibm.com> <CAKgT0UdZdbduP-=R7uRCxJVxt1yCDoHpnercnDoyrCbWNtx=6Q@mail.gmail.com> <20140721210900.GI4156@linux.vnet.ibm.com>
In-Reply-To: <20140721210900.GI4156@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth and Alexander,
	Thanks for review, will update the comments
in next version.
Regards!
Gerry

On 2014/7/22 5:09, Nishanth Aravamudan wrote:
> On 21.07.2014 [12:53:33 -0700], Alexander Duyck wrote:
>> I do agree the description should probably be changed.  There shouldn't be
>> any panics involved, only a performance impact as it will be reallocating
>> always if it is on a node with no memory.
> 
> Yep, thanks for the review.
> 
>> My intention on this was to make certain that the memory used is from the
>> closest node possible.  As such I believe this change likely honours that.
> 
> Absolutely, just wanted to make it explicit that it's not a functional
> fix, just a performance fix (presuming this shows up at all on systems
> that have memoryless NUMA nodes).
> 
> I'd suggest an update to the comments, as well.
> 
> Thanks,
> Nish
> 
