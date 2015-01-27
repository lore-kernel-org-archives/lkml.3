Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbbA0KpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:45:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbbA0KpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:45:13 -0500
Date: Tue, 27 Jan 2015 11:45:11 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
Message-ID: <20150127104511.GB19880@dhcp22.suse.cz>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org>
 <20150114165036.GI4706@dhcp22.suse.cz>
 <54B7F7C4.2070105@codeaurora.org>
 <20150116154922.GB4650@dhcp22.suse.cz>
 <54BA7D3A.40100@codeaurora.org>
 <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
 <20150126172832.GC22681@dhcp22.suse.cz>
 <54C76995.70501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C76995.70501@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-01-15 16:03:57, Vinayak Menon wrote:
[...]
> Sure, I can retest.

Thanks!

> Even without highly overloaded workqueues, there can be a delay of HZ in
> updating the counters. This means reclaim path can be blocked for a second
> or more, when there aren't really any isolated pages. So we need the fix in
> too_many_isolated also right ?

Is this a big deal though? What you are hitting is certainly a corner
case. I assume your system is trashing heavily already with so few pages
on the file LRU list.

Anyway as mentioned in other email I would rather see vmstat data more
reliable than spread hacks to the code where we see immediate issues.

-- 
Michal Hocko
SUSE Labs
