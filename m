Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3JIMau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:30:50 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:38013 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3JIMas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:30:48 -0400
MIME-Version: 1.0
In-Reply-To: <1381235122-23730-2-git-send-email-christian.ruppert@abilis.com>
References: <20131008122145.GA21985@ab42.lan>
	<1381235122-23730-2-git-send-email-christian.ruppert@abilis.com>
Date: Wed, 9 Oct 2013 14:30:46 +0200
Message-ID: <CACRpkdZdELan7OyMjt4KOi=q-v1xkSaNZNyZ7AnOBY1R=SoW3w@mail.gmail.com>
Subject: Re: [PATCH 02/03] pinmux: Add TB10x pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 2:25 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> The pinmux driver of the Abilis Systems TB10x platform based on ARC700 CPUs.
> Used to control the pinmux and is a prerequisite for the GPIO driver.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Overall this is looking pretty nice!

> +static int tb10x_dt_node_to_map(struct pinctrl_dev *pctl,
> +                               struct device_node *np_config,
> +                               struct pinctrl_map **map, unsigned *num_maps)
> +{
> +       struct pinctrl_map *m;
> +       const char *string;
> +
> +       if (of_property_read_string(np_config, "abilis,function", &string)) {
> +               pr_err("%s: No abilis,function property in device tree.\n",
> +                       np_config->full_name);
> +               return -EINVAL;
> +       }
> +
> +       m = kzalloc(sizeof(struct pinctrl_map), GFP_KERNEL);
> +       if (!m)
> +               return -ENOMEM;

Could you make use of:

#include "pinctrl-utils.h"

pinctrl_utils_reserve_map()
pinctrl_utils_add_map_mux()
pinctrl_utils_dt_free_map()

?

> +static int tb10x_gpio_request_enable(struct pinctrl_dev *pctl,
> +                                       struct pinctrl_gpio_range *range,
> +                                       unsigned pin)
> +{
> +       struct tb10x_pinctrl *state = pinctrl_dev_get_drvdata(pctl);
> +       int muxport = -1;
> +       int muxmode = -1;
> +       int i;
> +
> +       mutex_lock(&state->mutex);
> +
> +       /* Figure out to which port the requested GPIO belongs and how to
> +        * configure that port.
> +        * This loop also checks for pin conflicts between GPIOs and other
> +        * functions.
> +        */

/*
 * I really like all comments with a blank
 * line at the top and bottom like this.
 */

Yours,
Linus Walleij
