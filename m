Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3LKJzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:55:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3LKJzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:55:51 -0500
Date: Wed, 11 Dec 2013 10:55:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Message-ID: <20131211095549.GA18741@dhcp22.suse.cz>
References: <20131202200221.GC5524@dhcp22.suse.cz>
 <20131202212500.GN22729@cmpxchg.org>
 <20131203120454.GA12758@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com>
 <20131204111318.GE8410@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312041606260.6329@chino.kir.corp.google.com>
 <20131209124840.GC3597@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com>
 <20131210103827.GB20242@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-12-13 17:03:45, David Rientjes wrote:
> On Tue, 10 Dec 2013, Michal Hocko wrote:
> 
> > > What exactly would you like to see?
> > 
> > How often do you see PF_EXITING tasks which haven't been killed causing
> > a pointless notification? Because fatal_signal_pending and TIF_MEMDIE
> > cases are already handled because we bypass charges in those cases (except
> > for user OOM killer killed tasks which don't get TIF_MEMDIE and that
> > should be fixed).
> > 
> 
> Triggering a pointless notification with PF_EXITING is rare, yet one 
> pointless notification can be avoided with the patch. 

Sigh. Yes it will avoid one particular and rare race. There will still
be notifications without oom kills.

Anyway.
Does the reclaim make any sense for PF_EXITING tasks? Shouldn't we
simply bypass charges of these tasks automatically. Those tasks will
free some memory anyway so why to trigger reclaim and potentially OOM
in the first place? Do we need to go via TIF_MEMDIE loop in the first
place?

> Additionally, it also avoids a pointless notification for a racing
> SIGKILL.

-- 
Michal Hocko
SUSE Labs
