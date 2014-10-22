Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910AbaJVUi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:38:57 -0400
Received: from mout-xforward.gmx.net ([82.165.159.41]:63281 "EHLO
	mout-xforward.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaJVUi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:38:56 -0400
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 16:38:55 EDT
Message-ID: <54481091.3030306@gmx.de>
Date: Wed, 22 Oct 2014 22:16:17 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Sergey <sergey@elementaryos.org>, linux-kernel@vger.kernel.org
CC: Jan Kara <jack@suse.cz>, Bastien Nocera <hadess@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
References: <1413881397.30379.7.camel@hadess.net> <loom.20141021T140216-28@post.gmane.org>
In-Reply-To: <loom.20141021T140216-28@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:tlf+Ndc4I6lm0KvS/aCbN15D5JY2Z4hAtIyDpAPxL4NZ/ygX8jv
 BZd4LKiUZlLHXQmRGQuFa6i7RDSSJlAD26266HW4cNYvYZGALg5PwZroBFvbtNDkeGt/fKg
 uoKvwgMiZ1KY2VUcemzwi/fGowtWKay8jKSPSMw4wqWsN068t4D5Mgh0nyuszTQpIhnAVNp
 ud8GO15+BVk7i7SDbWx0g==
X-UI-Out-Filterresults: junk:10;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2014 15:11, Sergey wrote:
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
When I read your wish, I guess adding the capability to watch mounts 
with inotify would satisfy your needs. Would you agree?

Best regards

Heinrich Schuchardt
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
>

