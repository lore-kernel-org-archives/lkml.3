Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101AbaFSSi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:38:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbaFSSi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:38:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] cfq: Increase default value of target_latency
References: <1403079807-24690-1-git-send-email-mgorman@suse.de>
	<1403079807-24690-2-git-send-email-mgorman@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 19 Jun 2014 14:38:44 -0400
In-Reply-To: <1403079807-24690-2-git-send-email-mgorman@suse.de> (Mel Gorman's
	message of "Wed, 18 Jun 2014 09:23:24 +0100")
Message-ID: <x49y4wslp6z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> The existing CFQ default target_latency results in very poor performance
> for larger numbers of threads doing sequential reads.  While this can be
> easily described as a tuning problem for users, it is one that is tricky
> to detect. This patch the default on the assumption that people with access
> to expensive fast storage also know how to tune their IO scheduler.
>
> The following is from tiobench run on a mid-range desktop with a single
> spinning disk.
>
>                                       3.16.0-rc1            3.16.0-rc1                 3.0.0
>                                          vanilla          cfq600                     vanilla
> Mean   SeqRead-MB/sec-1         121.88 (  0.00%)      121.60 ( -0.23%)      134.59 ( 10.42%)
> Mean   SeqRead-MB/sec-2         101.99 (  0.00%)      102.35 (  0.36%)      122.59 ( 20.20%)
> Mean   SeqRead-MB/sec-4          97.42 (  0.00%)       99.71 (  2.35%)      114.78 ( 17.82%)
> Mean   SeqRead-MB/sec-8          83.39 (  0.00%)       90.39 (  8.39%)      100.14 ( 20.09%)
> Mean   SeqRead-MB/sec-16         68.90 (  0.00%)       77.29 ( 12.18%)       81.64 ( 18.50%)

Did you test any workloads other than this?  Also, what normal workload
has 8 or more threads doing sequential reads?  (That's an honest
question.)

Cheers,
Jeff
