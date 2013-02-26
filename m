Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab3BZBXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:23:03 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:55956 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3BZBW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:22:59 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
Date: Mon, 25 Feb 2013 17:22:58 -0800
X-Google-Sender-Auth: LHGRWdUw8huqp713Mj_7kK9ZwZE
Message-ID: <CA+55aFxGfRpYAn8BqTV=akmsvmDbJoefb+UMMo6FB7M6RPa82A@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 4:05 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> So up front, this has a massive merge conflict in
> drivers/gpu/drm/radeon/evergreen_cs.c I've fixed it up in drm-next-merged
> in the same tree, I fixed up some small ordering issues in my merge as
> well, however they aren't important if you want the fun of doing a major
> conflict resolution.

I did the fun conflict resolution, so my tree doesn't have the ordering changes.

I also did some things slightly differently from you - you had left
some direct ib[] accesses that I spotted (see for example "case 0x48"
(aka "Copy L2T Frame to Field"), and yours apparently has a few cases
where you use "idx_value" instead of my mindless conflict resolution
that just re-did the brute-force "repace direct ib[] read accesses
with the radeon_get_ib_value() helper function". But you don't do it
for *all* the radeon_get_ib_value(p, idx+2) users, so whatever.

Anyway - my conflict resolution isn't exactly the same as yours, and
maybe I screwed something up. But it's damn close, and the differences
_seem_ be all be benign.

Btw, why is it ok that some functions still read the ib[] array
directly (eg evergreen_vm_packet3_check() or evergreen_cs_check_reg()
etc)?


Whatever. I prefer doing my own resolutions just so that I know what's
going on, and it all seems to build and looks reasonable, but it's
always good to get a second opinion. Particularly since I can't
actually test the radeon stuff, so just eyeballing it and saying
"looks semantically identical to Dave's resolution" may not be 100%
sufficient..

                 Linus
