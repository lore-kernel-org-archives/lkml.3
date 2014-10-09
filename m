Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaJIAXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 20:23:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46089 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaJIAXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 20:23:16 -0400
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        dm-devel@redhat.com
Subject: Re: [PATCH v2] block: fix alignment_offset math that assumes io_min is a power-of-2
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <to=1412805952-15316-1-git-send-email-snitzer@redhat.com>
	<1412807173-15541-1-git-send-email-snitzer@redhat.com>
Date: Wed, 08 Oct 2014 20:23:10 -0400
In-Reply-To: <1412807173-15541-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Wed, 8 Oct 2014 18:26:13 -0400")
Message-ID: <yq1iojudrbl.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> The math in both blk_stack_limits() and
Mike> queue_limit_alignment_offset() assume that a block device's io_min
Mike> (aka minimum_io_size) is always a power-of-2.  Fix the math such
Mike> that it works for non-power-of-2 io_min.

Mike> This issue (of alignment_offset != 0) became apparent when testing
Mike> dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
Mike> 1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's
Mike> data block size") unlocked the potential for alignment_offset != 0
Mike> due to the dm-thin-pool's io_min possibly being a non-power-of-2.

Looks good to me, Mike.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
