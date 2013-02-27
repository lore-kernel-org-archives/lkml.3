Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3B0Kjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:39:46 -0500
Received: from forward19.mail.yandex.net ([95.108.253.144]:44940 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3B0Kjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:39:45 -0500
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
In-Reply-To: <20130227094054.GC16719@dhcp22.suse.cz>
References: <8121361952156@webcorp1g.yandex-team.ru> <20130227094054.GC16719@dhcp22.suse.cz>
Subject: Re: [PATCH] memcg: implement low limits
MIME-Version: 1.0
Message-Id: <17521361961576@webcorp1g.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 27 Feb 2013 14:39:36 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.02.2013, 13:41, "Michal Hocko" <mhocko@suse.cz>:
> Let me restate what I have already mentioned in the private
> communication.
>
> We already have soft limit which can be implemented to achieve the
> same/similar functionality and in fact this is a long term objective (at
> least for me). I hope I will be able to post my code soon. The last post
> by Ying Hand (cc-ing her) was here:
> http://comments.gmane.org/gmane.linux.kernel.mm/83499
>
> To be honest I do not like introduction of a new limit because we have
> two already and the situation would get over complicated.

I think, there are three different tasks:
1) keeping cgroups below theirs hard limit to avoid direct reclaim (for performance reasons),
2) cgroup's prioritization during global reclaim,
3) granting some amount of memory to a selected cgroup (and protecting it from reclaim without significant reasons)

IMHO, combining them all in one limit will simplify a kernel code, but will also make a user's (or administrator's) 
life much more complicated. Introducing low limits can make the situation simpler.

>
> More comments on the code bellow.

Thank you very much!
I'll address them in an other letter.

--
Regards,
Roman
