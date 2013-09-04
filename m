Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105Ab3IDSwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:52:01 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:59019 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759751Ab3IDSv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <5226FAE1.5070201@fb.com>
References: <5226FAE1.5070201@fb.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Sep 2013 11:51:38 -0700
Message-ID: <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com>
Subject: Re: clock_gettime_ns
To: Arun Sharma <asharma@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>,
        John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that most of the hangup was a lack of agreement on how the API
should work wrt leap seconds.

I've always thought that the Right Way to represent a UTC time is
nanoseconds since some epoch, where every potential leap second
counts.

Pros:
 - Unambiguously convertible to and from
year/month/day/hour/minute/second/nanosecond.
 - Monotonic
 - Compact

Cons:
 - Computing differences between timestamps requires a table.  (Note:
y/m/d/h/m/s/ns has the same problem.)
 - Weird: no one does this
 - If you naively subtract times, you end up with jumps forward.  (But
jumps forward are much less likely to break things than jumps
backwards.)
 - Almost, but not quite, compatible with timespec, so it could cause confusion.

If someone wants a hard problem, find a way to implement clock_gettime
that almost never spins or otherwise block and is continuous.  I've
thought about it a bit and have something that almost works.

--Andy

On Wed, Sep 4, 2013 at 2:18 AM, Arun Sharma <asharma@fb.com> wrote:
> A couple of years ago Andy posted this patch series:
>
> http://thread.gmane.org/gmane.linux.kernel/1233209/
>
> These patches have been in use at facebook for a couple of years and along
> with a vDSO implementation of thread_cpu_time(), they have proven useful for
> our profilers.
>
> I didn't see any arguments against this patch series. Did I miss some
> discussion on the topic?
>
>  -Arun



-- 
Andy Lutomirski
AMA Capital Management, LLC
