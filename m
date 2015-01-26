Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbbAZRqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:46:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbbAZRqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:46:10 -0500
Date: Mon, 26 Jan 2015 18:46:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Christoph Lameter <cl@linux.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
Message-ID: <20150126174606.GD22681@dhcp22.suse.cz>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org>
 <20150114165036.GI4706@dhcp22.suse.cz>
 <54B7F7C4.2070105@codeaurora.org>
 <20150116154922.GB4650@dhcp22.suse.cz>
 <54BA7D3A.40100@codeaurora.org>
 <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
 <54BC879C.90505@codeaurora.org>
 <20150121143920.GD23700@dhcp22.suse.cz>
 <alpine.DEB.2.11.1501221010510.3937@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501221010510.3937@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-01-15 10:11:31, Christoph Lameter wrote:
> On Wed, 21 Jan 2015, Michal Hocko wrote:
> 
> > I think we can solve this as well. We can stick vmstat_shepherd into a
> > kernel thread with a loop with the configured timeout and then create a
> > mask of CPUs which need the update and run vmstat_update from
> > IPI context (smp_call_function_many).
> 
> Please do not run the vmstat_updates concurrently. They update shared
> cachelines and therefore can cause bouncing cachelines if run concurrently
> on multiple cpus.

Would you preffer to call smp_call_function_single on each CPU
which needs an update? That would make vmstat_shepherd slower but that
is not a big deal, is it?

Anyway I am wondering whether the cache line bouncing between
vmstat_update instances is a big deal in the real life. Updating shared
counters whould bounce with many CPUs but this is an operation which is
not done often. Also all the CPUs would have update the same counters
all the time and I am not sure this happens that often. Do you have a
load where this would be measurable?
-- 
Michal Hocko
SUSE Labs
