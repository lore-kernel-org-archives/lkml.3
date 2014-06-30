Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaF3Gqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:46:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49400 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbaF3Gqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:46:47 -0400
Date: Mon, 30 Jun 2014 08:46:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140630064644.GA23079@amd.pavel.ucw.cz>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140629210428.GD2162@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-06-29 17:04:28, Theodore Ts'o wrote:
> On Sun, Jun 29, 2014 at 10:25:16PM +0200, Pavel Machek wrote:
> > 
> > One more thing that I noticed: fsck notices bad checksum on inode, and
> > then offers to fix the checksum with 'y' being the default. If there's
> > trash in the inode, that will just induce more errors. (Including
> > potentially doubly-linked blocks?) Would it make more sense to clear
> > the inodes with bad checksums?
> 
> Metadata checksums aren't in e2fsprogs 1.41 or 1.42.  It will be in
> the to-be-released e2fsprogs 1.43, and yes, we need to change things
> so that the default answer is to zero the inode.  We didn't do that
> initially because we were more suspicious of the new metadata checksum
> code in the kernel and e2fsprogs than we were of hardware faults.
> :-)

:-). Aha, and I misremembered, it was block descriptor checksums, not
inode checksums:

One or more block group descriptor checksums are invalid.  Fix? yes

Group descriptor 0 checksum is invalid.  FIXED.
Group descriptor 1 checksum is invalid.  FIXED.
Group descriptor 2 checksum is invalid.  FIXED.
Group descriptor 3 checksum is invalid.  FIXED.

I'm still trying to figure out what went wrong in the OLPC-1.75 + USB
disk case.

One possibility is that OLPC is unable to provide enough power from
the two USB ports to power Seagate Momentus 5400.6, and that the hard
drive fails to detect the brown-out and does something wrong. (Are
SATA drives expected to work at 4.5V? Because that's what is
guaranteed on USB, IIRC).

Heavy corruption happened when I was charging the phone _and_ running
the hard drive, from the OLPC. Now I have seen cases when OLPC crashed 
on device plug-in, in what looked like a brown-out...

Best regards,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
