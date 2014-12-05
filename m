Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaLEH72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:59:28 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51816 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaLEH71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:59:27 -0500
Message-ID: <1417766393.22963.9.camel@mm-sol.com>
Subject: Re: [PATCH v2 7/7] pinctrl: qcom-spmi-gpio: Migrate to
 pinconf-generic
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Date: Fri, 05 Dec 2014 09:59:53 +0200
In-Reply-To: <1417137993-8337-8-git-send-email-soren.brinkmann@xilinx.com>
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
	 <1417137993-8337-8-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2014-11-27 at 17:26 -0800, Soren Brinkmann wrote:
> 
>  static const struct pinconf_ops pmic_gpio_pinconf_ops = {
> +       .is_generic= true,
>         .pin_config_group_get= pmic_gpio_config_get,
>         .pin_config_group_set= pmic_gpio_config_set,
>         .pin_config_group_dbg_show= pmic_gpio_config_dbg_show,
> @@ -848,6 +742,9 @@ static int pmic_gpio_probe(struct platform_device *pdev)
>         pctrldesc->name = dev_name(dev);
>         pctrldesc->pins = pindesc;
>         pctrldesc->npins = npins;
> +       pctrldesc->num_dt_params = ARRAY_SIZE(pmic_gpio_bindings);
> +       pctrldesc->params = pmic_gpio_bindings;
> +       pctrldesc->conf_items = pmic_conf_items;
> 

What will happen if number of conf_items is less than number of params?

Ivan
