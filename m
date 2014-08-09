Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaHIAcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:32:33 -0400
Received: from imap.thunk.org ([74.207.234.97]:51818 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaHIAcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:32:32 -0400
Date: Fri, 8 Aug 2014 20:32:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: John Stultz <john.stultz@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Chris Ball <chris@printf.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Johan Rudholm <jrudholm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 3.15 mmc related ext4 corruption with
 qemu-system-arm
Message-ID: <20140809003217.GS25145@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	John Stultz <john.stultz@linaro.org>,
	Kees Cook <keescook@chromium.org>,
	Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
	Peter Maydell <peter.maydell@linaro.org>,
	Johan Rudholm <jrudholm@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	lkml <linux-kernel@vger.kernel.org>
References: <CALAqxLWAXU0hS8si-CmkOObBOHGv_skMVfPnUsdmLcZzkdUsWA@mail.gmail.com>
 <53E53DCD.2020707@linaro.org>
 <CAGXu5j+Q8F8TKy8sxCL6pxD-cni4RKxy46HwsCSZE+mWpuyn-g@mail.gmail.com>
 <53E568B2.40206@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E568B2.40206@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 05:17:54PM -0700, John Stultz wrote:
> On 08/08/2014 05:15 PM, Kees Cook wrote:
> > On Fri, Aug 8, 2014 at 2:14 PM, John Stultz <john.stultz@linaro.org> wrote:
> >> I sunk a couple of weeks bisecting to try to narrow down the more
> >> sporadic issue, but was unsuccessful past the initial commit above.
> >> Since then I've been far too swamped to spend any more time on it. Even
> >> so, its a *major* pain for testing but it seems like no one else really
> >> cares?
> > I'm in the same boat as far as poor bisection results. :(
> >
> > However, I keep using the 3-patch mmci fix series from Ulf, and
> > haven't hit any trouble with them. Though perhaps I'm just getting
> > lucky?
> >
> > http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=arm/fix-mmci
> 
> I guess I'll give that another shot 

There was an ext4 bug that might have caused this problem.  It was
fixed in v3.15.6 and v3.16-rc5.

commit f9ae9cf5d72b3926ca48ea60e15bdbb840f42372
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Jul 11 13:55:40 2014 -0400

    ext4: revert commit which was causing fs corruption after journal replays
    
    Commit 007649375f6af2 ("ext4: initialize multi-block allocator before
    checking block descriptors") causes the block group descriptor's count
    of the number of free blocks to become inconsistent with the number of
    free blocks in the allocation bitmap.  This is a harmless form of fs
    corruption, but it causes the kernel to potentially remount the file
    system read-only, or to panic, depending on the file systems's error
    behavior.
    
    Thanks to Eric Whitney for his tireless work to reproduce and to find
    the guilty commit.
    
    Fixes: 007649375f6af2 ("ext4: initialize multi-block allocator before checki
    
    Cc: stable@vger.kernel.org  # 3.15
    Reported-by: David Jander <david@protonic.nl>
    Reported-by: Matteo Croce <technoboy85@gmail.com>
    Tested-by: Eric Whitney <enwlinux@gmail.com>
    Suggested-by: Eric Whitney <enwlinux@gmail.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

The bug wouldn't always trigger, which is probably why it gave you so
much trouble trying to do the bisect.

Cheers,

					- Ted
