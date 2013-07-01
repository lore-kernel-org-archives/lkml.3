Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3GAPR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:17:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30228 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3GAPR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:17:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+EFykGAEdEL81aeZZ36OwonD6mratqVoA=
Date: Mon, 1 Jul 2013 11:17:20 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
Message-ID: <20130701151720.GC19937@titan.lakedaemon.net>
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130701150407.GB19937@titan.lakedaemon.net>
 <51D19CD1.3030900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D19CD1.3030900@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 05:14:25PM +0200, Sebastian Hesselbarth wrote:
> On 07/01/13 17:04, Jason Cooper wrote:
> >On Mon, Jul 01, 2013 at 04:56:29PM +0200, Sebastian Hesselbarth wrote:
> >>Commit 834cbfe966bece50afded79da8e975d255bf0772
> >>  ("drivers/dma: remove unused support for MEMSET operations")
> >>removes MEMSET from dmaengine but does not completely removes it from
> >>Marvell Orion (arch/arm/plat-orion) and XOR (drivers/dma/mv_xor).
> >>This also fixes some compiler warnings about now obsolete functions by
> >>removing those.
> >>
> >>Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >>---
> >>Cc: Jason Cooper <jason@lakedaemon.net>
> >>Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> >>Cc: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Andrew Morton <akpm@linux-foundation.org>
> >>Cc: linux-arm-kernel@lists.infradead.org
> >>Cc: linux-kernel@vger.kernel.org
> >>---
> >>  arch/arm/plat-orion/common.c |    6 ------
> >>  drivers/dma/mv_xor.c         |   25 +------------------------
> >>  2 files changed, 1 insertions(+), 30 deletions(-)
> >
> >Please take a look at the email from lkml I just forwarded to you.  I
> >believe this solves your problem, but I don't have time to look closely
> >atm.
> 
> Jason,
> 
> I have seen the forwarded patch before. I don't know what version this
> is based on. Some of the modifications are in next-20130701, some are
> not. I have stripped the Marvell modifications from the patch you
> forwarded and fixed all remaining issues.
> 
> Also, I will sent a follow-up patch to remove memset references from
> Marvell SoC dts/dtsi and the binding documentation soon.
> 
> I guess, Bartolomiej should pick them up and resend his patch set, or
> leave Marvell alone and you pick them up.

If Bartolomiej doesn't take it, please split your changes into two
patches, one for plat-orion, and one for drivers.

thx,

Jason.
