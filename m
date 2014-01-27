Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaA0UCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:02:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37467 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbaA0UCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:02:12 -0500
Date: Mon, 27 Jan 2014 13:01:56 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Jose Alonso <joalonsof@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Christoph Hellwig <hch@lst.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] for_each macros correctness
Message-ID: <20140127200156.GJ2782@kernel.dk>
References: <1390733658.3059.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390733658.3059.10.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26 2014, Jose Alonso wrote:
> 
> I observed that there are for_each macros that do an extra memory access
> beyond the defined area.
> Normally this does not cause problems.
> But, this can cause exceptions. For example: if the area is allocated at
> the end of a page and the next page is not accessible.
> 
> For correctness, I suggest changing the arguments of the 'for loop' like
> others 'for_each' do in the kernel.
> 
> files involved:
>    drivers/s390/cio/qdio.h
>    drivers/scsi/isci/host.h
>    drivers/sh/clk/core.c
>    include/linux/blk-mq.h
>    include/linux/shdma-base.h
>    sound/soc/sh/rcar/adg.c

Thanks, I'll dig out the blk-mq bit.

-- 
Jens Axboe

