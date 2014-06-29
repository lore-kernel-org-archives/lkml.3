Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaF2UZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 16:25:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33567 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaF2UZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 16:25:18 -0400
Date: Sun, 29 Jun 2014 22:25:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140629202516.GA11430@amd.pavel.ucw.cz>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627024659.GF6826@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > It looks like the filesystem contains _way_ too many 0xffff's:
> 
> That sounds like it's a hardware issue.  It may be that the controller
> did something insane while trying to do a write at the point when the
> disk drive was disconnected (and so the drive suffered a power
> drop).

Interesting. I tried to compare damaged image with the original, and
yes, way too many 0xffff. But they are not even block aligned? And
they start from byte 0... that area is not normally written, IIRC?

0000000 ffff ffff ffff ffff ffff ffff ffff ffff
*
0000030 ffff 07ff 0000 0000 0000 0000 0000 0000
0000040 0000 0000 0000 0000 0000 0000 0000 0000
*
00003f0 0000 0000 0000 0000 0000 ffff ffff ffff
0000400 ffff ffff ffff ffff ffff ffff 3e28 002d
0000410 fd57 000c ffff ffff ffff ffff ffff ffff
0000420 ffff ffff ffff ffff ffff ffff ffff ffff
*
0000550 ffff ffff ffff ffff 0000 0000 ffff ffff
0000560 ffff ffff ffff ffff ffff ffff ffff ffff
0000570 ffff ffff ffff ffff 4ddb 0055 0000 0000
0000580 ffff ffff ffff ffff ffff ffff ffff ffff
0000590 ffff ffff 007e 0000 ffff ffff ffff ffff
00005a0 ffff ffff ffff ffff ffff ffff ffff ffff
*
00005c0 ffff ffff ffff ffff ffff ffff 682e 53ac
00005d0 3a29 000a 0515 0000 d144 002e 0000 0000
00005e0 7865 3474 6d5f 7061 625f 6f6c 6b63 0073
00005f0 0000 0000 0000 0000 0000 0000 0000 0000
0000600 ffff ffff ffff ffff ffff ffff ffff ffff
*
0001000 41c0 03e9 1000 0000 6133 53ac 6133 53ac

> > And for every bug in kernel, there's one in fsck: I did not expect it, but fsck actually
> > suceeded, and marked fs as clean. But second fsck had issues with   /lost+found...
>  
> I'd need the previous fsck transcript to have any idea what might have
> happened.  I'll note though you are using an ancient version of e2fsck
> (1.41.12, and there have been a huge number of bug fixes since
> May 2010....)

Sorry for picking at fsck. No, it did quite a good job given
circumstances... and it probably does not make sense to debug old
version.

One more thing that I noticed: fsck notices bad checksum on inode, and
then offers to fix the checksum with 'y' being the default. If there's
trash in the inode, that will just induce more errors. (Including
potentially doubly-linked blocks?) Would it make more sense to clear
the inodes with bad checksums?

Thanks and best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
