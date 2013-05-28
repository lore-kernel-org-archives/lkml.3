Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3E1VPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:15:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab3E1VPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:15:51 -0400
Date: Tue, 28 May 2013 17:15:44 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.10-rc3 xfs mount/recovery failure & ext fsck hang.
Message-ID: <20130528211544.GB24342@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130528161230.GA7577@redhat.com>
 <20130528211012.GX29466@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528211012.GX29466@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 07:10:12AM +1000, Dave Chinner wrote:
 > On Tue, May 28, 2013 at 12:12:30PM -0400, Dave Jones wrote:
 > > box crashed, and needed rebooting. On next bootup, when it found the dirty partition,
 > > xfs chose to spew and then hang instead of replaying the journal and mounting :(
 > > 
 > > [   14.694731] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
 > > [   14.722328] XFS (sda2): Mounting Filesystem
 > > [   14.757801] XFS (sda2): Starting recovery (logdev: internal)
 > > [   14.782049] XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 169
 > 
 > A directory block has an entry that is not in the hash index.
 > Either there's an underlying corruption on disk, or there's an
 > inconsistency in what has been logged and so an entire change has
 > not been replayed. Hence the post recovery verification has thrown a
 > corruption error....
 > 
 > If you haven't already repaired the filesystem, can you send me a
 > metadump of the filesystem in question?

Sorry, too late. If I can repro, I'll do so next time.
FYI, I ran xfs_repair and it just hung. Wouldn't even answer ctrl-c.
Rebooted, and then it mounted and recovered just fine!
 
 > > [   40.642521] BUG: soft lockup - CPU#0 stuck for 22s! [fsck.ext2:294]
 > 
 > I'm not sure what this has to do with the XFS problem - it's
 > apparently stuck in invalidate_bh_lrus() walking a CPU mask....

there for completion, it was sandwiched between the other xfs bits :)

	Dave

