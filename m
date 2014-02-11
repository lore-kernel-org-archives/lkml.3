Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaBKSsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:48:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60263 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaBKSst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:48:49 -0500
Date: Tue, 11 Feb 2014 13:48:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] memcg: update comment about charge reparenting on
 cgroup exit
Message-ID: <20140211184843.GL6963@cmpxchg.org>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
 <1391792665-21678-4-git-send-email-hannes@cmpxchg.org>
 <20140210142344.GI7117@dhcp22.suse.cz>
 <alpine.LSU.2.11.1402101208290.1516@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402101208290.1516@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:12:42PM -0800, Hugh Dickins wrote:
> On Mon, 10 Feb 2014, Michal Hocko wrote:
> > On Fri 07-02-14 12:04:20, Johannes Weiner wrote:
> > > Reparenting memory charges in the css_free() callback was meant as a
> > > temporary fix for charges that race with offlining, but after some
> > > follow-up discussion, it turns out that this is really the right place
> > > to reparent charges because it guarantees none are in-flight.
> 
> Perhaps: I'm not as gung-ho for this new orthodoxy as you are.
>
> > > Make clear that the reparenting in css_offline() is an optimistic
> > > sweep of established charges because swapout records might hold up
> > > css_free() indefinitely, but that in fact the css_free() reparenting
> > > is the properly synchronized one.
> 
> It worries me that you keep referring to the memsw usage, but
> forget the kmem usage, which also delays css_free() indefinitely.
>
> Or am I out-of-date?  Seems not, mem_cgroup_reparent_chages() still
> waits for memcg->res - memcg->kmem to reach 0, knowing there's not
> much certainty that kmem will reach 0 any time soon.
>
> I think you need a plan for what to do with the kmem pinning,
> before going much further in reworking the memsw pinning.
> 
> Or at the least, please mention it in this patch's comment.

It think the discussion from the other thread bled over into this one
a little bit, this patch was merely about clarifying that .css_free()
reparenting is not the crude hack it was described as.

Yes, I forgot about kmem and it should be mentioned in this patch.
