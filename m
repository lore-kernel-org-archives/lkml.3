Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaD2HsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:48:16 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41336 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaD2HsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:48:15 -0400
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz> <10861398700008@webcorp2f.yandex-team.ru>
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Greg Thelen <gthelen@google.com>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
In-reply-to: <10861398700008@webcorp2f.yandex-team.ru>
Date: Tue, 29 Apr 2014 00:42:45 -0700
Message-ID: <xr938uqoa8ei.fsf@gthelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Apr 28 2014, Roman Gushchin <klamm@yandex-team.ru> wrote:

> 28.04.2014, 16:27, "Michal Hocko" <mhocko@suse.cz>:
>> The series is based on top of the current mmotm tree. Once the series
>> gets accepted I will post a patch which will mark the soft limit as
>> deprecated with a note that it will be eventually dropped. Let me know
>> if you would prefer to have such a patch a part of the series.
>>
>> Thoughts?
>
>
> Looks good to me.
>
> The only question is: are there any ideas how the hierarchy support
> will be used in this case in practice?
> Will someone set low limit for non-leaf cgroups? Why?
>
> Thanks,
> Roman

I imagine that a hosting service may want to give X MB to a top level
memcg (/a) with sub-jobs (/a/b, /a/c) which may(not) have their own
low-limits.

Examples:

case_1) only set low limit on /a.  /a/b and /a/c may overcommit /a's
        memory (b.limit_in_bytes + c.limit_in_bytes > a.limit_in_bytes).

case_2) low limits on all memcg.  But not overcommitting low_limits
        (b.low_limit_in_in_bytes + c.low_limit_in_in_bytes <=
        a.low_limit_in_in_bytes).
