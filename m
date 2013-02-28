Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3B1LNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:13:23 -0500
Received: from forward16.mail.yandex.net ([95.108.253.141]:41907 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3B1LNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:13:21 -0500
From: Roman Gushchin <klamm@yandex-team.ru>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner-Arquette <hannes@cmpxchg.org>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Ying Han <yinghan@google.com>
In-Reply-To: <20130227161352.GF16719@dhcp22.suse.cz>
References: <8121361952156@webcorp1g.yandex-team.ru>
 <20130227094054.GC16719@dhcp22.suse.cz>
 <17521361961576@webcorp1g.yandex-team.ru> <20130227161352.GF16719@dhcp22.suse.cz>
Subject: Re: [PATCH] memcg: implement low limits
MIME-Version: 1.0
Message-Id: <61661362049995@webcorp1g.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 28 Feb 2013 15:13:15 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.02.2013, 20:14, "Michal Hocko" <mhocko@suse.cz>:
> On Wed 27-02-13 14:39:36, Roman Gushchin wrote:
>
>> š27.02.2013, 13:41, "Michal Hocko" <mhocko@suse.cz>:
>>> šLet me restate what I have already mentioned in the private
>>> šcommunication.
>>>
>>> šWe already have soft limit which can be implemented to achieve the
>>> šsame/similar functionality and in fact this is a long term objective (at
>>> šleast for me). I hope I will be able to post my code soon. The last post
>>> šby Ying Hand (cc-ing her) was here:
>>> šhttp://comments.gmane.org/gmane.linux.kernel.mm/83499
>>>
>>> šTo be honest I do not like introduction of a new limit because we have
>>> štwo already and the situation would get over complicated.
>> šI think, there are three different tasks:
>> š1) keeping cgroups below theirs hard limit to avoid direct reclaim
>> š(for performance reasons),
>
> Could you clarify what you mean by this, please? There is no background
> reclaim for memcgs currently and I am a bit skeptical whether it is
> useful. If it would be useful then it should be in par with the global
> reclaim (so something like min_free_kbytes would be more appropriate).

I mean, that it's a good idea to keep memory usage of any cgroup a little bit 
under it's hard limit to avoid direct reclaim. There is no good mechanism yet,
but it can be developed later.

>> š2) cgroup's prioritization during global reclaim,
>
> Yes, group priorities sound like a useful feature not just for the
> reclaim I would like it for oom selection as well.
> I think that we shouldn't use any kind of limit for this task, though.

I'm thinking about them. Do you know, did someone any attempts to implement them?
I have an idea how to implement them (and also implementing (fast) strict lower limits limits).
I'll try to post my version soon.

>> š3) granting some amount of memory to a selected cgroup (and protecting
>> šit from reclaim without significant reasons)
>
> and soft limit sounds like a good fit with this description.
>
>> šIMHO, combining them all in one limit will simplify a kernel code,
>> šbut will also make a user's (or administrator's) life much more
>> šcomplicated.
>
> I do not think all 3 tasks you have described can be covered by a single
> limit of course. We have hard limit to cap the usage, we have a soft
> limit to allow over-committing the machine. Task 2 would require a new
> knob but it shouldn't be covered by any limit or depend on the group
> usage. And task 1 sounds like a background reclaim and then it should be
> consistent with the global knob.
>
>> šIntroducing low limits can make the situation simpler.
>
> How exactly? I can see how it would address task 3 but yet again, soft
> limit can be turned into this behavior as well without changing its
> semantic (that limit would be still considered if we are able to handle
> memory pressure from the above - either global pressure or parent
> hitting the limit).

Actually, I don't like the name of soft limits - the word "soft". It's not clear from
the name if it's lower or upper limit. It's a little bit confusing that "limit" 
means upper limit, and "soft limit" means lower limit.

Assuming it's possible to implement strict lower limit efficiently, how do you call them?

Thank you!

--
Regards, 
Roman
