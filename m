Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaAFR2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:28:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59945 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbaAFR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:28:06 -0500
Message-ID: <1389029284.5590.21.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v4 01/15] reset: Silence warning in reset-controller.h
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Date: Mon, 06 Jan 2014 18:28:04 +0100
In-Reply-To: <1387847559-18330-2-git-send-email-sboyd@codeaurora.org>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
	 <1387847559-18330-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 23.12.2013, 17:12 -0800 schrieb Stephen Boyd:
> If a user of <linux/reset-controller.h> doesn't include
> <linux/of.h> before including reset-controller.h they'll get a
> warning as follows:
> 
>   include/linux/reset-controller.h:44:17:
>   warning: 'struct of_phandle_args' declared inside parameter list
> 
> This is because of_phandle_args is not forward declared. Add the
> declaration to silence this warning.
> 
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  include/linux/reset-controller.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
> index 2f61311..41a4695 100644
> --- a/include/linux/reset-controller.h
> +++ b/include/linux/reset-controller.h
> @@ -21,6 +21,7 @@ struct reset_control_ops {
>  
>  struct module;
>  struct device_node;
> +struct of_phandle_args;
>  
>  /**
>   * struct reset_controller_dev - reset controller entity that might

Since this is only a warning, I see no need for this to go through the
clock tree. On the other hand there are no merge conflicts to be
expected, so that's fine with me either way.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

