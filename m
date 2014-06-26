Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbaFZPhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:37:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbaFZPhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:37:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] cfq: Increase default value of target_latency
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
	<1403683129-10814-7-git-send-email-mgorman@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 26 Jun 2014 11:36:50 -0400
In-Reply-To: <1403683129-10814-7-git-send-email-mgorman@suse.de> (Mel Gorman's
	message of "Wed, 25 Jun 2014 08:58:49 +0100")
Message-ID: <x491tub65t9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> The existing CFQ default target_latency results in very poor performance
> for larger numbers of threads doing sequential reads. While this can be
> easily described as a tuning problem for users, it is one that is tricky
> to detect. This patch updates the default to benefit smaller machines.
> Dave Chinner points out that it is dangerous to assume that people know
> how to tune their IO scheduler. Jeff Moyer asked what workloads even
> care about threaded readers but it's reasonable to assume file,
> media, database and multi-user servers all experience large sequential
> readers from multiple sources at the same time.

Right, and I guess I hadn't considered that case as I thought folks used
more than one spinning disk for such workloads.

My main reservation about this change is that you've only provided
numbers for one benchmark.  To bump the default target_latency, ideally
we'd know how it affects other workloads.  However, I'm having a hard
time justifying putting any time into this for a couple of reasons:
1) blk-mq pretty much does away with the i/o scheduler, and that is the
   future
2) there is work in progress to convert cfq into bfq, and that will
   essentially make any effort put into this irrelevant (so it might be
   interesting to test your workload with bfq)

Cheers,
Jeff
