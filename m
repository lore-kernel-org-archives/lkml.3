Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3IWOsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab3IWOsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:48:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 0/2] Auto stop async-write on block device when device removed.
References: <201309171121559232246@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Sep 2013 10:47:53 -0400
In-Reply-To: <201309171121559232246@gmail.com> (majianpeng@gmail.com's message
	of "Tue, 17 Sep 2013 11:21:58 +0800")
Message-ID: <x49r4cfy4py.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

majianpeng <majianpeng@gmail.com> writes:

> For async-write on block device,if device removed,but the vfs don't know it.
> It will continue to do.
> Patch1 set size of inode of block device to zero when removed disk.By this,vfs know 
> disk changed.
> Path2 add size-check on blk_aio_write.If pos of write larger than size of inode,it will
> return zero.So the user can check disk state.

OK, so the basic problem is that __generic_file_aio_write will always
return 0 after device removal, yes?  I'm not sure why that's a real
issue, can you explain exactly why you're trying to change this?

As for your patches, I don't think that putting the i_size_write into
invalidate_partitions is a good idea.  Consider the case of rescanning
partitions: you will always detect a size change now, which is not good.

Cheers,
Jeff
