Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3LTQ64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:58:56 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57295 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab3LTQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:58:53 -0500
MIME-Version: 1.0
In-Reply-To: <20131220115359.225f7503@redhat.com>
References: <cover.1387193771.git.vdavydov@parallels.com>
	<abff42910c131a9c94a7518de59b283ee0a2dcd1.1387193771.git.vdavydov@parallels.com>
	<20131220092659.0ed23cf5@redhat.com>
	<CAA6-i6pDqDemeQ+s4EorOx39qmNAtAfVYfg0Z2wtTEu-S7mY=A@mail.gmail.com>
	<20131220100332.0c5c1ad5@redhat.com>
	<20131220114439.23af09fc@redhat.com>
	<CAA6-i6oJrUquFa3Y=+vGCDjh7z8ZOxT20QuyWweyrrKGOeBGAA@mail.gmail.com>
	<20131220115359.225f7503@redhat.com>
Date: Fri, 20 Dec 2013 20:58:52 +0400
Message-ID: <CAA6-i6pDQqhv+h0mP2mDacFUExDEy0oCJ7Lcqat0FSuv0NQUog@mail.gmail.com>
Subject: Re: [PATCH v14 16/18] vmpressure: in-kernel notifications
From: Glauber Costa <glommer@gmail.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, dchinner@redhat.com,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org,
        Glauber Costa <glommer@openvz.org>,
        John Stultz <john.stultz@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 8:53 PM, Luiz Capitulino <lcapitulino@redhat.com> wrote:
> On Fri, 20 Dec 2013 20:46:05 +0400
> Glauber Costa <glommer@gmail.com> wrote:
>
>> On Fri, Dec 20, 2013 at 8:44 PM, Luiz Capitulino <lcapitulino@redhat.com> wrote:
>> > On Fri, 20 Dec 2013 10:03:32 -0500
>> > Luiz Capitulino <lcapitulino@redhat.com> wrote:
>> >
>> >> > The answer for all of your questions above can be summarized by noting
>> >> > that for the lack of other users (at the time), this patch does the bare minimum
>> >> > for memcg needs. I agree, for instance, that it would be good to pass the level
>> >> > but since memcg won't do anything with thta, I didn't pass it.
>> >> >
>> >> > That should be extended if you need to.
>> >>
>> >> That works for me. That is, including this minimal version first and
>> >> extending it when we get in-tree users.
>> >
>> > Btw, there's something I was thinking just right now. If/when we
>> > convert shrink functions to use this API, they will come to depend
>> > on CONFIG_MEMCG=y. IOW, they won't work if CONFIG_MEMCG=n.
>> >
>> > Is this acceptable (this is an honest question)? Because today, they
>> > do work when CONFIG_MEMCG=n. Should those shrink functions use the
>> > shrinker API as a fallback?
>>
>> If you have a non-memcg user, that should obviously be available for
>> CONFIG_MEMCG=n
>
> OK, which means we'll have to change it, right? Because, if I'm not
> missing something, today vmpressure does depend on CONFIG_MEMCG=y.

You mean the main vmpressure mechanism?
Sorry, this was out of my mental cachelines. Yes, vmpressure depends
on MEMCG, because
the pressure interface is memcg-specific (global == root memcg)

You might want to change that so you can reuse the mechanism and let
only the user interface
depend on memcg.


-- 
E Mare, Libertas
