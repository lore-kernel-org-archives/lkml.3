Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaFZUU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:20:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57744 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaFZUUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:20:25 -0400
Date: Thu, 26 Jun 2014 22:20:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tytso@mit.edu, kernel list <linux-kernel@vger.kernel.org>
Subject: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Ok, this ext4 filesystem does _not_ have easy life: it is in usb envelope, I wanted
to use it as a root filesystem, and it is connected to OLPC-1.75, running some kind
of linux-3.0 kernels.

So power disconnects are common, and even during regular reboot, I hear disk doing
emergency parking.

I don't know how barriers work over USB...

Plus the drive has physical bad blocks, but I attempted to mark them with fsck -c.

OTOH, it is just a root filesystem... and nothing above should prevent correct operation
(right?)

On last mount, it remounted itself read-only, so there's time for fsck, I guess...

But I believe this means I am going to lose all the data on the filesystem, right?

Any idea what could have happened? It looks like garbage written over the filesystem, right?

I'm using devicemapper on another partition (for encrypted ext4). I feel I lost that filesystem,
too, but without root filesystem, I can't check it easily.

Any idea what to do so that it does not repeat?

Should I switch to plain ext2?
										Pavel

-bash-4.1# fsck /dev/sdc4 
fsck from util-linux-ng 2.18
e2fsck 1.41.12 (17-May-2010)
fsck.ext2: Superblock invalid, trying backup blocks...
Superblock has an invalid journal (inode 8).
Clear<y>? yes

*** ext3 journal has been deleted - filesystem is now ext2 only ***

One or more block group descriptor checksums are invalid.  Fix<y>? yes

