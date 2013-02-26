Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038Ab3BZB7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:59:18 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:32983 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3BZB7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:59:15 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxGfRpYAn8BqTV=akmsvmDbJoefb+UMMo6FB7M6RPa82A@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+55aFxGfRpYAn8BqTV=akmsvmDbJoefb+UMMo6FB7M6RPa82A@mail.gmail.com>
Date: Tue, 26 Feb 2013 11:59:13 +1000
Message-ID: <CAPM=9tyY4_wN_XyHu09BXZAewq3DU8t2RTMq4zbr5URLnFSJbw@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I did the fun conflict resolution, so my tree doesn't have the ordering changes.
>
> I also did some things slightly differently from you - you had left
> some direct ib[] accesses that I spotted (see for example "case 0x48"
> (aka "Copy L2T Frame to Field"), and yours apparently has a few cases
> where you use "idx_value" instead of my mindless conflict resolution
> that just re-did the brute-force "repace direct ib[] read accesses
> with the radeon_get_ib_value() helper function". But you don't do it
> for *all* the radeon_get_ib_value(p, idx+2) users, so whatever.

Yeah the rules for radeon_get_ib_value are that they are meant to be sequential,
but it actually doesn't matter as long as the values are within a page
of each other,
I was just avoiding multiple calls to get the same value with the idx_value, but
I think Alex or Jerome can clean this up a bit further anyways.

> Anyway - my conflict resolution isn't exactly the same as yours, and
> maybe I screwed something up. But it's damn close, and the differences
> _seem_ be all be benign.
>
> Btw, why is it ok that some functions still read the ib[] array
> directly (eg evergreen_vm_packet3_check() or evergreen_cs_check_reg()
> etc)?

The semantics for that function are a bit underdocumented, and I thought
the other developers understood them after I explained them, but I found
out that they hadn't quite grasped the true extent of pain. So yes there
are other places that need to be cleaned up, but most of the time direct
ib access will work fine, until you have a buffer that straddles a
page boundary.

> Whatever. I prefer doing my own resolutions just so that I know what's
> going on, and it all seems to build and looks reasonable, but it's
> always good to get a second opinion. Particularly since I can't
> actually test the radeon stuff, so just eyeballing it and saying
> "looks semantically identical to Dave's resolution" may not be 100%
> sufficient..

Yup I've reviewed it and it looks fine, any cleanup is just going to be
an optimisation.

So I'll work with Alex/Jerome to clean up anything else out-of-band
and hopefully
we can avoid any big conflicts in future!

Dave.
