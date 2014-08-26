Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaHZRZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaHZRZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:25:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Joe Lawrence <joe.lawrence@stratus.com>
Cc: <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 26 Aug 2014 13:24:54 -0400
In-Reply-To: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com> (Joe
	Lawrence's message of "Wed, 2 Jul 2014 15:35:15 -0400")
Message-ID: <x49egw36u55.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:

> v2->v3: rebase to 3.16-rc2, consider return values from the
>         blk_mq_alloc_request leg of the blk_get_request callchain
>         (noted by Jeff), noted in the second patch changelog.
>
> 	blk_mq_queue_enter may return 0 or errno, which
>         blk_mq_alloc_request can propogate out via ERR_PTR.
> 	__blk_mq_alloc_request doesn't include any blk_queue_dying
> 	checks, so I'm assuming that its failures can be attributed
>         to -EWOULDBLOCK under !GFP_WAIT conditions.
>
> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
>         tags.
>
> Joe Lawrence (2):
>   block,scsi: verify return pointer from blk_get_request
>   block,scsi: fixup blk_get_request dead queue scenarios

Jens,

Did this patch set fall through the cracks again?

Cheers,
Jeff
