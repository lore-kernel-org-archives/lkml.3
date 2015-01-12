Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbbALNFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:05:37 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46877 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbALNFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:05:09 -0500
Date: Mon, 12 Jan 2015 08:05:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH cgroup/for-3.19-fixes] cgroup: implement
 cgroup_subsys->unbind() callback
Message-ID: <20150112130502.GV25319@htj.dyndns.org>
References: <54B01335.4060901@arm.com>
 <20150110085525.GD2110@esperanza>
 <20150110214316.GF25319@htj.dyndns.org>
 <20150111205543.GA5480@phnom.home.cmpxchg.org>
 <20150112080114.GE2110@esperanza>
 <20150112112845.GS25319@htj.dyndns.org>
 <20150112125956.GF2110@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112125956.GF2110@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:59:56PM +0300, Vladimir Davydov wrote:
> I haven't dug deep into the cgroup core, but may be we could detach the
> old root in cgroup_kill_sb() and leave it dangling until the last
> reference to it has gone?

The root isn't the problem here.  Individual controllers are as
there's only one copy of each and we most likely don't want to carry
over child csses from one hierarchy to the next as the controller may
operate under a different set of rules.

> BTW, IIRC the problem always existed for kmem-active memory cgroups,
> because we never had kmem reparenting. May be, we could therefore just
> document somewhere that kmem accounting is highly discouraged to be used
> in the legacy hierarchy and merge these two patches as is to handle page
> cache and swap charges? We won't break anything, because it was always
> broken :-)

If we're going that route, I think it'd be better to declare hierarchy
lifetime rules as essentially opaque to userland and destroy
hierarchies only when all its children, dead or alive, are gone.

Thanks.

-- 
tejun
