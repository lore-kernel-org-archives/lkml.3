Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaBEQah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:30:37 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36348 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaBEQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:30:36 -0500
Date: Wed, 5 Feb 2014 11:30:32 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH -v2 4/6] memcg: make sure that memcg is not offline when
 charging
Message-ID: <20140205162701.GB2786@htj.dyndns.org>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
 <1391520540-17436-5-git-send-email-mhocko@suse.cz>
 <20140204162939.GP6963@cmpxchg.org>
 <20140205133834.GB2425@dhcp22.suse.cz>
 <20140205152821.GY6963@cmpxchg.org>
 <20140205161940.GE2425@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205161940.GE2425@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Feb 05, 2014 at 05:19:40PM +0100, Michal Hocko wrote:
> > Well, css_free() is the callback invoked when the ref counter hits 0,
> > and that is a guarantee.  From a memcg perspective, it's the right
> > place to do reparenting, not css_offline().
> 
> OK, it seems I've totally misunderstood what is the purpose of
> css_offline. My understanding was that any attempt to css_tryget will

Heh, the semantics have changed significantly during the past year.
It started as something pretty unusual (synchronous ref draining on
rmdir) and took some iterations to reach the current design and we
still don't have any proper documentation, so misunderstanding
probably is inevitable, sorry.  :)

> fail when css_offline starts. I will read through Tejun's email as well
> and think about it some more.

Yes, css_tryget() is guaranteed to fail once css_offline() starts.
This is to help ref draining so that controllers have a scalable way
to reliably decide when to say no to new usages.  Please note that
css_get() is still allowed even after css_offline() (of course as long
as the caller already has a ref).

Thanks!

-- 
tejun
