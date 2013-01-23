Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3AWSLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:11:31 -0500
Received: from londo.lunn.ch ([80.238.139.98]:57171 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab3AWSLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:11:30 -0500
Date: Wed, 23 Jan 2013 19:10:29 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Soeren Moch <smoch@web.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-ID: <20130123181029.GE20719@lunn.ch>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
 <201301171049.30415.arnd@arndb.de>
 <50F800EB.6040104@web.de>
 <201301172026.45514.arnd@arndb.de>
 <50FABBED.1020905@web.de>
 <20130119185907.GA20719@lunn.ch>
 <5100022D.9050106@web.de>
 <20130123162515.GK13482@lunn.ch>
 <510018B4.9040903@web.de>
 <51001BEE.9020201@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51001BEE.9020201@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >
> >Now (in the last hour) stable, occasionally lower numbers:
> >3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396
> >3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396
> >3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396
> >3396 3396 3396 3396 3396 3396 3396 3396 3396 3365 3396 3394 3396 3396
> >3396 3396 3373 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396
> >3396 3353 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396 3396
> >3394 3396 3396 3396 3396 3396 3396 3396
> >
> >Before the last pool exhaustion going down:
> >3395 3395 3389 3379 3379 3374 3367 3360 3352 3343 3343 3343 3342 3336
> >3332 3324 3318 3314 3310 3307 3305 3299 3290 3283 3279 3272 3266 3265
> >3247 3247 3247 3242 3236 3236
> >
> Here I stopped vdr (and so closed all dvb_demux devices), the number
> was remaining the same 3236, even after restart of vdr (and restart
> of streaming).

So it does suggest a leak. Probably somewhere on an error path,
e.g. its lost video sync.

     Andrew
