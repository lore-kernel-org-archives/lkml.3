Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbbALL2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:28:50 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:46397 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbALL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:28:49 -0500
Date: Mon, 12 Jan 2015 06:28:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH cgroup/for-3.19-fixes] cgroup: implement
 cgroup_subsys->unbind() callback
Message-ID: <20150112112845.GS25319@htj.dyndns.org>
References: <54B01335.4060901@arm.com>
 <20150110085525.GD2110@esperanza>
 <20150110214316.GF25319@htj.dyndns.org>
 <20150111205543.GA5480@phnom.home.cmpxchg.org>
 <20150112080114.GE2110@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112080114.GE2110@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vladimir.

On Mon, Jan 12, 2015 at 11:01:14AM +0300, Vladimir Davydov wrote:
> Come to think of it, I wonder how many users actually want to mount
> different controllers subset after unmount. Because we could allow

It wouldn't be a common use case but, on the face of it, we still
support it.  If we collecctively decide that once a sub cgroup is
created for any controller no further hierarchy configuration for that
controller is allowed, that'd work too, but one way or the other, the
behavior, I believe, should be well-defined.  As it currently stands,
the conditions and failure mode are opaque to userland, which is never
a good thing.

> mounting the same subset perfectly well, even if it includes memcg. BTW,
> AFAIU in the unified hierarchy we won't have this problem at all,
> because by definition it mounts all controllers IIRC, so do we need to
> bother fixing this in such a complicated manner at all for the setup
> that's going to be deprecated anyway?

There will likely be a quite long transition period and if and when
the old things can be removed, this added cleanup logic can go away
with it.  It depends on how complex the implementation would get but
as long as it isn't too much and stays mostly isolated from the saner
paths, I think it's probably the right thing to do.

Thanks.

-- 
tejun
