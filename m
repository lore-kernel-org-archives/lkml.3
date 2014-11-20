Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbaKTPPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:15:02 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:36097 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaKTPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:15:00 -0500
Date: Thu, 20 Nov 2014 10:14:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHSET block/for-next] writeback: prepare for cgroup
 writeback support
Message-ID: <20141120151456.GE14877@htj.dyndns.org>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
 <20141120151311.GE2330@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120151311.GE2330@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:13:11PM +0100, Jan Kara wrote:
> On Tue 18-11-14 03:37:18, Tejun Heo wrote:
> > Hello,
> > 
> > This patchset contains the following 10 prepatory patches for cgroup
> > writeback support.  None of these patches introduces behavior changes.
> > 
> >  0001-writeback-move-backing_dev_info-state-into-bdi_write.patch
> >  0002-writeback-move-backing_dev_info-bdi_stat-into-bdi_wr.patch
> >  0003-writeback-move-bandwidth-related-fields-from-backing.patch
> >  0004-writeback-move-backing_dev_info-wb_lock-and-worklist.patch
> >  0005-writeback-move-lingering-dirty-IO-lists-transfer-fro.patch
> >  0006-writeback-reorganize-mm-backing-dev.c.patch
> >  0007-writeback-separate-out-include-linux-backing-dev-def.patch
> >  0008-writeback-cosmetic-change-in-account_page_dirtied.patch
> >  0009-writeback-add-gfp-to-wb_init.patch
> >  0010-writeback-move-inode_to_bdi-to-include-linux-backing.patch
> > 
> > 0001-0005 move writeback related fields from bdi (backing_dev_info) to
> > wb (bdi_writeback).  Currently, one bdi embeds one wb and the
> > separation between the two is blurry.  bdi's lock protects wb's fields
> > and fields which are closely related are scattered across the two.
> > These five patches move all fields which are used during writeback
> > into wb.
> > 
> > 0006-0010 are misc prep patches.  They're all rather trivial and each
> > is self-explanatory.
> > 
> > This patchset is on top of the current block/for-next eb494facbee2
> > ("5748c0fce0fd40c87d164d6bee61") and is available in the following git
> > branch.
>   I have no problem with these patches in principle (I'll check individual
> patches in detail) but do you have some higher level design where exactly
> are you going?

Yeah, I'm prepping the actual patchset and it'll go out with high
level description.  Just wanted to send out the prep ones separately
to reduce the patchset to a manageable size.

> PS: I've added CC to linux-fsdevel since there's high chance people miss
> these patches in lkml...

Will do so when posting the actual series.

Thanks.

-- 
tejun
