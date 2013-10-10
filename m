Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3JJDii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 23:38:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:41343 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3JJDih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 23:38:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1068,1371106800"; 
   d="scan'208";a="408625570"
Date: Thu, 10 Oct 2013 11:38:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
 pointer dereference at 00000003
Message-ID: <20131010033834.GA13141@localhost>
References: <20131009073910.GA387@localhost>
 <20131010005900.GE2025@devil.localdomain>
 <20131010011640.GA5726@localhost>
 <20131010014117.GA6017@localhost>
 <20131010031515.GT4446@dastard>
 <20131010032637.GA12725@localhost>
 <20131010033300.GA12952@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010033300.GA12952@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:33:00AM +0800, Fengguang Wu wrote:
> On Thu, Oct 10, 2013 at 11:26:37AM +0800, Fengguang Wu wrote:
> > Dave,
> > 
> > > I note that you have CONFIG_SLUB=y, which means that the cache slabs
> > > are shared with objects of other types. That means that the memory
> > > corruption problem is likely to be caused by one of the other
> > > filesystems that is probing the block device(s), not XFS.
> > 
> > Good to know that, it would easy to test then: just turn off every
> > other filesystems. I'll try it right away.
> 
> Seems that we don't even need to do that. A dig through the oops
> database and I find stack dumps from other FS.
> 
> This happens in the kernel with same kconfig and commit 3.12-rc1.

Here is a summary of all FS with oops:

    411 ocfs2_fill_super
    189 xfs_fs_fill_super
     86 jfs_fill_super
     50 isofs_fill_super
     33 fat_fill_super
     18 vfat_fill_super
     15 msdos_fill_super
     11 ext2_fill_super
     10 ext3_fill_super
      3 reiserfs_fill_super

Thanks,
Fengguang
