Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaCAK5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 05:57:52 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:11922 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaCAK5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 05:57:50 -0500
X-AuditID: cbfec373-b7f4a6d000005e0a-ff-5311bd2cdcfd
Date: Sat, 01 Mar 2014 07:57:42 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Patrick Dickey <pdickeybeta@gmail.com>
Subject: Re: [PATCH 0/3] media/drx39xyj: fix DJH_DEBUG path null pointer
 dereferences, and compile errors.
Message-id: <20140301075742.626e457c@samsung.com>
In-reply-to: <CAGoCfiyZr2eCCW3ZmAE4_YUZw++NC3o-VY84M+n38tzfLdfBiQ@mail.gmail.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
 <CAGoCfiyZr2eCCW3ZmAE4_YUZw++NC3o-VY84M+n38tzfLdfBiQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/hEF2dvYLBBqcv6Fvc2r2axeLyrjls
	Fj0btrJaPDz8htXiy2cui68/HRzYPHbOusvuMfdYL6NH35ZVjB6fN8kFsERx2aSk5mSWpRbp
	2yVwZfR9/sNccEu54slmkQbGCzJdjJwcEgImEqduLGCEsMUkLtxbz9bFyMUhJLCEUeLZ7+1M
	EE4Pk8TGu3+ZQKpYBFQlTt59ygxiswkYSbxqbGEFsUUEjCW2X/wP1s0ssBCou2sRG0hCWCBH
	4vqq42A2r4ChxNOW42DNnALBEp9m3AeLCwnUSVx6O4sV4gwniVevJzNB1AtK/Jh8jwXEZhbQ
	kti8rYkVwpaX2LzmLfMERoFZSMpmISmbhaRsASPzKkbR0uLkguKk9FwjveLE3OLSvHS95Pzc
	TYyQcC7ewfhig9UhRgEORiUeXolFAsFCrIllxZW5hxglOJiVRHgV5goGC/GmJFZWpRblxxeV
	5qQWH2Jk4uCUamD0lvl3L2nSvCJT22kWfqXvc6IPvbPQbzVgjoiyE+x6sdU+i1/ov3yiKIf6
	1tUvNH+aHJp7hWm3/bN9BdNVLilfUU+W2Hv63IzVs19bG574Giz/y3Pppua1DEuilF2fvJ67
	4BOf0Hm20ydXv9/w9mL7Uo5lXg76nyZXP7pxzqWnZ73q661rvE/OVWIpzkg01GIuKk4EAIZ7
	rThFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devin,

Em Fri, 28 Feb 2014 19:13:16 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Seems kind of strange that I wasn't on the CC for this, since I was the
> original author of all that code (in fact, DJH are my initials).
> 
> Mauro, did you strip off my authorship when you pulled the patches from my
> tree?

Thanks for warning me about that!

Not sure what happened there. The original branch were added back in 2012,
with the sole reason to provide a way for Patrick Dickey to catch a few
patches I made on that time with some CodingStyle fixes:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j

There, your name was there as an extra weird "Committer" tag on those changesets:
	http://git.linuxtv.org/mchehab/experimental.git/commit/24d5ed7b19cc19f807264d7d4d56ab48e5cab230
	http://git.linuxtv.org/mchehab/experimental.git/commit/0440897f72b9cf82b8f576fae292b0567ad88239

The second one also contained a "Tag: tip" on it. So, I suspect that
something wrong happened when I imported it (either from your tree or
from some email sent by you or by Patrick). Probably, some broken
hg-import scripting.

Anyway, I rebased my tree, fixing those issues, at:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/drx-j-v3

I also added a credit at the first patch for Patrick's fixes that
I suspect it was merged somehow there, based on the comments he
posted at the mailing list when he sent his 25-patches series:
	https://lwn.net/Articles/467301/

Please let me know if you find any other issues on it. Anyway, I'll post
the patches from my experimental branch at the ML before merging them
upstream, in order to get a proper review.

Before that happen, however, I need to fix a serious bug that is
preventing to watch TV with this frontend, that it is there since the
first patch.

To be sure that this is a driver issue, I tested the driver on
another OS using the original PCTV driver, and it worked.

However, since the first working version of this driver, it
is randomly losing MPEG TS packets.

The bug is intermittent: every time it sets up VSB reception, it loses
different MPEG TS tables. Sometimes, not a single TS packet is received,
but, most of the time, it gets ~ 1/10 of the expected number of packets.

It behaves like letting a hardware PID filtering on some random state,
inspecting the traffic using dvbv5-zap at monitor mode shows just a
small set of the MPEG TS PIDs,  but I'm starting to suspect that it
could be due to something else, like an improper ISOC setting at em28xx
or due to some clock initialized with the wrong value.

I'm even tried to compare what's the original driver is doing with the
Linux one, but the original driver provided by PCTV was compiled using a
different firmware version, so it uses a different drxj_map.h.

I would need to get in hands the drxj_map.h used by PCTV, in order to be
able to properly see what initialization is being done by the PCTV driver
and see what sequence is missing.

I won't be merging this driver upstream while this bug is not fixed.

It would help a lot if I could get the original tree you worked with, as
maybe this bug might not be present there. In such case, then the bug is
likely at em28xx side.

Do you still have a copy of your old hg tree? Do you have some contact at
PCTV that could help me either getting a binary driver using the same
version as the one you used here, or getting me the newer drxj_map.h
file?

Thanks,
Mauro

> 
> The patches themselves look sane, and I will send a formal Acked-by once I
> can get in front of a real computer.
> 
> Devin
> On Feb 28, 2014 4:23 PM, "Shuah Khan" <shuah.kh@samsung.com> wrote:
> 
> > This patch series fixes null pointer dereference boot failure as well as
> > compile errors.
> >
> > Shuah Khan (3):
> >   media/drx39xyj: fix pr_dbg undefined compile errors when DJH_DEBUG is
> >     defined
> >   media/drx39xyj: remove return that prevents DJH_DEBUG code to run
> >   media/drx39xyj: fix boot failure due to null pointer dereference
> >
> >  drivers/media/dvb-frontends/drx39xyj/drxj.c | 31
> > ++++++++++++++++++-----------
> >  1 file changed, 19 insertions(+), 12 deletions(-)
> >
> > --
> > 1.8.3.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >


-- 

Cheers,
Mauro
