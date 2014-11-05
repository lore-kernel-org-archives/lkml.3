Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaKENm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:42:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaKENmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:42:21 -0500
Date: Wed, 5 Nov 2014 14:42:19 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141105134219.GD4527@dhcp22.suse.cz>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
 <2156351.pWp6MNRoWm@vostro.rjw.lan>
 <20141021141159.GE9415@dhcp22.suse.cz>
 <4766859.KSKPTm3b0x@vostro.rjw.lan>
 <20141021142939.GG9415@dhcp22.suse.cz>
 <20141104192705.GA22163@htj.dyndns.org>
 <20141105124620.GB4527@dhcp22.suse.cz>
 <20141105130247.GA14386@htj.dyndns.org>
 <20141105133100.GC4527@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105133100.GC4527@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-11-14 14:31:00, Michal Hocko wrote:
> On Wed 05-11-14 08:02:47, Tejun Heo wrote:
[...]
> > Also, why isn't this part of
> > oom_killer_disable/enable()?  The way they're implemented is really
> > silly now.  It just sets a flag and returns whether there's a
> > currently running instance or not.  How were these even useful? 
> > Why can't you just make disable/enable to what they were supposed to
> > do from the beginning?
> 
> Because then we would block all the potential allocators coming from
> workqueues or kernel threads which are not frozen yet rather than fail
> the allocation.

After thinking about this more it would be doable by using trylock in
the allocation oom path. I will respin the patch. The API will be
cleaner this way.

-- 
Michal Hocko
SUSE Labs
