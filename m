Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaIDQpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:45:06 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:44265 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbaIDQpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:45:03 -0400
MIME-Version: 1.0
In-Reply-To: <1409161588-19417-4-git-send-email-alvin.chen@intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
	<1409161588-19417-4-git-send-email-alvin.chen@intel.com>
Date: Thu, 4 Sep 2014 18:45:02 +0200
Message-ID: <CACRpkdZJSf+EfYN=hHxRnpjQZGuqroBL0c+08Ng=dRkS0GZySA@mail.gmail.com>
Subject: Re: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
From: Linus Walleij <linus.walleij@linaro.org>
To: Weike Chen <alvin.chen@intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:46 PM, Weike Chen <alvin.chen@intel.com> wrote:

> This patch enables suspend and resume mode for the power management, and
> it is based on Josef Ahmad's previous work.
>
> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
> Signed-off-by: Weike Chen <alvin.chen@intel.com>

(...)

> +#if defined CONFIG_PM_SLEEP

I wonder whether it's worth #ifdef:in out such things, it clutters
the place.

> +/* Store GPIO context across system-wide suspend/resume transitions */
> +static struct gpio_saved_regs {

Call the struct:

struct dwapb_context

because that is easier to understand.

> +       unsigned long data;
> +       unsigned long dir;
> +       unsigned long int_en;
> +       unsigned long int_mask;
> +       unsigned long int_type;
> +       unsigned long int_pol;
> +       unsigned long int_deb;
> +} saved_regs;

Singleton huh?

Insert this into the dynamically allocated per-port or chip struct
instead.

+       dwapb_write(gpio, GPIO_SWPORTA_DR, saved_regs.data);
+       dwapb_write(gpio, GPIO_SWPORTA_DDR, saved_regs.dir);

And port B, C, D?

This looks like a crude hack.

Yours,
Linus Walleij
