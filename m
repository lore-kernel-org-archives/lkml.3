Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaGDKXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:23:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58059 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGDKXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:23:10 -0400
Date: Fri, 4 Jul 2014 12:23:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>,
        kernel list <linux-kernel@vger.kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: ext4: media error but where? 
Message-ID: <20140704102307.GA19252@amd.pavel.ucw.cz>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630134313.GA3753@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(Note that this drive is in thinkpad x60, and never met olpc or nor
had any problems).

pavel@duo:~$ uname -a
Linux duo 3.15.0-rc8+ #365 SMP Mon Jun 9 09:18:29 CEST 2014 i686
GNU/Linux

EXT4-fs (sda3): error count: 11
EXT4-fs (sda3): initial error at 1401714179: ext4_mb_generate_buddy:756
EXT4-fs (sda3): last error at 1401714179: ext4_reserve_inode_write:4877

That sounds like media error to me?

But there's nothing in smart:

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1

I rebooted (into 3.14), and fsck claims filesystem is marked as
clean...? I did fsck -f, no problems.

Heh, now fsck -cf runs, and I got the same kernel messages. fsck says:
"updating bad block inode", but it does not say how many badblocks it
found (if any). At the end it says "filesystem was modified" and
"reboot linux", so I assume it found something? OTOH dumpe2fs -b
/dev/sda3 does not report anything.

What is going on there?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
