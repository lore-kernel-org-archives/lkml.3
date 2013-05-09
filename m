Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3EIU2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:28:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34322 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3EIU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:28:17 -0400
Date: Thu, 9 May 2013 21:28:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] more vfs.git stuff
Message-ID: <20130509202815.GH25399@ZenIV.linux.org.uk>
References: <20130509192655.GG25399@ZenIV.linux.org.uk>
 <CA+55aFyCuksrVPwO=R_xX2An8qavo17aCZ5bfN=FWo1gZZfAsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyCuksrVPwO=R_xX2An8qavo17aCZ5bfN=FWo1gZZfAsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 01:12:43PM -0700, Linus Torvalds wrote:
> On Thu, May 9, 2013 at 12:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         Regression fix from Geert + yet another open-coded kernel_read().
> 
> Hmm. I get one more commit - a racy usbmon thing.

Oops - pull stats not updated...  My apologies.

> Which looks fine per
> se, but would look even better if it just made mmap_active an atomic_t
> instead, wouldn't you say?

The only place checking that sucker is in a fairly large area protected by
->b_lock (in mon_bin_event()); I really don't want to dig deep enough to
tell if having it changed right after it had been checked is safe.  OTOH,
from a cursory look through that code it appears that the whole map_count
thing is completely misguided - it seems to assume that ->open() is called for
each VMA, including the one created by mmap(2).  Sigh...

OK, it might make more sense to drop that last commit for now.  It's obviously
more broken in mmap-related code than just a buggered locking for counter
and it probably doesn't make much sense to patch just that one.  And I'll
have several more fixes of similar turds tomorrow, when mchehab finishes
testing videobuf ones.  Up to you, really.
