Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3GEGXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:23:51 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43656 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEGXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:23:50 -0400
Date: Fri, 5 Jul 2013 08:23:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>
Subject: Re: [GIT PULL] core/mutexes changes for v3.11: W/W mutex support
Message-ID: <20130705062345.GA29487@gmail.com>
References: <20130701082221.GA14112@gmail.com>
 <CA+55aFwfsz6e5oQAdZw-YyYzwJXCPjKJKiLEXxn7ujU7KWX97Q@mail.gmail.com>
 <51D3C4C8.8060701@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D3C4C8.8060701@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:

> Hey,
> 
> Op 03-07-13 02:54, Linus Torvalds schreef:
> > On Mon, Jul 1, 2013 at 1:22 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> Please pull the latest core-mutexes-for-linus git tree from:
> >>
> >>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-mutexes-for-linus
> >>
> >>    HEAD: 166989e366ffa66108b2f37b870e66b85b2185ad locking-selftests: Handle unexpected failures more strictly
> >>
> >> This tree adds support for wound/wait style locks, which the graphics guys
> >> would like to make use of in the TTM graphics subsystem.
> > So I pulled this, but I'm not particularly happy with how this (very
> > unusual) lock pollutes <linux/mutex.h> that pretty much every single
> > file ends up including.
> >
> > So I'd really prefer to see the ww_mutex() support split up into
> > <linux/ww_mutex.h>, rather than making the compiler have to parse and
> > remember that stuff when 99.99% of all files do not care about it or
> > need it.
> 
> Sounds good to me, but can it wait until with the drm pull is done?

The ordering should not matter much as the combination will be tested in 
linux-next anyway.

> Preliminary diff below.

Looks good to me at first sight. Please send a tested, changelogged, 
signed off version.

Thanks,

	Ingo
