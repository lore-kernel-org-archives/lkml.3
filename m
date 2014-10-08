Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705AbaJHWM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:12:27 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:63979 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687AbaJHWMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:12:25 -0400
Message-ID: <5435B6C0.8020704@kernel.dk>
Date: Wed, 08 Oct 2014 16:12:16 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
CC: martin.petersen@oracle.com, dm-devel@redhat.com
Subject: Re: [PATCH] block: fix alignment_offset math that assumes io_min
 is a power-of-2
References: <1412805952-15316-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <1412805952-15316-1-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 04:05 PM, Mike Snitzer wrote:
> The math in both blk_stack_limits() and queue_limit_alignment_offset()
> assume that a block device's io_min (aka minimum_io_size) is always a
> power-of-2.  Fix the math such that it works for non-power-of-2 io_min.
> 
> This issue (of alignment_offset != 0) became apparent when testing
> dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
> 1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's data
> block size") unlocked the potential for alignment_offset != 0 due to
> the dm-thin-pool's io_min possibly being a non-power-of-2.

Well that sucks, AND with a mask is considerably cheaper than a MOD...

-- 
Jens Axboe

