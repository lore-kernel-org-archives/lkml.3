Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaDWCSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:18:39 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:10383 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbaDWCSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:18:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq9xAKUiV1N5LEcvPGdsb2JhbABYgwaIbqMFmWeBExcDAQEBATg1giUBAQQBOhwjBQsIAxgJJQ8FJQMHGhOIOQfPQxcWjVwiQgeEOASYb5RFgVErgSwCHg
Date: Wed, 23 Apr 2014 12:18:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Speedy Milan <speedy.milan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ivan Pantovic <gyro.ivan@gmail.com>,
        xfs@oss.sgi.com
Subject: Re: rm -f * on large files very slow on XFS + MD RAID 6 volume of
 15x 4TB of HDDs (52TB)
Message-ID: <20140423021835.GI15995@dastard>
References: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc xfs@oss.sgi.com]

On Mon, Apr 21, 2014 at 10:58:53PM +0200, Speedy Milan wrote:
> I want to report very slow deletion of 24 50GB files (in total 12 TB),
> all present in the same folder.

total = 1.2TB?

> OS is CentOS 6.4, with upgraded kernel 3.13.1.
> 
> The hardware is a Supermicro server with 15x 4TB WD Se drives in MD
> RAID 6, totalling 52TB of free space.
> 
> XFS is formated directly on the RAID volume, without LVM layers.
> 
> Deletion was done with rm -f * command, and it took upwards of 1 hour
> to delete the files.
> 
> File system was filled completely prior to deletion.

Oh, that's bad. it's likely you fragmented the files into
millions of extents?

> rm was mostly waiting (D state), probably for kworker threads, and

No, waiting for IO.

> iostat was showing big HDD utilization numbers and very low throughput
> so it looked like a random HDD workload was in effect.

Yup, smells like file fragmentation. Non-fragmented 50GB files
should be removed in a few milliseconds. but if you've badly
fragmented the files, there could be 10 million extents in a 50GB
file. A few milliseconds per extent removal gives you....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
