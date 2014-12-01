Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaLAUSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:18:24 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55308 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932196AbaLAUSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:18:22 -0500
Date: Mon, 1 Dec 2014 21:18:18 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH] mtd: gpmi: properly handle bitflips in erased pages
Message-ID: <20141201211818.4e97f2e2@bbrezillon>
In-Reply-To: <20141201194139.GI21347@ld-irv-0074>
References: <1417461159-2972-1-git-send-email-boris.brezillon@free-electrons.com>
	<20141201194139.GI21347@ld-irv-0074>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Mon, 1 Dec 2014 11:41:39 -0800
Brian Norris <computersforpeace@gmail.com> wrote:

> Hi Boris,
> 
> On Mon, Dec 01, 2014 at 08:12:39PM +0100, Boris Brezillon wrote:
> > Brian, I really like the idea of having a generic implementation for this
> > feature (using read_page_raw) as you suggested here [1], but this implies
> > having a temporary buffer to store the page read in raw mode and keep the page
> > read in normal (HW ECC engine eanbled) mode, and I'm not sure we want to
> > allocate more buffers than we already have.
> 
> Why does this require an additional buffer? If we've already noticed an
> ECC error, we're expected to return raw data anyway, so what's the
> problem with clobbering the original data with a raw version of the
> data?

Well in the GPMI particular case (and more generally all NAND
controllers which do not support subpage write) this is true, but if you
can do subpage write, then you might have a bit flip in a specific
chunk which is still empty, while other chunks are written and are
expecting standard ECC correction.
In this case you want to keep the 3 chunks with  standard ECC correction
and only one in raw mode with 'erased page bitflips' fixed.

> 
> I really *really* do not want to merge another one-off attempt at
> "solving" this problem in the low-level driver, if at all possible.

We're definitely on the same page, this is why I asked some feedback. 

> 
> Brian
> 
> P.S. Sorry for not following up on my last attempt of a generic
> solution. I don't think I got enough constructive feedback, other than
> "this does not work for me", so I didn't pursue it further. If we have
> the attention of more than one driver developer here (i.e., at least you
> and me), then I'd really like to finish this off for good (?).

No problem, I can help you achieve this goal ;-).

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
