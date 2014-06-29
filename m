Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaF2VEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 17:04:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:35812 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbaF2VEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 17:04:33 -0400
Date: Sun, 29 Jun 2014 17:04:28 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
Message-ID: <20140629210428.GD2162@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
 <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140629202516.GA11430@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 10:25:16PM +0200, Pavel Machek wrote:
> 
> One more thing that I noticed: fsck notices bad checksum on inode, and
> then offers to fix the checksum with 'y' being the default. If there's
> trash in the inode, that will just induce more errors. (Including
> potentially doubly-linked blocks?) Would it make more sense to clear
> the inodes with bad checksums?

Metadata checksums aren't in e2fsprogs 1.41 or 1.42.  It will be in
the to-be-released e2fsprogs 1.43, and yes, we need to change things
so that the default answer is to zero the inode.  We didn't do that
initially because we were more suspicious of the new metadata checksum
code in the kernel and e2fsprogs than we were of hardware faults.  :-)

Cheers,

						- Ted
