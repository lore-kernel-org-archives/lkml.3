Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3FXIIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:08:51 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:55981 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013Ab3FXIIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:08:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYPAM79x1F5LPX0/2dsb2JhbABbDoJ7gxa3dYUgBAF8F3SCIwEBBAE6HCgLCAMYCSUPBSUDIQESiAgFuRYWjhyBJINjA5dCkUWCUlAq
Date: Mon, 24 Jun 2013 18:08:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <esandeen@redhat.com>,
        Andreas Dilger <adilger@dilger.ca>, Namjae Jeon <linkinjeon@gmail.com>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "a.sangwan@samsung.com" <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Message-ID: <20130624080844.GR29338@dastard>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
 <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
 <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
 <20130624024459.GJ29376@dastard>
 <20130624031235.GA6991@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624031235.GA6991@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 11:12:35PM -0400, Theodore Ts'o wrote:
> On Mon, Jun 24, 2013 at 12:44:59PM +1000, Dave Chinner wrote:
> > 
> > Hence, at minimum, this should be a fallocate() operation, not a ext4
> > specific ioctl as it is relatively trivial to implement on most
> > extent based filesystems.
> 
> The fallocate() uses a units of bytes for the offset and length; would
> a FALLOC_FL_COLLAPSE_RANGE be guaranteed to work on any arbitrary
> offset and length?  Or would it only work if the offset and length are
> multiples of the file system blocksize?

There's nothing stopping us from restricting the offset/len to
specific alignments if the operation cannot be done on arbitrary
byte ranges. We do that for direct IO, and the sky hasn't fallen
yet.

> The the EXT4_IOC_TRUNCATE_BLOCK_RANGE interface solves this problem by
> using units of file system blocks (i.e., __u32 start_block), but that
> raises another issue, which is it forces the user space program to
> somehow figure out the file system block size, which seems a bit nasty.

Yeah, exactly. We can do that internally very easily, and EINVAL can
be returned when the alignment is bad just like we do for direct
IO...

But, well, I pine for a generic XFS_IOC_DIOINFO interface so the
filesystem can tell users about alignment restrictions....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
