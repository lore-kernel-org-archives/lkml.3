Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaEZTAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:00:03 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:56474 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359AbaEZTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:00:01 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2014 15:00:01 EDT
Date: Mon, 26 May 2014 20:59:59 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Per Gundberg <per.gundberg@icomera.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: kempld-wdt: Use the correct value when configuring the prescaler with the watchdog
Message-ID: <20140526185959.GA21481@spo001.leaseweb.com>
References: <CAKUdnSzO2ixCOvvxAwz3duXsPEpExVND7VA_DVPAYpwQGTwYdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUdnSzO2ixCOvvxAwz3duXsPEpExVND7VA_DVPAYpwQGTwYdQ@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Per,

> Use the prescaler index, rather than its value, to configure the watchdog.
> This will prevent a mismatch with the prescaler used to calculate the
> cycles.
> 
> Signed-off-by: Per Gundberg <per.gundberg@icomera.com>
> ---
>  drivers/watchdog/kempld_wdt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- src/drivers/watchdog/kempld_wdt.c.orig    2014-04-24 07:32:08.463745055
> +0000
> +++ src/drivers/watchdog/kempld_wdt.c    2014-04-24 07:34:09.839739808 +0000
> @@ -163,7 +163,7 @@ static int kempld_wdt_set_stage_timeout(
>      kempld_get_mutex(pld);
>      stage_cfg = kempld_read8(pld, KEMPLD_WDT_STAGE_CFG(stage->id));
>      stage_cfg &= ~STAGE_CFG_PRESCALER_MASK;
> -    stage_cfg |= STAGE_CFG_SET_PRESCALER(prescaler);
> +    stage_cfg |= STAGE_CFG_SET_PRESCALER(PRESCALER_21);
>      kempld_write8(pld, KEMPLD_WDT_STAGE_CFG(stage->id), stage_cfg);
>      kempld_write32(pld, KEMPLD_WDT_STAGE_TIMEOUT(stage->id),
>              stage_timeout);

This patch has been added to linux-watchdog-next.

Kind regards,
Wim.

