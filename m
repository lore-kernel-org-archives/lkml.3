Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3HOXGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 19:06:00 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34555 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3HOXF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 19:05:58 -0400
Message-ID: <520D5ED2.9040403@gmail.com>
Date: Fri, 16 Aug 2013 01:05:54 +0200
From: Ben Tebulin <tebulin@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ben Tebulin <tebulin@googlemail.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please continue
 your great work! :-)
References: <52050382.9060802@gmail.com> <520BB225.8030807@gmail.com> <20130814174039.GA24033@dhcp22.suse.cz> <CA+55aFwAz7GdcB6nC0Th42y8eAM591sKO1=mYh5SWgyuDdHzcA@mail.gmail.com> <20130814182756.GD24033@dhcp22.suse.cz> <CA+55aFxB6Wyj3G3Ju8E7bjH-706vi3vysuATUZ13h1tdYbCbnQ@mail.gmail.com> <520C9E78.2020401@gmail.com> <CA+55aFy2D2hTc_ina1DvungsCL4WU2OTM=bnVb8sDyDcGVCBEQ@mail.gmail.com> <CA+55aFxuUrcod=X2t2yqR_zJ4s1uaCsGB-p1oLTQrG+y+Z2PbA@mail.gmail.com>
In-Reply-To: <CA+55aFxuUrcod=X2t2yqR_zJ4s1uaCsGB-p1oLTQrG+y+Z2PbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.08.2013 20:00, schrieb Linus Torvalds:
> Ok, so I've slept on it, and here's my current thinking.
> [...]  

Many thoughts which as a user I'm am unable to follow  ;-)

> This patch tries to fix the interface instead of trying to patch up
> the individual places that *should* set the range some particular way
> [...]
> This patch is against current git, so to apply you need to have
> that commit e6c495a96ce0 cherry-picked to older kernels first.

I took a shot based on 3.9.11 + e6c495a96ce0. The reason why I don't
simply use the current git master is, that for some reasons my
linux-image-*.deb become 750MB and larger since 3.10.y and I have no
clue at all why and what to do about it.

The patch failed. Due to my outstanding incompetence I resorted into
applying it onto master, cherry-picking that back and trying to resolve
the remaining conflicts correctly.

>  - I have no idea whether this will fix the problem Ben sees, but I
> feel happier about the code, because now any place that forgets to set
> up start/end will work just fine, because they are always valid. 

Simpler code? Resilient API? Happy people? Great!

> Ben, please test. I'm worried that the problem you see is something 
> even more fundamentally wrong with the whole "oops, must flush in the
> middle" logic, but I'm _hoping_ this fixes it.

It's gone.

Really!

I git-fsck'ed successfully around 30 times in a row.
And even all the other things still seem to work ;-)

Honestly I have to confess that I'm deeply impressed how this finally
worked out: I just threw a particular, innocent-looking commit hash and
nothing more into the round. And while still being unsure if this might
be a plain user space issue, only 24h later I received a 11kb sized
kernel patch (with blatant typos in it !1! *g* ) apparently solving my
issue.

/me happy now, too! :)

- Ben
