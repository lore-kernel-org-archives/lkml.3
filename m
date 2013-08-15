Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3HOE37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 00:29:59 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36748 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab3HOE35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 00:29:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoFAOFYDFJ5LCJRgWdsb2JhbABavVKFWoEgFw4BARYmKIIkAQECAgE6HCMFCwgDDgoJJQ8FJQMhE4gKBbluFpA6B4QSA5djlQAq
Date: Thu, 15 Aug 2013 14:29:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Message-ID: <20130815042930.GO6023@dastard>
References: <520BB9EF.5020308@linux.intel.com>
 <20130815002436.GI6023@dastard>
 <20130815022401.GQ23412@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815022401.GQ23412@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 07:24:01PM -0700, Andi Kleen wrote:
> > And FWIW, it's no secret that XFS has more per-operation overhead
> > than ext4 through the write path when it comes to allocation, so
> > it's no surprise that on a workload that is highly dependent on
> > allocation overhead that ext4 is a bit faster....
> 
> This cannot explain a worse scaling curve though?

The scaling curve is pretty much identical. The difference in
performance will be the overhead of timestamp updates through
the transaction subsystems of the filesystems.

> w-i-s is all about scaling.

Sure, but scaling *what*? It's spending all it's time in the
filesystem through the .page_mkwrite path. It's not a page fault
scaling test - it's a filesystem overwrite test that uses mmap.
Indeed, I bet if you replace the mmap() with a write(fd, buf, 4096)
loop, you'd get almost identical behaviour from the filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
