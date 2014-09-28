Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaI1KpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:45:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38949 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaI1KpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:45:00 -0400
Date: Sun, 28 Sep 2014 12:44:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu,
        kernel list <linux-kernel@vger.kernel.org>, adilger.kernel@dilger.ca
Subject: ext4: 3.17? problems
Message-ID: <20140928104456.GA17400@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After update to debian testing, my machine sometimes fails to
reboot. (aptitude upgrade seems to be the trigger).

So I had to hard power-down the machine. That should be perfectly
safe, as ext4 has a journal, and this is plain SATA disk, right?

On next boot to Debian stable, I got stacktrace, and messages about
ext4 corruption. Back to Debian testing. systemd ran fsck, determined
it can't fix it, dropped me into emergency shell, _but mounted the
filesstem, anyway_. Oops.

Now I'm getting

fsck 1.42.12
...
Inodes that were part of a corrupted orphan linked list found <y>
Deleted inode has zero dtime <y>
(6 inodes) was part of the orphaned inode list. FIXED.
Block bitmap differences.
Free inode counts wrong.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
