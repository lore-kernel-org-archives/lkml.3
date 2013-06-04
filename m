Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3FDSJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:09:05 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43953 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3FDSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:09:04 -0400
Date: Tue, 4 Jun 2013 20:08:59 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [patch v4] Soft limit rework
Message-ID: <20130604180859.GB9321@dhcp22.suse.cz>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <CAKTCnz=CMbhhROPV4iC6_XPuu_8J53ZMTdXtY_bevPjG+B-+mw@mail.gmail.com>
 <20130604163828.GA9321@dhcp22.suse.cz>
 <CAKTCnz=MP5iadPJkngJqGMnXSwe9n-xGDEdzuT5Aqoyx0KAYwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTCnz=MP5iadPJkngJqGMnXSwe9n-xGDEdzuT5Aqoyx0KAYwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-06-13 23:27:05, Balbir Singh wrote:
> > OK, let me summarize. The primary intention is to get rid of the current
> > soft reclaim infrastructure which basically bypasses the standard
> > reclaim and tight it directly into shrink_zone code. This also means
> > that the soft reclaim doesn't reclaim at priority 0 and that it is
> > active also for the targeted (aka limit) reclaim.
> >
> > Does this help?
> >
> 
> Yes. What are the limitations of no-priority 0 reclaim?

I am not sure I understand the question. What do you mean by
limitations?

The priority-0 scan was always a crude hack. With a lot of pages in on
the LRU it might cause huge big stalls during direct reclaim. There are
workloads which benefited from such an aggressive reclaim - e.g.
streaming IO but that doesn't justify this kind of reclaim.
-- 
Michal Hocko
SUSE Labs
