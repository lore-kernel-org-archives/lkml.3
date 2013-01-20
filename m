Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3ATW0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:26:47 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37772 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab3ATW0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:26:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAdAF5u/FB5LETJ/2dsb2JhbABDuBuFEgKBBxdzgh4BAQU6HCMQCAMOCgklDwUlAyETiBi7CxWMd02Cf2EDlguJToZ8gwmBUw
Date: Mon, 21 Jan 2013 09:26:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20130120222640.GD2498@dastard>
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
 <x49obgmif7w.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49obgmif7w.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 12:16:35PM -0500, Jeff Moyer wrote:
> Dave Kleikamp <dave.kleikamp@oracle.com> writes:
> 
> > This patchset was begun by Zach Brown and was originally submitted for
> > review in October, 2009. Feedback was positive, and I have picked up
> > where he left off, porting his patches to the latest mainline kernel
> > and adding support more file systems.
> 
> [snip]
> 
> > My hopes are that this patchset is finally ready for linux-next.
> 
> Hi, Shaggy,
> 
> I'm finally getting around to testing this using xfstests.  This is my
> setup:
> 
> dd if=/dev/zero of=testdev.img bs=1M count=1024
> dd if=/dev/zero of=scratchdev.img bs=1M count=1024
> losetup -f ./testdev.img
> losetup -f ./scratchdev.img
> mkfs -t xfs /dev/loop0
> mount /dev/loop0 /mnt/test
> export TEST_DIR=/mnt/test
> export TEST_DEV=/dev/loop0
> export SCRATCH_MNT=/mnt/scratch
> export SCRATCH_DEV=/dev/loop1
> 
> I then ran:
> 
> ./check -g aio
> 
> and here is the summary:
> 
> Ran: 112 113 198 207 208 209 210 211 212 239 240
> Failures: 112 198 207 239 240
> Failed 5 of 11 tests

There's no need to limit xfstests to the aio group here. If the loop
device is what you are actually testing, then you probably want to
run the auto/quick groups as they will do a whole lot more than just
data IO to the loop devices...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
