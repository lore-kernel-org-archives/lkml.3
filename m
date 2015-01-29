Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbbA2CBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:01:49 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40126 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbbA2CBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:01:47 -0500
Date: Thu, 29 Jan 2015 11:01:40 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Ganesh Mahendran <opensource.ganesh@gmail.com>,
        sergey.senozhatsky.work@gmail.com
Subject: Re: [PATCH v1 2/2] zram: remove init_lock in zram_make_request
Message-ID: <20150129020139.GB9672@blaptop>
References: <1422432945-6764-1-git-send-email-minchan@kernel.org>
 <1422432945-6764-2-git-send-email-minchan@kernel.org>
 <20150128145651.GB965@swordfish>
 <20150128233343.GC4706@blaptop>
 <CAHqPoqKZFDSjO1pL+ixYe_m_L0nGNcu04qSNp-jd1fUixKtHnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHqPoqKZFDSjO1pL+ixYe_m_L0nGNcu04qSNp-jd1fUixKtHnw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 10:57:38AM +0900, Sergey Senozhatsky wrote:
> On Thu, Jan 29, 2015 at 8:33 AM, Minchan Kim <minchan@kernel.org> wrote:
> 
> > On Wed, Jan 28, 2015 at 11:56:51PM +0900, Sergey Senozhatsky wrote:
> > > I don't like re-introduced ->init_done.
> > > another idea... how about using `zram->disksize == 0' instead of
> > > `->init_done' (previously `->meta != NULL')? should do the trick.
> >
> > It could be.
> >
> >
> care to change it?

Will try!

> 
> 
> 
> > >
> > >
> > > and I'm not sure I get this rmb...
> >
> > What makes you not sure?
> > I think it's clear and common pattern for smp_[wmb|rmb]. :)
> >
> 
> 
> well... what that "if (ret)" gives? it's almost always true, because the
> device is initialized during read/write operations (in 99.99% of cases).

If it was your concern, I'm happy to remove the check.(ie, actually,
I realized that after I push the button to send). Thanks!

> 
> -ss

-- 
Kind regards,
Minchan Kim
