Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3EIUeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:34:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34332 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3EIUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:34:30 -0400
Date: Thu, 9 May 2013 21:34:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] more vfs.git stuff
Message-ID: <20130509203428.GI25399@ZenIV.linux.org.uk>
References: <20130509192655.GG25399@ZenIV.linux.org.uk>
 <CA+55aFyCuksrVPwO=R_xX2An8qavo17aCZ5bfN=FWo1gZZfAsQ@mail.gmail.com>
 <20130509202815.GH25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509202815.GH25399@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 09:28:15PM +0100, Al Viro wrote:

> The only place checking that sucker is in a fairly large area protected by
> ->b_lock (in mon_bin_event()); I really don't want to dig deep enough to
> tell if having it changed right after it had been checked is safe.  OTOH,
> from a cursory look through that code it appears that the whole map_count
> thing is completely misguided - it seems to assume that ->open() is called for
> each VMA, including the one created by mmap(2).  Sigh...

Less cursory one shows that they do call their ->open() from their ->mmap().
OTOH, the code looking and ->mmap_active looks fishy - what happens if we
do allocation before mmap() happens?

Anyway, let's just drop that commit for now; it clearly needs more RTFS.
Could you pull for-linus^?
