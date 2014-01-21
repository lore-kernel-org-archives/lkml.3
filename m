Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaAUAIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:08:48 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55279 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaAUAIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:08:47 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-44-52ddba84542e
Date: Tue, 21 Jan 2014 09:09:45 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] zram: introduce zram compressor operations struct
Message-ID: <20140121000945.GG28712@bbox>
References: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389956657-5486-3-git-send-email-sergey.senozhatsky@gmail.com>
 <20140120051233.GC8155@bbox>
 <20140120100348.GB2178@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120100348.GB2178@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 01:03:48PM +0300, Sergey Senozhatsky wrote:
> On (01/20/14 14:12), Minchan Kim wrote:
> > Hello Sergey,
> > 
> > I reviewed this patchset and I suggest somethings.
> > Please have a look and feedback to me. :)
> > 
> > 1. Let's define new file zram_comp.c
> > 2. zram_comp includes following field
> >    .create
> >    .compress
> >    .decompress.
> >    .destroy
> >    .name
> > 
> 
> alternatively, we can use crypto api, the same way as zswap does (that
> will require handling of cpu hotplug).
> 
> 	-ss

I really doubt what's the benefit from crypto API for zram.
It's maybe since I'm not familiar with it so I should ask a silly
question.

1. What's the runtime overhead for using such frontend?

   As you know, zram is in-memory block device so I don't want to
   add unnecessary overhead to optimize.

2. What's the memory footprint for using such frontend?

   As you know, zram is very popular for small-memory embedded device
   so I don't want to consume more runtime memory and static memory
   due to CONFIG_CRYPTO friend.

3. Is it a flexible to alloc/handle multiple compressor buffer for
   the our purpose? zswap and zcache have been used it with per-cpu
   buffer but it would a problem for write scalabitliy if we uses zlib
   which takes long time to compress.
   When I read code, maybe we can allocate multiple buffers through
   cryptop_alloc_compo several time but it would cause 1) and 2) problem
   again.
   
So, what's the attractive point for using crypto?
One of thing I could imagine is that it could make zram H/W compressor
but I don't have heard about it so if we don't have any special reason,
I'd like to go with raw compressor so we can get a *base* number. Then,
if we really need crypto API, we can change it easily and benchmark.
Finally, we could get a comparision number in future and it would make
the decision easily.

Thanks.

-- 
Kind regards,
Minchan Kim
