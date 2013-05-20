Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab3ETV4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:56:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:41192 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab3ETV4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:56:21 -0400
Date: Mon, 20 May 2013 16:55:42 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [RFCv2][PATCH 0/5] mm: Batch page reclamation under
 shink_page_list
Message-ID: <20130520215542.GC25536@cerebellum>
References: <20130516203427.E3386936@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516203427.E3386936@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052021-7408-0000-0000-00001066408E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 01:34:27PM -0700, Dave Hansen wrote:
> These are an update of Tim Chen's earlier work:
> 
> 	http://lkml.kernel.org/r/1347293960.9977.70.camel@schen9-DESK
> 
> I broke the patches up a bit more, and tried to incorporate some
> changes based on some feedback from Mel and Andrew.
> 
> Changes for v2:
>  * use page_mapping() accessor instead of direct access
>    to page->mapping (could cause crashes when running in
>    to swap cache pages.
>  * group the batch function's introduction patch with
>    its first use
>  * rename a few functions as suggested by Mel
>  * Ran some single-threaded tests to look for regressions
>    caused by the batching.  If there is overhead, it is only
>    in the worst-case scenarios, and then only in hundreths of
>    a percent of CPU time.
> 
> If you're curious how effective the batching is, I have a quick
> and dirty patch to keep some stats:
> 
> 	https://www.sr71.net/~dave/intel/rmb-stats-only.patch
>

Didn't do any performance comparison but did a kernel build with 2 make threads
per core in a memory constrained situation w/ zswap add got an average batch
size of 6.6 pages with the batch being empty on ~10% of calls.

rmb call:   423464
rmb pages:   2790332
rmb empty:   41408

The WARN_ONCE only gave me one stack for the first empty batch and, for what
it's worth, it was from kswapd.

Tested-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

