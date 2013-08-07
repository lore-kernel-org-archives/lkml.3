Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab3HGNq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:46:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab3HGNqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:46:55 -0400
Date: Wed, 7 Aug 2013 15:46:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 1/3] memcg: limit the number of thresholds per-memcg
Message-ID: <20130807134654.GJ8184@dhcp22.suse.cz>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <20130807132210.GD27006@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807132210.GD27006@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-08-13 09:22:10, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 07, 2013 at 01:28:25PM +0200, Michal Hocko wrote:
> > There is no limit for the maximum number of threshold events registered
> > per memcg. This might lead to an user triggered memory depletion if a
> > regular user is allowed to register on memory.[memsw.]usage_in_bytes
> > eventfd interface.
> > 
> > Let's be more strict and cap the number of events that might be
> > registered. MAX_THRESHOLD_EVENTS value is more or less random. The
> > expectation is that it should be high enough to cover reasonable
> > usecases while not too high to allow excessive resources consumption.
> > 1024 events consume something like 16KB which shouldn't be a big deal
> > and it should be good enough.
> 
> I don't think the memory consumption per-se is the issue to be handled
> here (as kernel memory consumption is a different generic problem) but
> rather that all listeners, regardless of their priv level, cgroup
> membership and so on, end up contributing to this single shared
> contiguous table,

The table is per-memcg but you are right that everybody who has file
write access to the particular group's usage file can register to it.

> which makes it quite easy to do DoS attack on it if
> the event control is actually delegated to untrusted security domain,

OK, I have obviously misunderstood your concern mentioned in the other
email. Could you be more specific what is the DoS scenario which was
your concern, then?

[...]
> Can you please update the patch description to reflect the actual
> problem?

As soon as I understand what is your concern ;)
-- 
Michal Hocko
SUSE Labs
