Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaFUSXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 14:23:01 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:46277 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaFUSXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 14:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140621180201.GA4621@amd.pavel.ucw.cz>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
Date: Sat, 21 Jun 2014 14:22:59 -0400
X-Google-Sender-Auth: 1KUL-gFwwY3UwTrQXJsh60KEiYQ
Message-ID: <CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>, Greg KH <greg@kroah.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 2:02 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> AFAICT, pstate file will contain something like
>
> 07: core 100 MHz memory 123 MHz *
> 08: core 100-200 MHz memory 123 MHz
>
> ...which does not look exactly like one-value-per-file, and I'm pretty
> sure userspace will get it wrong if it tries to parse it. Plus, I
> don't see required documentation in Documentation/ABI.
>
> Should we disable it for now, so that userspace does not start
> depending on it and we'll not have to maintain it forever?
>
> I guess better interface would be something like
>
> pstate/07/core_clock_min
>           core_clock_max
>           memory_clock_min
>           memory_clock_max
>
> and then pstate/active containing just the number of active state?
>
> Thanks,
>                                                                 Pavel
>
> PS: I have no nvidia, got the news at
>
> http://www.phoronix.com/scan.php?page=article&item=nouveau_try_linux316&num=2

FTR, this file has been in place since 3.13, and there was a different
file before it (performance_levels), with a comparable format since
much earlier (definitely 3.8, probably earlier). I think it's meant a
lot more for people looking at it and echo'ing stuff to it to modify
the levels (where supported), than for programs parsing it. Perhaps
sysfs is the wrong place for this -- what is the right place? debugfs?

  -ilia
