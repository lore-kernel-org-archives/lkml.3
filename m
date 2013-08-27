Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3H0QG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:06:29 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57818 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751745Ab3H0QG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:06:27 -0400
Date: Tue, 27 Aug 2013 11:06:25 -0500
From: Russ Anderson <rja@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v2] [BUGFIX] drivers/base: fix show_mem_removable to
	handle missing sections
Message-ID: <20130827160624.GA22918@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130823162317.GB10988@sgi.com> <20130826144959.52fd24cd2833929168ee7e35@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826144959.52fd24cd2833929168ee7e35@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 02:49:59PM -0700, Andrew Morton wrote:
> On Fri, 23 Aug 2013 11:23:17 -0500 Russ Anderson <rja@sgi.com> wrote:
> 
> > "cat /sys/devices/system/memory/memory*/removable" crashed the system.
> > 
> > The problem is that show_mem_removable() is passing a
> > bad pfn to is_mem_section_removable(), which causes
> > if (!node_online(page_to_nid(page))) to blow up.
> > Why is it passing in a bad pfn?
> > 
> > show_mem_removable() will loop sections_per_block times.
> > sections_per_block is 16, but mem->section_count is 8,
> > indicating holes in this memory block.  Checking that
> > the memory section is present before checking to see
> > if the memory section is removable fixes the problem.
> 
> The patch textually applies to 3.10, 3.9 and perhaps earlier.  Should
> it be applied to earlier kernels?

I believe so, since this does not appear to be a recent
regression, but have not verified the problem/fix in
earlier kernels.

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
