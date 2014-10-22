Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaJVC6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:58:19 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42690 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaJVC6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:58:15 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 22 Oct 2014 11:58:39 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey <sergey@elementaryos.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141022025839.GC21620@bbox>
References: <1413881397.30379.7.camel@hadess.net>
 <loom.20141021T140216-28@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <loom.20141021T140216-28@post.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

About zram, pre-3.10 is really old. At that time, there were some trouble
in zram but I belive most of known bugs should fix since 3.14 merged
from staging and enhanced much so I suggest you try it with recent zram.
If you find a problem, let me know it.

Thanks.

On Tue, Oct 21, 2014 at 01:11:07PM +0000, Sergey wrote:
> Hey everyone,
> 
> I'm glad we're having some discussion on this, because we have almost
> exactly the same kernel wishlist internally for elementary OS / Pantheon DE.
> 
> I believe I can further elaborate on the VFS monitoring part. We need a file
> monitoring facility that's scalable (unlike inotify) and can provide a
> decent level of detail (unlike fanotify). In particular, we need to be able
> to detect file/directory creation, renaming and removal events, as well as
> close_write event. And, in an ideal world, all of that without requiring
> root permissions.
> 
> This can be almost accomplished by combining output of fanotify with that of
> a custom LSM module that just reports events to userspace (e.g. rlocate uses
> such a thing). There are two problems with this: first, it's a hideous hack,
> and second, it doesn't detect deletions.
> 
> This is a big deal because without it we're stuck with always presenting the
> user with the filesystem. If you've seen library-based music players like
> Rhythmbox or Banshee, you know that they group and sort all your music by
> artist and album, but not by directory and file name, and that you can
> efficiently search all that metadata. We're trying to get the same thing
> into more applications, but the absence of VFS features described above is
> blocking us. Even after moving all the database management to a single
> daemon that does all the monitoring and very rarely has to rescan anything,
> the system either slows to a crawl (inotify) or the database gets out of
> date quickly (fanotify+LSM). 
> In case I didn't make myself clear, a more detailed writeup on the design
> can be found here: http://tiny.cc/tearing-up-files
> 
> Regarding the other items, AFAIK the kernel implements mechanism, not
> policy, so instead of "zswap selectively enabled by default" we just want
> "stable reliable zswap". We had to give up on zram previously (in pre-3.10
> days) because of kernel regressions leading to panics when zram was enabled.
> And we don't have the "Power management" part on our list because we haven't
> really delved in that yet. But our lists are identical in all the other
> areas, so that's not "just GNOME".
> 
> PS: I'm not subscribed to LKML either, so please CC me.
> 
> Cheers!
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
