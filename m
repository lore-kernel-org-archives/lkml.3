Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaHDH6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:58:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45586 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaHDH6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:58:45 -0400
Message-ID: <1407139122.3979.8.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] reset: Provide !RESET_CONTROLLER stub for
 devm_reset_control_get()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Mon, 04 Aug 2014 09:58:42 +0200
In-Reply-To: <1406913099-13688-1-git-send-email-broonie@kernel.org>
References: <1406913099-13688-1-git-send-email-broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am Freitag, den 01.08.2014, 18:11 +0100 schrieb Mark Brown:
> From: Mark Brown <broonie@linaro.org>
> 
> At least the sun6i DMA controller driver makes use of the reset controller
> API stubs when being built for coverage and otherwise fails to build.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  include/linux/reset.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/reset.h b/include/linux/reset.h
> index 349f150..28f119f 100644
> --- a/include/linux/reset.h
> +++ b/include/linux/reset.h
> @@ -67,6 +67,13 @@ static inline int device_reset_optional(struct device *dev)
>  	return -ENOSYS;
>  }
>  
> +static inline struct reset_control *devm_reset_control_get(struct device *dev,
> +							   const char *id)
> +{
> +	WARN_ON(1);
> +	return ERR_PTR(-ENOSYS);
> +}
> +

I'd prefer to keep devm_reset_control_get without a stub.
Drivers that can be built without CONFIG_RESET_CONTROLLER enabled should
use devm_reset_control_get_optional, and this way the build tests
already report this issue.

regards
Philipp

