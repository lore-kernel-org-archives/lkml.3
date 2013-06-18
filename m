Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3FREIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:08:52 -0400
Received: from nm16.access.bullet.mail.mud.yahoo.com ([66.94.237.217]:47292
	"EHLO nm16.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873Ab3FREIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:08:50 -0400
X-Yahoo-Newman-Id: 651730.30128.bm@smtp119.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: F6s88xcVM1nb8VlAE3lBhPDpJUiX5iJgnOiCrcSwyOdcW.n
 oy8mIdHLjjHCsQJYH6bWMSIb1Rsw.4f_1TuuFvL6S_IGd7KxY7b91NIq_T6r
 9YNP4XFoGRGIS8QdKkpwg4oR8onK4F59wnu4GmcvRsaZm8eT0BKZXGh_bCrp
 Soykugr24lD3zSn9LXQGsNgQMk_kOSl4YRR3lj3pqPgvAkbb5FJ7w6p6_CyQ
 CNzJcNdNZjB8Nogi3_o4vNGo9.RP.R2NV2Lkz.alTyHht5BkU3KuFG22k0pA
 W30HH.Jc_CVKbzfHDm.6mSiY2yqOsw0_Hw1YM0MTlajRDKurBWGAEgQKYdEu
 57QykMOdllpRGJfgdcRuQSjz2WicNGg0rt_TlIqpWWurHW6CItMOjyqjHyyX
 bwrxOPBRYw6chs6FtsmHShDDCcvLSdJ9j1hE1GUnuz4CAl8oW55WVMq12O5T
 NVnPDKiLcb9RYWzUMsd8Nd80lcIAJdafjwKrqFPbP9Hk7AeN1pJ_dinCPVog
 YMbZCrtTadlofigGA7gY-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp119.sbc.mail.ne1.yahoo.com with SMTP; 18 Jun 2013 04:03:12 +0000 UTC
Date: Mon, 17 Jun 2013 21:03:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank.Li@freescale.com, jim_baxter@mentor.com
Subject: Re: [PATCH] net: fec: Fix build for MCF5272
Message-ID: <20130618040312.GA12181@roeck-us.net>
References: <1371500179-4733-1-git-send-email-linux@roeck-us.net>
 <20130617.161151.1327615665309510068.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617.161151.1327615665309510068.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 04:11:51PM -0700, David Miller wrote:
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Mon, 17 Jun 2013 13:16:19 -0700
> 
> > Commits 4c09eed9 (net: fec: Enable imx6 enet checksum acceleration) and
> > baa70a5c (net: fec: enable pause frame to improve rx prefomance for 1G
> > network) introduced functionality into the FEC driver which is not
> > supported on MCF5272. As result, building images for MCF5272 fails,
> > complaining about several undefined symbols.
> > 
> > Disabled the added functionality for MCF5272 builds.
> > 
> > Cc: Frank Li <Frank.Li@freescale.com>
> > Cc: Jim Baxter <jim_baxter@mentor.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > Sorry for the added ifdefs. If anyone has a better idea on how to fix
> > the problems, let me know.
> > 
> > This problem exists in 3.9 as well.
> 
> Does the M5272 not have these registers, or have you simply not added
> defines for where there offsets are in that silicon instance?
> 
> I'd much rather you add the register offset defines than pepper the
> entire driver with ifdefs.
> 
I agree, and that would have been my preferred solution as well.
Unfortunately, according to the user manual (MCF5272 ColdFire
Integrated Microprocessor User's Manual), the registers do not exist
on this chip.

Guenter
