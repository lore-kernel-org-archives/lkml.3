Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaK3ILQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 03:11:16 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59368 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaK3ILO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 03:11:14 -0500
Date: Sun, 30 Nov 2014 00:11:10 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v5 1/3] mtd: nand: gpmi: add gpmi_move_bits function
Message-ID: <20141130081110.GC3608@norris-Latitude-E6410>
References: <1417020793-3354-1-git-send-email-boris.brezillon@free-electrons.com>
 <1417020793-3354-2-git-send-email-boris.brezillon@free-electrons.com>
 <20141126175708.1acb90ac@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126175708.1acb90ac@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:57:08PM +0100, Boris Brezillon wrote:
> On Wed, 26 Nov 2014 17:53:11 +0100 Boris Brezillon <boris.brezillon@free-electrons.com> wrote:
> > +/**
> > + * gpmi_move_bits - move bits from one memory region to another
> > + * @dst: destination buffer
> > + * @dst_bit_off: bit offset we're starting to write at
> > + * @src: source buffer
> > + * @src_bit_off: bit offset we're starting to read from
> > + * @nbits: number of bits to copy
> > + *
> > + * This functions copies bits from one memory region to another, and is used by
> > + * the GPMI driver to copy ECC sections which are not guaranteed to be byte
> > + * aligned.
> 
> I forgot to add that src and dst should not overlap, otherwise it won't
> work...

Hmm, normally that's implied for copy-like operations. But since you
named this function "move" (rather than "copy" or "cpy"), that's a
little less clear.

Did you have a good reason for the "move" name? If not, maybe it's worth
changing.

Brian