Group descriptor 0 checksum is invalid.  FIXED.
Group descriptor 1 checksum is invalid.  FIXED.
Group descriptor 2 checksum is invalid.  FIXED.
Group descriptor 3 checksum is invalid.  FIXED.
Group descriptor 4 checksum is invalid.  FIXED.
Group descriptor 5 checksum is invalid.  FIXED.
Group descriptor 6 checksum is invalid.  FIXED.
Group descriptor 7 checksum is invalid.  FIXED.
Group descriptor 8 checksum is invalid.  FIXED.
Group descriptor 9 checksum is invalid.  FIXED.
Group descriptor 10 checksum is invalid.  FIXED.
Group descriptor 11 checksum is invalid.  FIXED.
Group descriptor 12 checksum is invalid.  FIXED.
Group descriptor 13 checksum is invalid.  FIXED.
Group descriptor 14 checksum is invalid.  FIXED.
Group descriptor 15 checksum is invalid.  FIXED.
Group descriptor 16 checksum is invalid.  FIXED.
Group descriptor 17 checksum is invalid.  FIXED.
Group descriptor 18 checksum is invalid.  FIXED.
Group descriptor 19 checksum is invalid.  FIXED.
Group descriptor 20 checksum is invalid.  FIXED.
Group descriptor 21 checksum is invalid.  FIXED.
Group descriptor 22 checksum is invalid.  FIXED.
Group descriptor 23 checksum is invalid.  FIXED.
Group descriptor 24 checksum is invalid.  FIXED.
Group descriptor 25 checksum is invalid.  FIXED.
Group descriptor 26 checksum is invalid.  FIXED.
Group descriptor 27 checksum is invalid.  FIXED.
Group descriptor 28 checksum is invalid.  FIXED.
Group descriptor 29 checksum is invalid.  FIXED.
Group descriptor 30 checksum is invalid.  FIXED.
Group descriptor 31 checksum is invalid.  FIXED.
Group descriptor 32 checksum is invalid.  FIXED.
Group descriptor 33 checksum is invalid.  FIXED.
Group descriptor 34 checksum is invalid.  FIXED.
Group descriptor 35 checksum is invalid.  FIXED.
Group descriptor 36 checksum is invalid.  FIXED.
Group descriptor 37 checksum is invalid.  FIXED.
Group descriptor 38 checksum is invalid.  FIXED.
Group descriptor 39 checksum is invalid.  FIXED.
Group descriptor 40 checksum is invalid.  FIXED.
Group descriptor 41 checksum is invalid.  FIXED.
Group descriptor 42 checksum is invalid.  FIXED.
Group descriptor 43 checksum is invalid.  FIXED.
Group descriptor 44 checksum is invalid.  FIXED.
Group descriptor 45 checksum is invalid.  FIXED.
Group descriptor 46 checksum is invalid.  FIXED.
Group descriptor 47 checksum is invalid.  FIXED.
Group descriptor 48 checksum is invalid.  FIXED.
Group descriptor 49 checksum is invalid.  FIXED.
Group descriptor 50 checksum is invalid.  FIXED.
Group descriptor 51 checksum is invalid.  FIXED.
Group descriptor 52 checksum is invalid.  FIXED.
Group descriptor 53 checksum is invalid.  FIXED.
Group descriptor 54 checksum is invalid.  FIXED.
Group descriptor 55 checksum is invalid.  FIXED.
Group descriptor 56 checksum is invalid.  FIXED.
Group descriptor 57 checksum is invalid.  FIXED.
Group descriptor 58 checksum is invalid.  FIXED.
Group descriptor 59 checksum is invalid.  FIXED.
Group descriptor 60 checksum is invalid.  FIXED.
Group descriptor 61 checksum is invalid.  FIXED.
Group descriptor 62 checksum is invalid.  FIXED.
Group descriptor 63 checksum is invalid.  FIXED.
Group descriptor 64 checksum is invalid.  FIXED.
Group descriptor 65 checksum is invalid.  FIXED.
Group descriptor 66 checksum is invalid.  FIXED.
Group descriptor 67 checksum is invalid.  FIXED.
Group descriptor 68 checksum is invalid.  FIXED.
Group descriptor 69 checksum is invalid.  FIXED.
Group descriptor 70 checksum is invalid.  FIXED.
Group descriptor 71 checksum is invalid.  FIXED.
Group descriptor 72 checksum is invalid.  FIXED.
Group descriptor 73 checksum is invalid.  FIXED.
Group descriptor 74 checksum is invalid.  FIXED.
Group descriptor 75 checksum is invalid.  FIXED.
Group descriptor 76 checksum is invalid.  FIXED.
Group descriptor 77 checksum is invalid.  FIXED.
Group descriptor 78 checksum is invalid.  FIXED.
Group descriptor 79 checksum is invalid.  FIXED.
Group descriptor 80 checksum is invalid.  FIXED.
Group descriptor 81 checksum is invalid.  FIXED.
Group descriptor 82 checksum is invalid.  FIXED.
Group descriptor 83 checksum is invalid.  FIXED.
Group descriptor 84 checksum is invalid.  FIXED.
Group descriptor 85 checksum is invalid.  FIXED.
Group descriptor 86 checksum is invalid.  FIXED.
Group descriptor 87 checksum is invalid.  FIXED.
Group descriptor 88 checksum is invalid.  FIXED.
Group descriptor 89 checksum is invalid.  FIXED.
Group descriptor 90 checksum is invalid.  FIXED.
Group descriptor 91 checksum is invalid.  FIXED.
Group descriptor 92 checksum is invalid.  FIXED.
Group descriptor 93 checksum is invalid.  FIXED.
Group descriptor 94 checksum is invalid.  FIXED.
Group descriptor 95 checksum is invalid.  FIXED.
Group descriptor 96 checksum is invalid.  FIXED.
Group descriptor 97 checksum is invalid.  FIXED.
Group descriptor 98 checksum is invalid.  FIXED.
Group descriptor 99 checksum is invalid.  FIXED.
Group descriptor 100 checksum is invalid.  FIXED.
Group descriptor 101 checksum is invalid.  FIXED.
Group descriptor 102 checksum is invalid.  FIXED.
Group descriptor 103 checksum is invalid.  FIXED.
Group descriptor 104 checksum is invalid.  FIXED.
Group descriptor 105 checksum is invalid.  FIXED.
Group descriptor 106 checksum is invalid.  FIXED.
Group descriptor 107 checksum is invalid.  FIXED.
Group descriptor 108 checksum is invalid.  FIXED.
Group descriptor 109 checksum is invalid.  FIXED.
Group descriptor 110 checksum is invalid.  FIXED.
Group descriptor 111 checksum is invalid.  FIXED.
Group descriptor 112 checksum is invalid.  FIXED.
Group descriptor 113 checksum is invalid.  FIXED.
Group descriptor 114 checksum is invalid.  FIXED.
Group descriptor 115 checksum is invalid.  FIXED.
Group descriptor 116 checksum is invalid.  FIXED.
Group descriptor 117 checksum is invalid.  FIXED.
Group descriptor 118 checksum is invalid.  FIXED.
Group descriptor 119 checksum is invalid.  FIXED.
Group descriptor 120 checksum is invalid.  FIXED.
armroot contains a file system with errors, check forced.
Resize inode not valid.  Recreate<y>? yes

Pass 1: Checking inodes, blocks, and sizes
Root inode is not a directory.  Clear<y>? yes

Reserved inode 3 (<The ACL index inode>) has invalid mode.  Clear<y>? yes

Inode 3 has a bad extended attribute block 46.  Clear<y>? yes

Inode 3 should not have EOFBLOCKS_FL set (size 439101102805825840, lblk -1)
Clear<y>? yes

Inode 3, i_size is 439101102805825840, should be 0.  Fix<y>? yes

Inode 3, i_blocks is 59567760357681, should be 0.  Fix<y>? yes




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
