Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaKGJKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:10:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaKGJKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:10:36 -0500
Date: Fri, 7 Nov 2014 10:10:26 +0100
From: Karel Zak <kzak@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/5] brd: Request from fdisk 4k alignment
Message-ID: <20141107091026.GG6880@x2.net.home>
References: <545A2D69.8090003@plexistor.com>
 <545A2F52.3040303@plexistor.com>
 <yq1k339enl5.fsf@sermon.lab.mkp.net>
 <545A379D.30608@plexistor.com>
 <yq1sihwb5qz.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1sihwb5qz.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:25:56PM -0500, Martin K. Petersen wrote:
> >>>>> "Boaz" == Boaz Harrosh <boaz@plexistor.com> writes:
> 
> Boaz,
> 
> Boaz> Note that blk_queue_physical_block_size() also trashes io_min, but
> Boaz> we can leave this one to be 512. io_min as opposed to
> Boaz> physical_block_size will actually change Kernel behavior
> 
> >> Care to elaborate?
> 
> I wanted you to elaborate on how io_min changes kernel behavior.
> 
> >> Also, fdisk and parted should be aligning on 1MB by default
> >> regardless of block size. So I'm also not sure why you need to trick
> >> fdisk to align by setting the pbs.
> 
> Boaz> fdisk will not align partition-start on 1M, only the very
> Boaz> first-sector, libgparted and cfdisk are as you say, but with fdisk
> Boaz> if you put any odd numbered partition-size, the next start-sector
> Boaz> will just be the sum, but with this patch it will offer a small
> Boaz> hole and will align the partition-start on 4K.  (And even with
> Boaz> this patch user can enter bad values)
> 
> It really sounds like either your fdisk is way too old or you are
> running it in DOS compat mode.
> 
> I don't have a fundamental issue reporting pbs of 4K. But if you are
> only doing it to force a certain partition alignment then it sounds like
> a kernel fix for a userland problem.
> 
> I've CC:ed Karel who can comment on fdisk partition alignment issues.

fdisk by default aligns partitions and uses 1MiB offset (for first
primary and all logical partitions). It's low-level tool for experts,
so if you ask for non-aligned offsets it will follow your wishes of
course. The default values in dialogs are always aligned. All
misaligned partitions are always reported (by warning messages).

Boaz, it would be nice to have any example (copy & past fdisk output).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
