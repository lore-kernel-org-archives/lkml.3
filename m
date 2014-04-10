Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030687AbaDJWwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:52:43 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:22351 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030537AbaDJWwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:52:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkxaAOsfR1N5LEcvPGdsb2JhbABagwaIWbcNhV2BIxcDAQEBATg1giUBAQEEOhwjEAgDGAklDwUlAwcaE4d7zGgXFo5WB4MkgRQEmF2KZIshKw
Date: Fri, 11 Apr 2014 08:52:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs i_lock vs mmap_sem lockdep trace.
Message-ID: <20140410225234.GF27519@dastard>
References: <20140329223109.GA24098@redhat.com>
 <20140330234335.GB16336@dastard>
 <20140330235717.GO18016@ZenIV.linux.org.uk>
 <20140331004053.GA17603@dastard>
 <53445EC0.9060707@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53445EC0.9060707@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 04:40:32PM -0400, Sasha Levin wrote:
> On 03/30/2014 08:40 PM, Dave Chinner wrote:
> > On Mon, Mar 31, 2014 at 12:57:17AM +0100, Al Viro wrote:
> >> > On Mon, Mar 31, 2014 at 10:43:35AM +1100, Dave Chinner wrote:
> >>> > > filldir on a directory inode vs page fault on regular file. Known
> >>> > > issue, definitely a false positive. We have to change locking
> >>> > > algorithms to avoid such deficiencies of lockdep (a case of "lockdep
> >>> > > considered harmful", perhaps?) so it's not something I'm about to
> >>> > > rush...
> >> > 
> >> > Give i_lock on directories a separate class, as it's been done for i_mutex...
> > Already done that. Commit:
> > 
> > 93a8614 xfs: fix directory inode iolock lockdep false positive
> 
> Hi Dave,
> 
> The commit above introduces a new lockdep issue for me:

Right, it's fixed one class of false positive which uncovers the
next class of false positive. lockdep gives me the shits at times
because every time we make some obviously correct locking change
to the XFS inodes we then spend the next 3-4 kernel releases chasing
down and annotating locks so that lockdep doesn't throw false
positives everywhere.

It's on my queue of things to fix but, quite frankly, lockdep false
positives are low priority to fix right now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
