Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab3HGMn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 08:43:27 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:40573 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3HGMnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 08:43:25 -0400
Date: Wed, 7 Aug 2013 08:43:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Message-ID: <20130807124321.GA27006@htj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <20130805160107.GM10146@dhcp22.suse.cz>
 <20130805162958.GF19631@mtj.dyndns.org>
 <20130805191641.GA24003@dhcp22.suse.cz>
 <20130805194431.GD23751@mtj.dyndns.org>
 <20130806155804.GC31138@dhcp22.suse.cz>
 <20130806161509.GB10779@mtj.dyndns.org>
 <20130807121836.GF8184@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807121836.GF8184@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Aug 07, 2013 at 02:18:36PM +0200, Michal Hocko wrote:
> How is it specific to memcg? The fact only memcg uses the interface
> doesn't imply it is memcg specific.

I don't follow.  It's only for memcg.  That is *by definition* memcg
specific.  It's the verbatim meaning of the word.  Now, I do
understand that it can be a concern the implementation details as-is
could be a bit too invasive into cgroup core to be moved to memcg, but
that's something we can work on, right?  Can you at least agree that
the feature is nmemcg specific and it'd be better to be located in
memcg if possible?  That really isn't not much to ask and is a logical
thing to do.

> There are other ways to achieve the same. E.g. not ack new usage of
> register callback users. We have done similar with other things like
> use_hierarchy...

Yes, but those are all inferior to actually moving the code where it
belongs.  Those makes the code harder to follow and people
misunderstand and waste time working on stuff (either in the core or
controllers) which eventually end up getting nacked.  Why do that when
we can easily do better?  What's the rationale behind that?

> The cleanup is removing 2 callbacks with a cost of moving non-memcg
> specific code inside memcg. That is what I am objecting to.

I don't really get your "non-memcg" specific code assertion when it is
by definition memcg-specific.  What are you talking about?

> I will not repeat myself. We seem to disagree on where the code belongs.
> As I've said I will not ack this code, try to find somebody else who
> think it is a good idea. I do not see any added value.

Nacking is part of your authority as maintainer but you should still
provide plausible rationale for that.  Are you saying that even if the
code is restructured so that it's not invasive into cgroup core, you
are still gonna disagree with it because it's still somehow not
memcg-specifc?  Please don't repeat yourself but do explain your
rationale.  That's part of your duty as a maintainer too.

Thanks.

-- 
tejun
