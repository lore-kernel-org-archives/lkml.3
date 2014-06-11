Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaFKPeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:34:15 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:59888 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaFKPeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:34:14 -0400
Date: Wed, 11 Jun 2014 11:34:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] memcg: Allow hard guarantee mode for low limit
 reclaim
Message-ID: <20140611153410.GB17777@htj.dyndns.org>
References: <20140606144421.GE26253@dhcp22.suse.cz>
 <1402066010-25901-1-git-send-email-mhocko@suse.cz>
 <1402066010-25901-2-git-send-email-mhocko@suse.cz>
 <xr934mzt4rwc.fsf@gthelen.mtv.corp.google.com>
 <20140610165756.GG2878@cmpxchg.org>
 <20140611075729.GA4520@dhcp22.suse.cz>
 <20140611123109.GA17777@htj.dyndns.org>
 <20140611141117.GF4520@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611141117.GF4520@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:11:17PM +0200, Michal Hocko wrote:
> > I still think it'd be less useful than "high", but as there seem to be
> > use cases which can be served with that and especially as a part of a
> > consistent control scheme, I have no objection.
> > 
> > "low" definitely requires a notification mechanism tho.
> 
> Would vmpressure notification be sufficient? That one is in place for
> any memcg which is reclaimed.

Yeah, as long as it can reliably notify userland that the soft
guarantee has been breached, it'd be great as it means we'd have a
single mechanism to monitor both "low" and "high" while "min" and
"max" are oom based, which BTW needs more work but that's a separate
piece of work.

Thanks.

-- 
tejun
