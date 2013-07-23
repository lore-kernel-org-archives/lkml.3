Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab3GWTEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:04:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab3GWTEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:04:35 -0400
Date: Tue, 23 Jul 2013 14:04:26 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
Message-ID: <20130723190426.GA9577@tp>
References: <20130723181606.GA6342@sergelap>
 <20130723183018.GF21100@mtj.dyndns.org>
 <20130723183841.GA9021@tp>
 <CAOS58YPynQ-QBx5nZEnYrP5kGTVvv9VAj0cV0aYeikTitvTQbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YPynQ-QBx5nZEnYrP5kGTVvv9VAj0cV0aYeikTitvTQbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> On Tue, Jul 23, 2013 at 2:38 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > This doesn't delegate it into the container.  It allows me, on the host,
> > to set the cgroup for a container.
> 
> Hmmm? I'm a bit confused. Isn't the description saying that the patch
> allows pseudo-root in userns to change cgroup membership even if it
> isn't actually root?

If task A is uid 1000 on the host, and creates task B as uid X in a new
user namespace, then task A, still being uid 1000 on the host, is
privileged with respect to B and his namespace - i.e.
ns_capable(B->userns, CAP_SYS_ADMIN) is true.

> Besides, I find the whole check rather bogus and would actually much
> prefer just nuking the check and just follow the standard permission
> checks.

I'd be ok with that - but there's one case I'm not sure about:  If PAM
sets me up with /sys/fs/cgroup/devices/serge owned by me, then if I'm
thinking right, removing can_attach would mean I could move init into
/sys/fs/cgroup/devices/serge...

Is there something else stopping that from happening?

-serge
