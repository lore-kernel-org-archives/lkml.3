Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaFZUa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:30:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58042 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaFZUa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:30:56 -0400
Date: Thu, 26 Jun 2014 22:30:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tytso@mit.edu, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140626203052.GA9449@xo-6d-61-c0.localdomain>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Ok, this ext4 filesystem does _not_ have easy life: it is in usb envelope, I wanted
> to use it as a root filesystem, and it is connected to OLPC-1.75, running some kind
> of linux-3.0 kernels.
> 
> So power disconnects are common, and even during regular reboot, I hear disk doing
> emergency parking.
> 
> I don't know how barriers work over USB...
> 
> Plus the drive has physical bad blocks, but I attempted to mark them with fsck -c.
> 
> OTOH, it is just a root filesystem... and nothing above should prevent correct operation
> (right?)
> 
> On last mount, it remounted itself read-only, so there's time for fsck, I guess...
> 
> But I believe this means I am going to lose all the data on the filesystem, right?

It looks like the filesystem contains _way_ too many 0xffff's:

Inode 655221 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 655221 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 655221 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear<y>? yes

Inode 655221, i_size is 18446744073709551615, should be 0.  Fix<y>? yes

Inode 655221, i_blocks is 281474976710655, should be 0.  Fix<y>? yes

Inode 655222 is in use, but has dtime set.  Fix<y>? yes

Inode 655222 has imagic flag set.  Clear<y>? yes

Inode 655222 has a extra size (65535) which is invalid
Fix<y>? yes

Inode 655222 has compression flag set on filesystem without compression support.  Clear<y>? yes

Inode 655222 has INDEX_FL flag set but is not a directory.
Clear HTree index<y>? yes

Inode 655222 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear<y>? 

I saved beggining of the filesystem using cat /dev/sdc4 | gzip -9 - > /dev/sda3, but
then ran out of patience. So there may be something for analysis, but...

Any ideas?
										Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
