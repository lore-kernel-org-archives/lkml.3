Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3CaI0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 04:26:16 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:46428 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3CaI0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 04:26:11 -0400
Date: Sun, 31 Mar 2013 10:25:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Shawn Guo <shawn.guo@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH 3/6] i2c: Ignore return value of i2c_del_adapter()
Message-ID: <20130331102547.4d5d2e4c@endymion.delvare>
In-Reply-To: <1362853009-20789-4-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
	<1362853009-20789-4-git-send-email-lars@metafoo.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Mar 2013 19:16:46 +0100, Lars-Peter Clausen wrote:
> i2c_del_adapter() always returns 0. So all checks testing whether it will be
> non zero will always evaluate to false and the conditional code is dead code.
> This patch updates all callers of i2c_del_mux_adapter() to ignore the return
> value and assume that it will always succeed (which it will). In a subsequent
> patch the return type of i2c_del_adapter() will be made void.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Ben Hutchings <bhutchings@solarflare.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Marek Vasut <marex@denx.de> (commit_signer:11/20=55%)
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Lars Poeschel <poeschel@lemonage.de>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c   |  3 +--
>  drivers/i2c/busses/i2c-amd756-s4882.c        |  6 +-----
>  drivers/i2c/busses/i2c-at91.c                |  5 ++---
>  drivers/i2c/busses/i2c-cbus-gpio.c           |  4 +++-
>  drivers/i2c/busses/i2c-intel-mid.c           |  3 +--
>  drivers/i2c/busses/i2c-mv64xxx.c             |  5 ++---
>  drivers/i2c/busses/i2c-mxs.c                 |  5 +----
>  drivers/i2c/busses/i2c-nforce2-s4985.c       |  6 +-----
>  drivers/i2c/busses/i2c-powermac.c            | 10 ++--------
>  drivers/i2c/busses/i2c-puv3.c                | 10 ++--------
>  drivers/i2c/busses/i2c-viperboard.c          |  5 ++---
>  drivers/i2c/i2c-mux.c                        |  5 +----
>  drivers/media/pci/bt8xx/bttv-input.c         |  6 +++---
>  drivers/media/pci/mantis/mantis_i2c.c        |  4 +++-
>  drivers/net/ethernet/sfc/falcon.c            |  6 ++----
>  drivers/staging/media/go7007/go7007-driver.c |  7 ++-----
>  16 files changed, 29 insertions(+), 61 deletions(-)
> (...)

For i2c-amd756-s4882, i2c-nforce2-s4985 and i2c-mux:

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
