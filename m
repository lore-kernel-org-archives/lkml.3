Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaAQJRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:17:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:17:10 -0500
Date: Fri, 17 Jan 2014 10:17:06 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 -mm] mm, oom: prefer thread group leaders for display
 purposes
Message-ID: <20140117091706.GA5356@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
 <20140116070549.GL6963@cmpxchg.org>
 <alpine.DEB.2.02.1401152344560.14407@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1401152345330.14407@chino.kir.corp.google.com>
 <20140116142141.GF28157@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401161447510.31228@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401161447510.31228@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-01-14 14:49:25, David Rientjes wrote:
> On Thu, 16 Jan 2014, Michal Hocko wrote:
> 
> > > When two threads have the same badness score, it's preferable to kill the 
> > > thread group leader so that the actual process name is printed to the 
> > > kernel log rather than the thread group name which may be shared amongst 
> > > several processes.
> > 
> > I am not sure I understand this. Is this about ->comm? If yes then why
> > couldn't the group leader do PR_SET_NAME?
> > 
> 
> Both comm and pid, we only display thread group leaders in the tasklist 
> dump of eligible processes, we want the killed message to specify from 
> which process.

OK, that makes sense now. I didn't think about dump_tasks and
consistency in the output.

> You're suggesting a thread group leader do PR_SET_NAME of all its threads 
> for readable oom killer output?  Lol.

No, I am not suggesting anything. I was just asking why is group leader
different in this regards becasue changelog didn't tell it and I didn't
put it together with dump_tasks.

Thanks!
-- 
Michal Hocko
SUSE Labs
