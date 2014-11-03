Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaKCTMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:12:53 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:50803 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKCTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:12:49 -0500
MIME-Version: 1.0
In-Reply-To: <1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
	<1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
Date: Mon, 3 Nov 2014 20:12:47 +0100
X-Google-Sender-Auth: -5UbQK5APlXUgR5O09aQs_qtxn0
Message-ID: <CAMuHMdVZQQXx75-0GWCFNnFqEH8S+b0TcWWUGCqgmyzNkyRtYA@mail.gmail.com>
Subject: Re: [PATCH 3/7] pinctrl: pinconf-generic: Allow driver to specify DT params
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> --- a/include/linux/pinctrl/pinctrl.h
> +++ b/include/linux/pinctrl/pinctrl.h

> @@ -117,6 +118,8 @@ struct pinctrl_ops {
>   * @confops: pin config operations vtable, if you support pin configuration in
>   *     your driver
>   * @owner: module providing the pin controller, used for refcounting
> + * @num_dt_params: Number of driver-specifid DT parameters

driver-specific

> + * @params: List of DT parameters

Missing @conf_items documentation.

>   */
>  struct pinctrl_desc {
>         const char *name;
> @@ -126,6 +129,11 @@ struct pinctrl_desc {
>         const struct pinmux_ops *pmxops;
>         const struct pinconf_ops *confops;
>         struct module *owner;
> +#if defined(CONFIG_GENERIC_PINCONF) && defined(CONFIG_OF)
> +       unsigned int num_dt_params;
> +       const struct pinconf_generic_dt_params *params;
> +       const struct pin_config_item *conf_items;
> +#endif

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
