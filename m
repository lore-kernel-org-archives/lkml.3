Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3AUUv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:51:29 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37513 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3AUUv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:51:28 -0500
MIME-Version: 1.0
In-Reply-To: <1358788568-11137-7-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
	<1358788568-11137-7-git-send-email-arnd@arndb.de>
Date: Mon, 21 Jan 2013 21:51:26 +0100
Message-ID: <CAPDyKFp-N29V0sj7PfswE__p00JAAO_16+WwxLtBU3QJXe5gyw@mail.gmail.com>
Subject: Re: [PATCH 06/15] clk: export __clk_get_name
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2013 18:15, Arnd Bergmann <arnd@arndb.de> wrote:
> The __clk_get_name is used by drivers that provide their
> own clocks, which have traditionally all been built-in.
> The new imx drm driver however provides clocks but can
> be built as a module, so we need to export __clk_get_name.
>
> While this is only a staging driver, it's likely that
> there will be others like it in the future.
>
> Without this patch, building ARM allmodconfig results in:
>
> ERROR: "__clk_get_name" [drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.ko] undefined!
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/clk.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 251e45d..13b793e 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -263,6 +263,7 @@ inline const char *__clk_get_name(struct clk *clk)
>  {
>         return !clk ? NULL : clk->name;
>  }
> +EXPORT_SYMBOL_GPL(__clk_get_name);
>
>  inline struct clk_hw *__clk_get_hw(struct clk *clk)
>  {
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
