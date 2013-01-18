Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3ARRQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3ARRQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:16:45 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 18 Jan 2013 12:16:35 -0500
In-Reply-To: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
	(Dave Kleikamp's message of "Wed, 9 Jan 2013 13:58:15 -0600")
Message-ID: <x49obgmif7w.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> This patchset was begun by Zach Brown and was originally submitted for
> review in October, 2009. Feedback was positive, and I have picked up
> where he left off, porting his patches to the latest mainline kernel
> and adding support more file systems.

[snip]

> My hopes are that this patchset is finally ready for linux-next.

Hi, Shaggy,

I'm finally getting around to testing this using xfstests.  This is my
setup:

dd if=/dev/zero of=testdev.img bs=1M count=1024
dd if=/dev/zero of=scratchdev.img bs=1M count=1024
losetup -f ./testdev.img
losetup -f ./scratchdev.img
mkfs -t xfs /dev/loop0
mount /dev/loop0 /mnt/test
export TEST_DIR=/mnt/test
export TEST_DEV=/dev/loop0
export SCRATCH_MNT=/mnt/scratch
export SCRATCH_DEV=/dev/loop1

I then ran:

./check -g aio

and here is the summary:

Ran: 112 113 198 207 208 209 210 211 212 239 240
Failures: 112 198 207 239 240
Failed 5 of 11 tests

To be fair, I have not yet run this on a kernel without your changes.
I'm going to do that next, but wanted to give you a heads-up, in case
you had time to dig into the failures.  Let me know if you want the full
output from the run, but I assume you'll want to reproduce this anyway.

Oh, I pulled your git branch into a 3.8.0-rc4 kernel tree, FYI.

Cheers,
Jeff
