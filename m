Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3KMNkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:40:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44768 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab3KMNkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:40:03 -0500
Date: Wed, 13 Nov 2013 14:39:52 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jonathan Austin <jonathan.austin@arm.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: default PHYS_OFFSET if !MMU
Message-ID: <20131113133952.GW14892@pengutronix.de>
References: <1384341351-4110-1-git-send-email-tom.leiming@gmail.com>
 <1384341351-4110-2-git-send-email-tom.leiming@gmail.com>
 <528366A9.7060504@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <528366A9.7060504@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 11:46:49AM +0000, Jonathan Austin wrote:
> Hi Ming,
> 
> On 13/11/13 11:15, Ming Lei wrote:
> > From: Jonathan Austin <jonathan.austin@arm.com>
> > 
> > Set CONFIG_PAGE_OFFSET as PHYS_OFFSET when !MMU so that
> > we can keep CONFIG_PAGE_OFFSET same with PAGE_OFFSET.
> >
> 
> I'm not so sure about this commit message - I don't think
> it makes sense...Should it not be more like:
> 
> ------->8-------
> Subject: ARM: set PAGE_OFFSET = PHYS_OFFSET if !MMU
> 
> With !MMU we still set PAGE_OFFSET to 0xC0000000, which
> makes little sense and causes a regression on !MMU after
> f6537f2f0eba4eba ("scripts/kallsyms: filter symbols not
> kernel address space")
> 
> This patch sets PAGE_OFFSET to PHYS_OFFSET in the !MMU
> case, fixing the regression (Tested on Cortex-R7/Vexpress)
> --------8<---------
I like this commit log better, too.

As CONFIG_PAGE_OFFSET is only used in scripts/kallsyms.c and
scripts/link-vmlinux.sh for !MMU.

Booting on efm32 with this patch works just fine, so if you want add my
Tested-by. But I'm unsure how valuable it is as I don't see a breakage
without it.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
