Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbaGURXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:23:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49963 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaGURXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:23:39 -0400
Date: Mon, 21 Jul 2014 10:23:31 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
Message-ID: <20140721172331.GB4156@linux.vnet.ibm.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
X-Operating-System: Linux 3.13.0-32-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072117-1344-0000-0000-000002F82DE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

On 11.07.2014 [15:37:17 +0800], Jiang Liu wrote:
> Previously we have posted a patch fix a memory crash issue caused by
> memoryless node on x86 platforms, please refer to
> http://comments.gmane.org/gmane.linux.kernel/1687425
> 
> As suggested by David Rientjes, the most suitable fix for the issue
> should be to use cpu_to_mem() rather than cpu_to_node() in the caller.
> So this is the patchset according to David's suggestion.

Hrm, that is initially what David said, but then later on in the thread,
he specifically says he doesn't think memoryless nodes are the problem.
It seems like the issue is the order of onlining of resources on a
specifix x86 platform?

memoryless nodes in and of themselves don't cause the kernel to crash.
powerpc boots with them (both previously without
CONFIG_HAVE_MEMORYLESS_NODES and now with it) and is functional,
although it does lead to some performance issues I'm hoping to resolve.
In fact, David specifically says that the kernel crash you triggered
makes sense as cpu_to_node() points to an offline node?

In any case, a blind s/cpu_to_node/cpu_to_mem/ is not always correct.
There is a semantic difference and in some cases the allocator already
do the right thing under covers (falls back to nearest node) and in some
cases it doesn't.

Thanks,
Nish

