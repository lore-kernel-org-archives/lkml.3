Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbaD2Ku1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:50:27 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:53557 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933543AbaD2KuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:50:25 -0400
From: Roman Gushchin <klamm@yandex-team.ru>
To: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <xr938uqoa8ei.fsf@gthelen.mtv.corp.google.com>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz> <10861398700008@webcorp2f.yandex-team.ru> <xr938uqoa8ei.fsf@gthelen.mtv.corp.google.com>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
MIME-Version: 1.0
Message-Id: <7441398768618@webcorp2f.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 29 Apr 2014 14:50:18 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

29.04.2014, 11:42, "Greg Thelen" <gthelen@google.com>:
> On Mon, Apr 28 2014, Roman Gushchin <klamm@yandex-team.ru> wrote:
>
>> š28.04.2014, 16:27, "Michal Hocko" <mhocko@suse.cz>:
>>> šThe series is based on top of the current mmotm tree. Once the series
>>> šgets accepted I will post a patch which will mark the soft limit as
>>> šdeprecated with a note that it will be eventually dropped. Let me know
>>> šif you would prefer to have such a patch a part of the series.
>>>
>>> šThoughts?
>> šLooks good to me.
>>
>> šThe only question is: are there any ideas how the hierarchy support
>> šwill be used in this case in practice?
>> šWill someone set low limit for non-leaf cgroups? Why?
>>
>> šThanks,
>> šRoman
>
> I imagine that a hosting service may want to give X MB to a top level
> memcg (/a) with sub-jobs (/a/b, /a/c) which may(not) have their own
> low-limits.
>
> Examples:
>
> case_1) only set low limit on /a. š/a/b and /a/c may overcommit /a's
> ššššššššmemory (b.limit_in_bytes + c.limit_in_bytes > a.limit_in_bytes).
>
> case_2) low limits on all memcg. šBut not overcommitting low_limits
> šššššššš(b.low_limit_in_in_bytes + c.low_limit_in_in_bytes <=
> šššššššša.low_limit_in_in_bytes).

Thanks!

With use_hierarchy turned on it looks perfectly usable.
