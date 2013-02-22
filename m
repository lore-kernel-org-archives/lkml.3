Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3BVVNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:13:13 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:46343 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab3BVVNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:13:10 -0500
Date: Fri, 22 Feb 2013 21:13:08 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: perform WILLNEED readahead in a workqueue
Message-ID: <20130222211308.GA13037@dcvr.yhbt.net>
References: <20121215005448.GA7698@dcvr.yhbt.net>
 <20121216024520.GH9806@dastard>
 <5127A0A3.6040904@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5127A0A3.6040904@ubuntu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi <psusi@ubuntu.com> wrote:
> > On Sat, Dec 15, 2012 at 12:54:48AM +0000, Eric Wong wrote:
> >> "strace -T" timing on an uncached, one gigabyte file:
> >> 
> >> Before: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <2.484832> 
> >> After: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <0.000061>
> 
> It shouldn't take 2 seconds to queue up some async reads.  Are you
> using ext3?  The blocks have to be mapped in order to queue the reads,
> and without ext4 extents, this means the indirect blocks have to be
> read and can cause fadvise to block.

You're right, I originally tested on ext3.

I just tested an unpatched 3.7.9 kernel with ext4 and is much faster
(~250ms).  I consider ~250ms acceptable for my needs.  Will migrate
the rest of my setup to ext4 soon, thanks for the tip!
