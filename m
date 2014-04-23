Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaDWE7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 00:59:20 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:37585 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaDWE7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 00:59:19 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 23 Apr 2014 14:00:12 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Bob Liu <bob.liu@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: correct offset usage in zram_bio_discard
Message-ID: <20140423050012.GA17173@js1304-P5Q-DELUXE>
References: <000001cf5dd8$ecf1c360$c6d54a20$%yang@samsung.com>
 <20140422125539.f40a414ca0dbae703a23b977@linux-foundation.org>
 <CAL1ERfM2VGyNUGYdQQyEyqyycnPMoHZn5Vk2Fo3WXL37KmFzCA@mail.gmail.com>
 <20140423030855.GB11184@js1304-P5Q-DELUXE>
 <CAL1ERfNt3VnN8p20P-Gw3HsvzvJZqUwBhikdN5gY+=OsV-8bRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1ERfNt3VnN8p20P-Gw3HsvzvJZqUwBhikdN5gY+=OsV-8bRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:52:08AM +0800, Weijie Yang wrote:
> On Wed, Apr 23, 2014 at 11:08 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > On Wed, Apr 23, 2014 at 10:32:30AM +0800, Weijie Yang wrote:
> >> On Wed, Apr 23, 2014 at 3:55 AM, Andrew Morton
> >> <akpm@linux-foundation.org> wrote:
> >> > On Tue, 22 Apr 2014 11:14:02 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:
> >> >
> >> >> we want to skip the logical block which is partially covered by
> >> >> the discard bio, so check the remaining size and subtract it if
> >> >> there is a need to goto the next logical block.
> >> >>
> >> >> This patch corrects the offset usage in zram_bio_discard.
> >> >>
> >> >
> >> > What were the end-user visible effects of the bug?
> >> >
> >> > Please always include this information when fixing something so that
> >> > others can work out which kernel(s) need patching.
> >> >
> >>
> >> Thanks for your advise, I will resend this patch and add the end-user
> >> visible effect information.
> >
> > Thanks for fixing it.
> >
> > As far as I understand, there is no end-user visible effect, because
> > request size is alway PAGE_SIZE aligned and if n < PAGE_SIZE,
> > no real operation happens. Am I missing?
> 
> The zram only limit ZRAM_LOGICAL_BLOCK_SIZE(4K) aligned,
> not PAGE_SIZE aligned.
> 
> Consider the following scenario:
> on some architecture or config, PAGE_SIZE is 64K for example
> filesystem is set up on zram disk without PAGE_SIZE aligned.
> a discard bio leads to a offset = 4K, size=72K
> normally, it should not really discard any physical block as it partially
> cover two physical blocks.
> However, with the current offset usage, it will discard the second
> physical block and free its memory, which will cause filesystem breakdown.
> 

I misunderstood what discard_granularity means. I thought that if I set
discard_granularity=PAGE_SIZE, the size of discard request is aligned to
PAGE_SIZE. But, by looking at the code, I notice that isn't true. So now, I
understand your patch compeletely. Thanks again.

Thanks.
