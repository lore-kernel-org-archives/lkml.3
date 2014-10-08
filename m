Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaJHGtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:49:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56223 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaJHGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:49:09 -0400
Date: Wed, 8 Oct 2014 08:49:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
Cc: chris@printf.net, ulf.hansson@linaro.org, shc_work@mail.ru,
        peter.griffin@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linucppc-dev@lists.ozlabs.org,
        agust@denx.de, gsi@denx.de, sbabic@denx.de
Subject: Re: [PATCH 1/2] mmc: mxcmmc: fix race condition when dma finish a
 data transfer
Message-ID: <20141008064902.GA4992@pengutronix.de>
References: <1412089178-21946-1-git-send-email-matteo.facchinetti@sirius-es.it>
 <1412089178-21946-2-git-send-email-matteo.facchinetti@sirius-es.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412089178-21946-2-git-send-email-matteo.facchinetti@sirius-es.it>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:47:01 up 27 days, 23:34, 81 users,  load average: 0.04, 0.06,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 04:59:37PM +0200, Matteo Facchinetti wrote:
> From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
> 
> In accordance with the other drivers that using the dma engine,
> fix it, leaving *only* to dma driver the complete control to
> ending the read operation.
> 
> Removing STATUS_READ_OP_DONE event activation, has as effect
> to force mxcmci driver to handle the finish data transfer only
> by mxcmci dma callback.
> 
> Signed-off-by: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>

I can't test this currently, but it looks sane to me and I assume you
invested quite some time to make sure the patch behaves correctly.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
