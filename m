Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaGUVJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:09:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59636 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbaGUVJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:09:08 -0400
Date: Mon, 21 Jul 2014 14:09:00 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
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
Subject: Re: [RFC Patch V1 15/30] mm, igb: Use cpu_to_mem()/numa_mem_id() to
 support memoryless node
Message-ID: <20140721210900.GI4156@linux.vnet.ibm.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-16-git-send-email-jiang.liu@linux.intel.com>
 <20140721174218.GD4156@linux.vnet.ibm.com>
 <CAKgT0UdZdbduP-=R7uRCxJVxt1yCDoHpnercnDoyrCbWNtx=6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UdZdbduP-=R7uRCxJVxt1yCDoHpnercnDoyrCbWNtx=6Q@mail.gmail.com>
X-Operating-System: Linux 3.13.0-32-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072121-0320-0000-0000-0000000B1365
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.07.2014 [12:53:33 -0700], Alexander Duyck wrote:
> I do agree the description should probably be changed.  There shouldn't be
> any panics involved, only a performance impact as it will be reallocating
> always if it is on a node with no memory.

Yep, thanks for the review.

> My intention on this was to make certain that the memory used is from the
> closest node possible.  As such I believe this change likely honours that.

Absolutely, just wanted to make it explicit that it's not a functional
fix, just a performance fix (presuming this shows up at all on systems
that have memoryless NUMA nodes).

I'd suggest an update to the comments, as well.

Thanks,
Nish

