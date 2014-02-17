Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaBQAB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:01:27 -0500
Received: from imap.thunk.org ([74.207.234.97]:58708 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbaBQABZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:01:25 -0500
Date: Sun, 16 Feb 2014 19:01:17 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Kalpak Shah <kalpak@clusterfs.com>, Andreas Dilger <adilger@clusterfs.com>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ext4 info leak in creation times in latest mainline
Message-ID: <20140217000117.GC12947@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Kalpak Shah <kalpak@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <5300DEC5.2080908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5300DEC5.2080908@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 04:52:37PM +0100, Vegard Nossum wrote:
> There seems to be a bug in ext4 where the i_crtime of struct
> ext4_inode_info is not initialised, so (some) creation times contain
> essentially random values....
> 
> I don't know if it's relevant, but the filesystem is actually ext3
> mounted using ext4. It's 100% reproducible for me, so I can test
> patches.

Thanks for the bug report.  I see the problem; it was indeed relevant
that this was an ext3 file systmem mounted as ext4.  The first time
when an ext3 inode is read by ext4, i_extra_isize is too small, and so
there is no i_crtime field.  The bug is in EXT4_EINODE_GET_XTIME() (in
ext4.h, where it is leaving ei->i_crtime.tv_sec uninitialized.

It's an easy fix.  I'll send out a patch shortly.

Cheers,

						- Ted
