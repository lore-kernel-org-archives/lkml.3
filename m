Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3KVQjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:39:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43722 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3KVQio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:38:44 -0500
Date: Fri, 22 Nov 2013 17:38:35 +0100
From: Michael Grzeschik <mgr@pengutronix.de>
To: Mark Jackson <mpfj-list@newflow.co.uk>
Cc: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, bigeasy@linutronix.de,
        Greg KH <gregkh@linuxfoundation.org>, jkosina@suse.cz,
        anatol.pomozov@gmail.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Allow MUSB DSPS to use "force host" mode
Message-ID: <20131122163835.GF24508@pengutronix.de>
References: <528F7E8F.5050807@newflow.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F7E8F.5050807@newflow.co.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:33:51 up 63 days,  4:21, 47 users,  load average: 21,65, 23,34,
 26,47
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

On Fri, Nov 22, 2013 at 03:55:59PM +0000, Mark Jackson wrote:
> The IDDIG input pin is normally used to determine the USB mode
> (i.e. HOST or DEVICE).
> 
> On some systems (e.g. AM335x) leaving this pin floating allows
> the USB mode to be set via software.
> 
> This patch adds support for this via the device tree.
> 
> Signed-off-by: Mark Jackson <mpfj@newflow.co.uk>
> ---
>  .../devicetree/bindings/usb/am33xx-usb.txt         |    2 ++
>  drivers/usb/musb/musb_dsps.c                       |   14 ++++++++++++++
>  include/linux/usb/musb.h                           |    1 +
>  3 files changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/am33xx-usb.txt b/Documentation/devicetree/bindings/usb/am33xx-usb.txt
> index 20c2ff2..560b7ff 100644
> --- a/Documentation/devicetree/bindings/usb/am33xx-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/am33xx-usb.txt
> @@ -47,6 +47,8 @@ USB
>  - dmas: specifies the dma channels
>  - dma-names: specifies the names of the channels. Use "rxN" for receive
>    and "txN" for transmit endpoints. N specifies the endpoint number.
> +- ti,force-host: specifies that the IDDIG input be ignored and the device be
> +  put into host mode regardless.

You should always CC devicetree-discuss if adding new bindings. Why
another binding anyway? We have the common binding dr_mode already.
Please use this and of_usb_get_dr_mode from drivers/usb/usb-common.c
instead.

Thanks,
Michael
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
