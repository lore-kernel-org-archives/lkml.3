Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaFZUuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:50:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59269 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFZUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:50:53 -0400
Date: Thu, 26 Jun 2014 22:50:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tytso@mit.edu, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140626205049.GA11577@xo-6d-61-c0.localdomain>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626203052.GA9449@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-26 22:30:52, Pavel Machek wrote:
> Hi!
> 
> > Ok, this ext4 filesystem does _not_ have easy life: it is in usb envelope, I wanted
> > to use it as a root filesystem, and it is connected to OLPC-1.75, running some kind
> > of linux-3.0 kernels.
> > 
> > So power disconnects are common, and even during regular reboot, I hear disk doing
> > emergency parking.
> > 
> > I don't know how barriers work over USB...
> > 
> > Plus the drive has physical bad blocks, but I attempted to mark them with fsck -c.
> > 
> > OTOH, it is just a root filesystem... and nothing above should prevent correct operation
> > (right?)
> > 
> > On last mount, it remounted itself read-only, so there's time for fsck, I guess...
> > 
> > But I believe this means I am going to lose all the data on the filesystem, right?
> 
> It looks like the filesystem contains _way_ too many 0xffff's:
> 
> Inode 655221 has compression flag set on filesystem without compression support.  Clear<y>? yes
> 
> Inode 655221 has INDEX_FL flag set but is not a directory.
> Clear HTree index<y>? yes
...

And for every bug in kernel, there's one in fsck: I did not expect it, but fsck actually
suceeded, and marked fs as clean. But second fsck had issues with /lost+found...


-bash-4.1# fsck  /dev/sdc4 
fsck from util-linux-ng 2.18
e2fsck 1.41.12 (17-May-2010)
armroot: clean, 132690/985424 files, 1023715/3934116 blocks
-bash-4.1# fsck -f /dev/sdc4 
fsck from util-linux-ng 2.18
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
'..' in /lost+found/#652090/auth-for-pavel-wzJd6X (17) is /lost+found (11), should be /lost+found/#652090 (652090).
Fix<y>? yes

Pass 4: Checking reference counts
Pass 5: Checking group summary information

armroot: ***** FILE SYSTEM WAS MODIFIED *****
armroot: 132690/985424 files (0.1% non-contiguous), 1023715/3934116 blocks
-bash-4.1# 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
