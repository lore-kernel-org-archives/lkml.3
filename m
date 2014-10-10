Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJJIOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:14:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38978 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaJJIOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:14:31 -0400
Message-ID: <1412928866.3491.1.camel@pengutronix.de>
Subject: Re: [PATCHv2] reset: add reset_control_status helper function
From: Philipp Zabel <p.zabel@pengutronix.de>
To: dinguyen@opensource.altera.com
Cc: dinh.linux@gmail.com, atull@opensource.altera.com,
        linux-kernel@vger.kernel.org
Date: Fri, 10 Oct 2014 10:14:26 +0200
In-Reply-To: <1412887494-16442-1-git-send-email-dinguyen@opensource.altera.com>
References: <1412887494-16442-1-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

you forgot one s/^+unsigned int/+int/ below.

Am Donnerstag, den 09.10.2014, 15:44 -0500 schrieb dinguyen@opensource.altera.com:
[...]
> @@ -126,6 +126,19 @@ int reset_control_deassert(struct reset_control *rstc)
>  EXPORT_SYMBOL_GPL(reset_control_deassert);
>  
>  /**
> + * reset_control_status - returns a status of a reset bit
> + * @rstc: reset controller

+ *
+ * Returns a negative errno if not supported, a positive value if the reset
+ * line is asserted, or zero if the reset line is not asserted.

Maybe add something like this?

[...]
> diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
> index 41a4695..ce6b962 100644
> --- a/include/linux/reset-controller.h
> +++ b/include/linux/reset-controller.h
> @@ -12,11 +12,13 @@ struct reset_controller_dev;
>   *         things to reset the device
>   * @assert: manually assert the reset line, if supported
>   * @deassert: manually deassert the reset line, if supported
> + * @status: return the status of the reset line, if supported
>   */
>  struct reset_control_ops {
>  	int (*reset)(struct reset_controller_dev *rcdev, unsigned long id);
>  	int (*assert)(struct reset_controller_dev *rcdev, unsigned long id);
>  	int (*deassert)(struct reset_controller_dev *rcdev, unsigned long id);
> +	int (*status)(struct reset_controller_dev *rcdev, unsigned long id);
>  };
>  
>  struct module;
> diff --git a/include/linux/reset.h b/include/linux/reset.h
> index 349f150..f7c76f2 100644
> --- a/include/linux/reset.h
> +++ b/include/linux/reset.h
> @@ -10,6 +10,7 @@ struct reset_control;
>  int reset_control_reset(struct reset_control *rstc);
>  int reset_control_assert(struct reset_control *rstc);
>  int reset_control_deassert(struct reset_control *rstc);
> +unsigned int reset_control_status(struct reset_control *rstc);

int
 
>  struct reset_control *reset_control_get(struct device *dev, const char *id);
>  void reset_control_put(struct reset_control *rstc);
[...]

regards
Philipp

