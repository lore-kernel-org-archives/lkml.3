Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbbA0SEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:04:15 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:42002 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026AbbA0SEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:04:11 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1501270205210.966@skynet.skynet.ie>
References: <alpine.DEB.2.00.1501270205210.966@skynet.skynet.ie>
Date: Tue, 27 Jan 2015 10:04:10 -0800
X-Google-Sender-Auth: VojYMIkXNohZ5OleNCqI3o1eA2I
Message-ID: <CA+55aFz8yWK9ndqgLSDaaTeCPb5zHihjJvCH3r0y2n8CsoExHw@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 6:06 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> are available in the git repository at:
>
>   git://people.freedesktop.org/~airlied/linux drm-fixes

No they aren't, actually, because you've screwed up your repository.

It looks like you were using an alternates that has gone away:

   remote: error: object directory
/srv/anongit.freedesktop.org/git/nouveau/linux-2.6/objects does not
exist; check .git/objects/info/alternates.
   remote: error: Could not read fe06a892edbcd0cd42ea5928e4492a337e3bd90c
   remote: fatal: bad tree object fe06a892edbcd0cd42ea5928e4492a337e3bd90c
   remote: aborting due to possible repository corruption on the remote side.

it really looks like you started your repo by doing a shared clone
from an insane source (ie the nouveau tree), and then the nouveau tree
got renamed or deleted (perhaps somebody decided that the whole
"linux-2.6" naming doesn't make sense any more, since we haven't been
at 2.6 for years). So now your repository depends on another repo that
is gone.

It's should be trivially fixable by just editing the git "alternates"
file to point to the proper base again, since that fe06a892edbc object
is definitely part of my base kernel, but basically you shouldn't do
shared clones unless you know you can really *rely* on the clone
you're sharing from. Doing it from some random side project like the
nouveau tree sounds like a bad bad idea.

                            Linus
