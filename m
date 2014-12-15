Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750899AbaLOSXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:23:37 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:43031 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLOSXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:23:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141215175535.GA4665@kroah.com>
References: <20141215175535.GA4665@kroah.com>
Date: Mon, 15 Dec 2014 19:23:35 +0100
Message-ID: <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com>
Subject: Re: [GIT PULL] Staging driver patches for 3.19-rc1
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 6:55 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> The following changes since commit 009d0431c3914de64666bec0d350e54fdd59df6a:
>
>   Linux 3.18-rc7 (2014-11-30 16:42:27 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.19-rc1
>
> for you to fetch changes up to 17d2c6439be65777245914be354c5a97c76ad246:
>
>   Staging: slicoss: Fix long line issues in slicoss.c (2014-12-02 16:54:43 -0800)
>
> ----------------------------------------------------------------
> Staging patches for 3.19-rc1
>
> Here's the big staging tree pull request for 3.19-rc1.
>
> We continued to delete more lines than were added, always a good thing,
> but not at a huge rate this release, only about 70k lines removed
> overall mostly from removing the horrid bcm driver.
>
> Lots of normal staging driver cleanups and fixes all over the place,
> well over a thousand of them, the shortlog shows all the horrid details.
>
> The "contentious" thing here is the movement of the Android binder code
> out of staging into the "real" part of the kernel.  This is code that
> has been stable for a few years now and is working as-is in the tens of
> millions of devices with no issues.  Yes, the code is horrid, and the
> userspace api leaves a lot to be desired, but it's not going to change
> due to legacy issues that we have no control over.  Because so many
> devices and companies rely on this, and the code is stable, might as
> well promote it out of staging.
>
> This was all discussed at the Linux Plumbers conference, and everyone
> participating agreed that this was the best way forward.
>
> There is work happening to replace the binder code with something new
> that is happening right now, but I don't expect to see the results of
> that work for another year at the earliest.  If that ever happens, and
> Android switches over to it, I'll gladly remove this version

I don't understand this kind of logic.
a) Binder is considered a piece of shite.
b) Google is working on a (hopefully sane) replacement.

Why moving it out of staging then? What is the benefit?
Keep it there for more 2-3 years and then remove it.
If you move it now out of staging into the core kernel it will be considered ABI
and getting rid of it can be hard...

-- 
Thanks,
//richard
