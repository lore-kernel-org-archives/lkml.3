Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaIYIZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:25:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42792 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYIZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:25:16 -0400
Date: Thu, 25 Sep 2014 10:25:06 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: atull@opensource.altera.com
Cc: dinguyen@opensource.altera.com, linux@arm.linux.org.uk,
        yvanderv@opensource.altera.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, delicious.quinoa@gmail.com
Subject: Re: [PATCH 2/2] socfpga: support suspend to ram
Message-ID: <20140925082506.GC26991@pengutronix.de>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com>
 <1411590449-9794-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411590449-9794-3-git-send-email-atull@opensource.altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:22:07 up 15 days,  1:09, 75 users,  load average: 0,08, 0,12,
 0,13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, Sep 24, 2014 at 03:27:29PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add code that requests that the sdr controller go into
> self-refresh mode.  This code is run from ocram.
> 
> This patch assumes that u-boot has already configured sdr:
>   sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
>   sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
>   sdr.ctrlcfg.dramtiming4.selfrfshexit = 512
> 
> How to suspend to ram:
>  $ echo enabled > \
> /sys/devices/soc/ffc02000.serial0/tty/ttyS0/power/wakeup
> 
>  $ echo -n mem > /sys/power/state
> 

(...)

Never looked into that, so maybe a stupid question:
What happens if the bootloader (u-boot or other) didn't configure the sdr?
Will it "just" not wake up again?

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
