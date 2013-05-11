Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3EKGMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 02:12:31 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:47281 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3EKGM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 02:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130510045049.GU24635@dastard>
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
	<20130510045049.GU24635@dastard>
Date: Fri, 10 May 2013 23:12:27 -0700
Message-ID: <CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com>
Subject: Re: Tux3 Report: Faster than tmpfs, what?
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, tux3@tux3.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Thanks for the catch - I should indeed have noted that "modified
dbench" was used for this benchmark, thus amplifying Tux3's advantage
in delete performance. This literary oversight does not make the
results any less interesting: we beat Tmpfs on that particular load.
Beating tmpfs at anything is worthy of note. Obviously, all three
filesystems ran the same load.

We agree that "classic unadulterated dbench" is an important Linux
benchmark for comparison with other filesystems. I think we should
implement a proper fsync for that one and not just use fsync = sync.
That isn't very far in the future, however our main focus right now is
optimizing spinning disk allocation. It probably makes logistical
sense to leave fsync as it is for now and concentrate on the more
important issues.

I do not agree with your assertion that the benchmark as run is
invalid, only that the modified load should have been described in
detail. I presume you would like to see a new bakeoff using "classic"
dbench. Patience please, this will certainly come down the pipe in due
course. We might not beat Tmpfs on that load but we certainly expect
to outperform some other filesystems.

Note that Tux3 ran this benchmark using its normal strong consistency
semantics, roughly similar to Ext4's data=journal. In that light, the
results are even more interesting.

> ...you've done that so the front end of tux3 won't
> encounter any blocking operations and so can offload 100% of
> operations.

Yes, that is the entire point of our front/back design: reduce
application latency for buffered filesystem transactions.

> It also explains the sync call every 4 seconds to keep
> tux3 back end writing out to disk so that a) all the offloaded work
> is done by the sync process and not measured by the benchmark, and
> b) so the front end doesn't overrun queues and throttle or run out
> of memory.

Entirely correct. That's really nice, don't you think? You nicely
described a central part of Tux3's design: our "delta" mechanism. We
expect to spend considerable effort tuning the details of our delta
transition behaviour as time goes by. However this is not an immediate
priority because the simplistic "flush every 4 seconds" hack already
works pretty well for a lot of loads.

Thanks for your feedback,

Daniel
