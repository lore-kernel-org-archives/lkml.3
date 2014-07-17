Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaGQScF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:32:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbaGQScD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:32:03 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] block_dev: implement readpages() to optimize sequential read
References: <1405606659-3802-1-git-send-email-akinobu.mita@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 17 Jul 2014 14:31:56 -0400
In-Reply-To: <1405606659-3802-1-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Thu, 17 Jul 2014 23:17:39 +0900")
Message-ID: <x49pph325wj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akinobu Mita <akinobu.mita@gmail.com> writes:

> Sequential read from a block device is expected to be equal or faster
> than from the file on a filesystem.  But it is not correct due to the
> lack of effective readpages() in the address space operations for
> block device.

Ah, a trip down memory lane.  ;-)  Here's a thread showing issues with
the last time this was proposed (by me, incidentally):

https://lkml.org/lkml/2009/6/2/480

At the very least, we need to see numbers on a real device, and see it
booted on something with >4k page size before taking this back in.

Cheers,
Jeff
