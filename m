Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3ITD2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 23:28:38 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56019 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3ITD2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 23:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130920030602.GC4565@birch.djwong.org>
References: <20130920030602.GC4565@birch.djwong.org>
From: Mike Snitzer <snitzer@gmail.com>
Date: Thu, 19 Sep 2013 23:28:16 -0400
Message-ID: <CAMM=eLeuGXj8QUZStX53g5Pej-+xrEaLca7PR-WqeB2UN_cQFQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix a regression where MS_SNAP_STABLE (stable pages
 snapshotting) was ignored
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 11:06 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> The "force" parameter in __blk_queue_bounce was being ignored, which means that
> stable page snapshots are not always happening (on ext3).  This of course
> leads to DIF disks reporting checksum errors, so fix this regression.
>
> The regression was introduced in commit 6bc454d1 (bounce: Refactor
> __blk_queue_bounce to not use bi_io_vec)

Should probably add "Cc: stable@vger.kernel.org # v3.10+" no?
