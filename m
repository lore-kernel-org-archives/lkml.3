Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539Ab3GZSrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:47:08 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51062 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759367Ab3GZSrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:47:05 -0400
Date: Fri, 26 Jul 2013 14:46:57 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] x86: finish user fault error path with fatal signal
Message-ID: <20130726184657.GR715@cmpxchg.org>
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org>
 <1374791138-15665-5-git-send-email-hannes@cmpxchg.org>
 <20130726135207.GF17761@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726135207.GF17761@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 03:52:07PM +0200, Michal Hocko wrote:
> On Thu 25-07-13 18:25:36, Johannes Weiner wrote:
> > The x86 fault handler bails in the middle of error handling when the
> > task has a fatal signal pending.  For a subsequent patch this is a
> > problem in OOM situations because it relies on
> > pagefault_out_of_memory() being called even when the task has been
> > killed, to perform proper per-task OOM state unwinding.
> > 
> > Shortcutting the fault like this is a rather minor optimization that
> > saves a few instructions in rare cases.  Just remove it for
> > user-triggered faults.
> 
> OK, I thought that this optimization tries to prevent calling OOM
> because the current might release some memory but that wasn't the
> intention of b80ef10e8 (x86: Move do_page_fault()'s error path under
> unlikely()).

out_of_memory() also checks the caller for pending signals, so it
would not actually invoke the OOM killer if the caller is already
dying.

> > Use the opportunity to split the fault retry handling from actual
> > fault errors and add locking documentation that reads suprisingly
> > similar to ARM's.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!
