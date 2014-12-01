Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaLATlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:41:45 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54682 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbaLATlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:41:44 -0500
Date: Mon, 1 Dec 2014 11:41:39 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH] mtd: gpmi: properly handle bitflips in erased pages
Message-ID: <20141201194139.GI21347@ld-irv-0074>
References: <1417461159-2972-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417461159-2972-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Mon, Dec 01, 2014 at 08:12:39PM +0100, Boris Brezillon wrote:
> Brian, I really like the idea of having a generic implementation for this
> feature (using read_page_raw) as you suggested here [1], but this implies
> having a temporary buffer to store the page read in raw mode and keep the page
> read in normal (HW ECC engine eanbled) mode, and I'm not sure we want to
> allocate more buffers than we already have.

Why does this require an additional buffer? If we've already noticed an
ECC error, we're expected to return raw data anyway, so what's the
problem with clobbering the original data with a raw version of the
data?

I really *really* do not want to merge another one-off attempt at
"solving" this problem in the low-level driver, if at all possible.

Brian

P.S. Sorry for not following up on my last attempt of a generic
solution. I don't think I got enough constructive feedback, other than
"this does not work for me", so I didn't pursue it further. If we have
the attention of more than one driver developer here (i.e., at least you
and me), then I'd really like to finish this off for good (?).
