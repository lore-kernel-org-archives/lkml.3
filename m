Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaJ0JXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:23:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47940 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaJ0JXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:23:16 -0400
Date: Mon, 27 Oct 2014 10:23:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sergey <sergey@elementaryos.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141027092311.GA9807@amd>
References: <1413881397.30379.7.camel@hadess.net>
 <loom.20141021T140216-28@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20141021T140216-28@post.gmane.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-10-21 13:11:07, Sergey wrote:
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

And third, it will eat unbounded ammounts of memory, right?

If "recursive mtime" was available, would that work for you?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
