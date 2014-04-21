Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaDUORK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:17:10 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:41759 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaDUORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:17:08 -0400
X-Greylist: delayed 856 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 10:17:07 EDT
Date: Mon, 21 Apr 2014 10:02:46 -0400
From: Rich Felker <dalias@libc.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421140246.GB26358@brightrain.aerifal.cx>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 09:45:35AM -0400, Jeff Layton wrote:
> File-private locks have been merged into Linux for v3.15, and *now*
> people are commenting that the name and macro definitions for the new
> file-private locks suck.
> 
> ....and I can't even disagree. The names and command macros do suck.
> 
> We're going to have to live with these for a long time, so it's
> important that we be happy with the names before we're stuck with them.
> 
> The consensus on the lists so far is that they should be rechristened as
> "file-description locks".
> 
> This patch makes the following changes that I think are necessary before
> v3.15 ships:
> 
> 1) rename the command macros to their new names. These end up in the uapi
>    headers and so are part of the external-facing API. It turns out that
>    glibc doesn't actually use the fcntl.h uapi header, but it's hard to
>    be sure that something else won't. Changing it now is safest.
> 
> 2) make the the /proc/locks output display these as type "FDLOCK"
> 
> The rest of the renaming can wait until v3.16, since everything else
> isn't visible outside of the kernel.

I'm sorry I didn't chime in on this earlier, but I really prefer the
(somewhat bad) current naming ("private") to the
ridiculously-confusing use of "FD" to mean "file descriptION" when
everybody is used to it meaning "file descriptOR". The potential for
confusion that these are "file descriptOR locks" (they're not) is much
more of a problem, IMO, than the confusion about what "private" means
(since it doesn't have an established meaning in this context.

Thus my vote is for leaving things the way the kernel did it already.

Rich
