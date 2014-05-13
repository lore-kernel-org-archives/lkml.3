Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbaEMPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:09:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbaEMPJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:09:56 -0400
Date: Tue, 13 May 2014 17:09:53 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Message-ID: <20140513150953.GC25996@dhcp22.suse.cz>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
 <20140512145803.GF9564@dhcp22.suse.cz>
 <20140512150014.GB1421@htj.dyndns.org>
 <20140512152015.GH9564@dhcp22.suse.cz>
 <20140512152507.GD1421@htj.dyndns.org>
 <20140512153458.GJ9564@dhcp22.suse.cz>
 <20140513131655.GC18849@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513131655.GC18849@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-05-14 09:16:56, Johannes Weiner wrote:
> On Mon, May 12, 2014 at 05:34:58PM +0200, Michal Hocko wrote:
[...]
> > >From 6f2a33df7750f0794b03f7a85aba02a4e631f2a0 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Mon, 12 May 2014 16:20:46 +0200
> > Subject: [PATCH] memcg: deprecate memory.force_empty knob
> > 
> > force_empty has been introduced primarily to drop memory before it gets
> > reparented on the group removal. This alone doesn't sound fully
> > justified because reparented pages which are not in use can be reclaimed
> > also later when there is a memory pressure on the parent level.
> > 
> > Mark the knob CFTYPE_INSANE which tells the cgroup core that it
> > shouldn't create the knob with the experimental sane_behavior. Other
> > users will get informed about the deprecation and asked to tell us more.
> > But I expect that most users will be simply cgroup remove handlers
> > which do that since ever without having any good reason for it.
> > 
> > If somebody really cares and the reparented pages, which would be dropped
> > otherwise, push out more important ones then we should fix the
> > reparenting code and put pages to the tail.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> 
> I'm skeptical the printk will do anything useful, but you marked the
> knob insane and that's the most important change.

Well, I suspect that most users will try the new semantic at the latest
possible moment and then it can come up as a surprise. I would prefer to
catch those as soon as possible. I am even thinking to push this to SLES
to catch possible enterprise users.

> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks. OK, I will post it to Andrew. I guess he will want to have some
rate-limiting or print-once semantic...
-- 
Michal Hocko
SUSE Labs
