Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423770Ab3FUTgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:36:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50770 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423743Ab3FUTgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:36:04 -0400
Date: Fri, 21 Jun 2013 21:36:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        kernel list <linux-kernel@vger.kernel.org>
Subject: f2fs tests
Message-ID: <20130621193600.GA12712@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I played a bit with f2fs...

First, I had to compile the f2fstools... Unfortunately they require
never autoconf than available on debian. I tried to hack it, but then
I decided that compiling it by hand is just simpler.

gcc -I include/ -I . lib/*.c mkfs/*.c /usr/lib/libuuid.so

does the trick.

I was quite surprised there's no fsck in the repository... Do you have
fsck somewhere?

I tested with copy of kernel and 4GB stick (with RedHat logo, thanks
:-)... copying it from hdd took 46 minutes for VFAT and 19 minutes for
F2FS. Good.

VFAT: time find . -name "not-here" took 26 seconds.
F2F:  time find . -name "not-here" took 22-24 seconds.

Faster copy, same speed find, good. (Find is even slightly faster than
HDD, with 27-30 seconds).

But now the strange stuff: the same data takes 861MB on ext3 and 1.3GB
on f2fs. (It was even bigger than that on VFAT). I guess I should test
the patch for inlining small files into inodes?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
