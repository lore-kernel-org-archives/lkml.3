Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003Ab3GWTMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:12:51 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:52210 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933871Ab3GWTMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:12:50 -0400
Date: Tue, 23 Jul 2013 15:12:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
Message-ID: <20130723191245.GI21100@mtj.dyndns.org>
References: <20130723181606.GA6342@sergelap>
 <20130723183018.GF21100@mtj.dyndns.org>
 <20130723183841.GA9021@tp>
 <CAOS58YPynQ-QBx5nZEnYrP5kGTVvv9VAj0cV0aYeikTitvTQbA@mail.gmail.com>
 <20130723190426.GA9577@tp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723190426.GA9577@tp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 23, 2013 at 02:04:26PM -0500, Serge Hallyn wrote:
> If task A is uid 1000 on the host, and creates task B as uid X in a new
> user namespace, then task A, still being uid 1000 on the host, is
> privileged with respect to B and his namespace - i.e.
> ns_capable(B->userns, CAP_SYS_ADMIN) is true.

Well, that also is the exact type of priv delegation we're moving away
from, so....

> > Besides, I find the whole check rather bogus and would actually much
> > prefer just nuking the check and just follow the standard permission
> > checks.
> 
> I'd be ok with that - but there's one case I'm not sure about:  If PAM
> sets me up with /sys/fs/cgroup/devices/serge owned by me, then if I'm
> thinking right, removing can_attach would mean I could move init into
> /sys/fs/cgroup/devices/serge...
> 
> Is there something else stopping that from happening?

If PAM is giving out perms on cgroup directory, the whole system is
prone to DoS in various ways anyway.  It's already utterly broken, so
kinda moot point.  If there are people actually doing that in the
wild, we can conditionalize it on cgroup_sane_behavior().

Thanks.

-- 
tejun
