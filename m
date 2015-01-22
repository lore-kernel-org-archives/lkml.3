Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbbAVJNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:13:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42617 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbbAVJNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:13:37 -0500
Date: Thu, 22 Jan 2015 10:13:30 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] dma: imx-sdma: switch to dynamic context mode after
 script loaded
Message-ID: <20150122091330.GT12209@pengutronix.de>
References: <1421911420-31821-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421911420-31821-1-git-send-email-b38343@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:13:04 up 98 days, 20:26, 131 users,  load average: 0.00, 0.04,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 03:23:40PM +0800, Robin Gong wrote:
> Below comments got from Page4724 of Reference Manual of i.mx6q:
> http://cache.freescale.com/files/32bit/doc/ref_manual/IMX6DQRM.pdf
> 
> --"Static context mode should be used for the first channel called
> after reset to ensure that the all context RAM for that channel is
> initialized during the context SAVE phase when the channel is
> done or yields. Subsequent calls to the same channel or
> different channels may use any of the dynamic context modes.
> This will ensure that all context locations for the bootload
> channel are initialized, and prevent undefined values in context
> RAM from being loaded during the context restore if the
> channel is re-started later"
> 
> Unfortunately, the rule was broken by commit(5b28aa319bba96987316425a1131813d87cbab35)
> .This patch just take them back.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
