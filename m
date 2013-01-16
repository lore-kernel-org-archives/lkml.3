Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3APVK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:10:59 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:58665 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3APVK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:10:58 -0500
MIME-Version: 1.0
In-Reply-To: <1358368495-10499-1-git-send-email-coelho@ti.com>
References: <1358368495-10499-1-git-send-email-coelho@ti.com>
Date: Wed, 16 Jan 2013 19:10:57 -0200
Message-ID: <CAOMZO5DtKT9wFvJz+nvJZRgR5aNf1xv9O7FOo4YocOoSsujQ=g@mail.gmail.com>
Subject: Re: [PATCH] OMAP: omap4-panda: add WiLink shared transport power functions
From: Fabio Estevam <festevam@gmail.com>
To: Luciano Coelho <coelho@ti.com>
Cc: tony@atomide.com, linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 6:34 PM, Luciano Coelho <coelho@ti.com> wrote:

> +static int wilink_st_init(void)
> +{
> +       int status;
> +
> +       status = gpio_request(GPIO_BT_EN, "kim");
> +       if (status) {
> +               pr_err("%s: failed to request gpio %d\n", __func__,
> +                      GPIO_BT_EN);
> +               return status;
> +       }
> +
> +       status = gpio_direction_output(GPIO_BT_EN, 0);
> +       if (status)
> +               pr_err("%s: unable to configure gpio %d", __func__,
> +                      GPIO_BT_EN);
> +

You could use gpio_request_one() instead.
