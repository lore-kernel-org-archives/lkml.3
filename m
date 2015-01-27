Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbbA0VPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:15:35 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37044 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbbA0VPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:15:34 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz8yWK9ndqgLSDaaTeCPb5zHihjJvCH3r0y2n8CsoExHw@mail.gmail.com>
References: <alpine.DEB.2.00.1501270205210.966@skynet.skynet.ie>
	<CA+55aFz8yWK9ndqgLSDaaTeCPb5zHihjJvCH3r0y2n8CsoExHw@mail.gmail.com>
Date: Wed, 28 Jan 2015 07:15:33 +1000
Message-ID: <CAPM=9tyZWzaF=iThfXcLgYSQ44e9AuRVTBcV1q++1oAdZ-QndA@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2015 at 04:04, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 26, 2015 at 6:06 PM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> are available in the git repository at:
>>
>>   git://people.freedesktop.org/~airlied/linux drm-fixes
>
> No they aren't, actually, because you've screwed up your repository.
>
> It looks like you were using an alternates that has gone away:
>
>    remote: error: object directory
> /srv/anongit.freedesktop.org/git/nouveau/linux-2.6/objects does not
> exist; check .git/objects/info/alternates.
>    remote: error: Could not read fe06a892edbcd0cd42ea5928e4492a337e3bd90c
>    remote: fatal: bad tree object fe06a892edbcd0cd42ea5928e4492a337e3bd90c
>    remote: aborting due to possible repository corruption on the remote side.
>
> it really looks like you started your repo by doing a shared clone
> from an insane source (ie the nouveau tree), and then the nouveau tree
> got renamed or deleted (perhaps somebody decided that the whole
> "linux-2.6" naming doesn't make sense any more, since we haven't been
> at 2.6 for years). So now your repository depends on another repo that
> is gone.
>
> It's should be trivially fixable by just editing the git "alternates"
> file to point to the proper base again, since that fe06a892edbc object
> is definitely part of my base kernel, but basically you shouldn't do
> shared clones unless you know you can really *rely* on the clone
> you're sharing from. Doing it from some random side project like the
> nouveau tree sounds like a bad bad idea.

Actually everything was there, just one tree is NFS mounted from somewhere else,
and fd.o got rebooted and the mount didn't come back up automatically,
fixed it now.

But yes I'll reorganise my tree to be a clean copy, I built it years
ago temporarily
and it kinda ended up permanent, and I forgot where I cloned it from.

Dave.
