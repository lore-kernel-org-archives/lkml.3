Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaI2Jgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:36:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38391 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaI2Jgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:36:48 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu,
        kernel list <linux-kernel@vger.kernel.org>, adilger.kernel@dilger.ca
Subject: Re: ext4: 3.17? problems
In-Reply-To: <20140928104456.GA17400@amd>
References: <20140928104456.GA17400@amd>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 29 Sep 2014 13:36:43 +0400
Message-ID: <87iok6ojis.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2014 12:44:56 +0200, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
> 
> After update to debian testing, my machine sometimes fails to
> reboot. (aptitude upgrade seems to be the trigger).
> 
> So I had to hard power-down the machine. That should be perfectly
> safe, as ext4 has a journal, and this is plain SATA disk, right?
> 
AFAIU you have some corruption on your fs (the root of cause is unknown
at this moment)
So you have following stages:
1) fs corruption
2) boot-> mount attempt
3) fsck
During (1) Once ext4 driver found this error it will call ext4_error
which will tag sb with FS_ERROR flag.
During (2) it will found that tag and clear s_orphan which result
in complain you have seen  during(3)

My idea is that (2) and (3) is consequences of (1).
Please provide more details(dmsg) about initial error.
> On next boot to Debian stable, I got stacktrace, and messages about
> ext4 corruption. Back to Debian testing. systemd ran fsck, determined
> it can't fix it, dropped me into emergency shell, _but mounted the
> filesstem, anyway_. Oops.
> 
> Now I'm getting
> 
> fsck 1.42.12
> ...
> Inodes that were part of a corrupted orphan linked list found <y>
> Deleted inode has zero dtime <y>
> (6 inodes) was part of the orphaned inode list. FIXED.
> Block bitmap differences.
> Free inode counts wrong.
> 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
