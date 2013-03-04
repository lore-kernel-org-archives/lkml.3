Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab3CDVDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:03:17 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44179 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717Ab3CDVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:03:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhshAAsLNVF5Layr/2dsb2JhbABEvTuFFQECAYEIF3OCHwEBBAEnExwjBQsIAw4KCSUPBSUDIROIDQWyPo8xFY12GB9KB4NAA5ZFiWWHCIMc
Date: Tue, 5 Mar 2013 08:03:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tony Lu <zlu@tilera.com>
Cc: Mark Tinguely <tinguely@sgi.com>, Alex Elder <elder@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>,
        Dave Chinner <dchinner@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Fix possible truncation of log data in
 xlog_bread_noalign()
Message-ID: <20130304210311.GQ23616@dastard>
References: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
 <20130223000802.GB26081@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C48702@USMAExch1.tad.internal.tilera.com>
 <20130223235546.GA5551@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C488D8@USMAExch1.tad.internal.tilera.com>
 <20130224141017.GC5551@dastard>
 <BAB94DBB0E89D8409949BC28AC95914C47C49005@USMAExch1.tad.internal.tilera.com>
 <5130CE9E.9080501@sgi.com>
 <51310E7A.1000905@sgi.com>
 <BAB94DBB0E89D8409949BC28AC95914C47C4C19C@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C47C4C19C@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 08:32:45AM +0000, Tony Lu wrote:
> Thanks for you following up.
> 
> My apologize that I just found that it is one change I made before
> that causes this problem. This change forces mkfs.xfs to format
> xfs partitions whose sectorsize were not smaller than 4096 bytes,
> which was due to a bug that earlier versions of xfs used (struct
> *page)->private(long) as a bitmap to represent each block's state
> within a page (the size of a page could be 64K or larger, then it
> needs 128 bit or more to represent each block's state within a
> page).

You do realise that bug doesn't affect x86-64 platforms as they
don't support 64k pages?

> This is reproducible on 2.6.38.6 kernel on X86. But I do not get
> why this change makes the xfs log inconsistent during
> mount/cp/umount operations.

Neither do I, and I don't care to look any further because the
problem is of your own making. In future, please check first that
the bug you are reporting is reproducable on a current upstream
kernel and userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
