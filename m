Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3FQShy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:37:54 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54907 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3FQShv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:37:51 -0400
Date: Mon, 17 Jun 2013 13:37:50 -0500
From: Ben Myers <bpm@sgi.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        Dave Chinner <david@fromorbit.com>
Subject: Re: XFS (vdb): Corruption detected. Unmount and run xfs_repair
Message-ID: <20130617183750.GI32736@sgi.com>
References: <20130615023620.GA23586@localhost>
 <20130615030928.GC29338@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615030928.GC29338@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Fengguang,

On Sat, Jun 15, 2013 at 01:09:28PM +1000, Dave Chinner wrote:
> [cc xfs@oss.sgi.com, where XFS bug reports should go]
> 
> On Sat, Jun 15, 2013 at 10:36:20AM +0800, Fengguang Wu wrote:
> > [   74.570969] XFS (vdb): bad magic number
> > [   74.573837] ffff8800170ed000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
				     X  F  S  B

That's the magic it's looking for...

> > [   74.579266] ffff8800170ed010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [   74.584581] ffff8800170ed020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [   74.590036] ffff8800170ed030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [   74.595386] XFS (vdb): Internal error xfs_sb_read_verify at line 730 of file /c/kernel-tests/src/stable/fs/xfs/xfs_mount.c.  Caller 0xffffffff81309514
> .....
> > [   74.692206] XFS (vdb): Corruption detected. Unmount and run xfs_repair
> > [   74.696000] XFS (vdb): SB validate failed with error 22.
> 
> It's obviously not an XFS filesystem you are asking the kernel to
> mount, so it's perfectly valid to throw a corruption error at you.
> What it has actually thrown is EWRONGFS, but because you've asked
> the kernel specifically to mount the device as an XFS filesystem,
> the kernel is explicitly telling you that it's a corrupt
> filesystem... :)

We did have an issue in this area in 3.7 which fixed in commit aeb4f20a that
made 3.8.  We were returning EFSCORRUPTED instead of EWRONGFS.  Maybe that's
not your kernel.

Regards,
	Ben
