Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3HTEJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:09:03 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:2311 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293Ab3HTEJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:09:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmMHADPrElJ5LJ62/2dsb2JhbABagwWDN7dHhTuBIRd0giQBAQU6HCMQCAMOCgklDwUlAyETiA+rOxaQRgeEEgOXY5FWgy4q
Date: Tue, 20 Aug 2013 14:08:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 5/5] ext4: Defer mmap cmtime update until writeback
Message-ID: <20130820040857.GI6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
 <d59d6c9790bd3c36b93343ed91be5e0cda7e5f09.1376679411.git.luto@amacapital.net>
 <20130820023849.GF6023@dastard>
 <CALCETrU_e309onJKGg4EK2EyiZWCjNROsw83+VAK=2i_FVLWYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU_e309onJKGg4EK2EyiZWCjNROsw83+VAK=2i_FVLWYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 08:30:02PM -0700, Andy Lutomirski wrote:
> On Mon, Aug 19, 2013 at 7:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Aug 16, 2013 at 04:22:12PM -0700, Andy Lutomirski wrote:
> >> A fancier implementation could probably avoid an extra journal
> >> transaction by adding a mapping_test_clear_cmtime call in
> >> ext4_writepages, but this should already be a considerable
> >> improvement -- we'll start one transaction per writepages call
> >> instead of one per page.
> >
> > I'd like to see more than just an ext4 implementation - btrfs and
> > XFS are the other main filesystems that should behave identically.
> 
> Will do.
> 
> >
> > Also, it's worthwhile to write a generic xfstest to ensure that they
> > all update the timestamp appropriately - if its' in xfstests, then
> > we can basically guarantee that it won't get randomly regressed in
> > future, and other filesystems can be easily verified as well sa
> > their implement this.
> >
> 
> Is there a guide to writing an xfstest?

Yes. see the readme file in the root directory of the repository.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
