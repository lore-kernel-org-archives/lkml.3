Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaHENMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:12:35 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58354 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbaHENMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:12:34 -0400
Date: Tue, 5 Aug 2014 09:12:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: avoid charge statistics churn during
 page migration
Message-ID: <20140805131223.GA14734@cmpxchg.org>
References: <1407184469-20741-1-git-send-email-hannes@cmpxchg.org>
 <20140805122434.GD15908@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805122434.GD15908@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 02:24:34PM +0200, Michal Hocko wrote:
> On Mon 04-08-14 16:34:29, Johannes Weiner wrote:
> > Charge migration currently disables IRQs twice to update the charge
> > statistics for the old page and then again for the new page.
> > 
> > But migration is a seemless transition of a charge from one physical
> > page to another one of the same size, so this should be a non-event
> > from an accounting point of view.  Leave the statistics alone.
> 
> Moving stats to mem_cgroup_commit_charge sounds logical to me but does
> this work properly even for the fuse replace page cache case when old
> and new pages can already live in different memcgs?

We don't migrate if the new page is already charged.
