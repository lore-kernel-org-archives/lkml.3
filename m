Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3IYPpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:45:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab3IYPpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:45:03 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 0/2] Auto stop async-write on block device when device removed.
References: <201309171121559232246@gmail.com>
	<x49r4cfy4py.fsf@segfault.boston.devel.redhat.com>
	<201309241107330800706@gmail.com>
	<x4961tqwci6.fsf@segfault.boston.devel.redhat.com>
	<201309250932532670454@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 25 Sep 2013 11:44:58 -0400
In-Reply-To: <201309250932532670454@gmail.com> (majianpeng@gmail.com's message
	of "Wed, 25 Sep 2013 09:32:55 +0800")
Message-ID: <x49siwsewhx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

majianpeng <majianpeng@gmail.com> writes:

>>The bigger question is whether we want to change this long-standing
>>behaviour of how our write-back cache works.  I don't know that it's
>>really worth it, honestly.  If you want to ensure data is on disk, you
>>open the file O_SYNC or you issue an fsync, and those calls will return
>>an error for a removed block device.  So, I guess I'll ask the same
>>question again: why are you looking at this?  Is there some application
>>you care about that does buffered I/O to the block device and never does
>>an fsync?
>>
> Yes, for my company, we used our filesystem in userspace on block-device.
> For the performance, we used buffer-wrtite not sync-write.
> For my workload, we allow user to remove disk whether disk working or not.
> Now, we check the state of disk from /proc/partitions at the same interval.
>
> This patchset don't change write-back cache works.It only let vfs know
> the state of lower-device.  I think it make a sense.

I'm still curious to know how you maintain a consistent file system
without the use of fsync, but that's an unrelated issue.

I looked at the rescan partition code path more closely, and it will
only really trigger if the partitions themselves aren't open.  So, I
don't think there is a problem in your approach.

I'll ack patch 1.  I still think patch 2 is not neessary.  Please
correct me if I'm wrong.

Cheers,
Jeff
