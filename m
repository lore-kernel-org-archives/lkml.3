Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaFPMix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 08:38:53 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:52822 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbaFPMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 08:38:52 -0400
Message-ID: <1402922329.30599.10.camel@x220>
Subject: Re: [PATCH] [media] sms: Remove CONFIG_ prefix from Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Martin Walch <walch.martin@web.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 16 Jun 2014 14:38:49 +0200
In-Reply-To: <1397663263.28548.13.camel@x220>
References: <3513955.N5RNgL3hPx@tacticalops>
	 <1383420054.4378.3.camel@x220.thuisdomein>
	 <20131102174047.70c24ed8@samsung.com> <1392122724.13064.18.camel@x220>
	 <1397663263.28548.13.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2014 12:38:49.0965 (UTC) FILETIME=[EC7E91D0:01CF895F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 17:47 +0200, Paul Bolle wrote:
> Remove the CONFIG_ prefix from two Kconfig symbols in a dependency for
> SMS_SIANO_DEBUGFS. This prefix is invalid inside Kconfig files.
> 
> Note that the current (common sense) dependency on SMS_USB_DRV and
> SMS_SDIO_DRV being equal ensures that SMS_SIANO_DEBUGFS will not
> violate its constraints. These constraint are that:
> - it should only be built if SMS_USB_DRV is set;
> - it can't be builtin if USB support is modular.
> 
> So drop the dependency on SMS_USB_DRV, as it is unneeded.
> 
> Fixes: 6c84b214284e ("[media] sms: fix randconfig building error")
> Reported-by: Martin Walch <walch.martin@web.de>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> This is not runtime tested, as I don't have the hardware.
> 
> A matrix of the three cases in which this symbol can be set, to aid
> review and to see whether I actually understood the constraints:
> 
> USB  SMS_USB_DRV  SMS_SDIO_DRV  SMS_SIANO_MDTV  SMS_SIANO_DEBUGFS
> m    m            m             m               y 
> y    m            m             m               y 
> y    y            y             y               y 
> 
> By the way, I found myself staring at the entries in this file for quite
> some time. Perhaps things would have been easier to understand if
> SMS_USB_DRV and SMS_SDIO_DRV both selected SMS_SIANO_MDTV. But I didn't
> dare to test that idea.

This can still be seen in v3.16-rc1 and in next-20140616.

Debugfs for smsdvb has been unbuildable since v3.12. That problem has
been reported even before v3.12 was released. Does no one care and can
it be removed?

>  drivers/media/common/siano/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/siano/Kconfig b/drivers/media/common/siano/Kconfig
> index f953d33ee151..4bfbd5f463d1 100644
> --- a/drivers/media/common/siano/Kconfig
> +++ b/drivers/media/common/siano/Kconfig
> @@ -22,8 +22,7 @@ config SMS_SIANO_DEBUGFS
>  	bool "Enable debugfs for smsdvb"
>  	depends on SMS_SIANO_MDTV
>  	depends on DEBUG_FS
> -	depends on SMS_USB_DRV
> -	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV
> +	depends on SMS_USB_DRV = SMS_SDIO_DRV
>  
>  	---help---
>  	  Choose Y to enable visualizing a dump of the frontend


Paul Bolle

