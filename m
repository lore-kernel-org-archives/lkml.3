Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3DQQfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:35:37 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56477 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3DQQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:35:35 -0400
MIME-Version: 1.0
In-Reply-To: <1366196768-19015-1-git-send-email-s.nawrocki@samsung.com>
References: <1366134094-23140-1-git-send-email-s.nawrocki@samsung.com>
	<1366196768-19015-1-git-send-email-s.nawrocki@samsung.com>
Date: Wed, 17 Apr 2013 18:35:34 +0200
Message-ID: <CACRpkdZfZtfp5U4-Ab1ufbwBWVSvpDX_F=d-utokDXP7FbQmKw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] gpio: samsung: Remove OF support for Exynos4/5
From: Linus Walleij <linus.walleij@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 1:06 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:

> -#endif
> +        * All Samsung platforms that support device tree will use the pinctrl
> +        * driver, hence we skip initialization of this driver if the OF tree
> +        * is available.
> +        */
> +       if (of_have_populated_dt())
> +               return -ENODEV;
>
>         samsung_gpiolib_set_cfg(samsung_gpio_cfgs, ARRAY_SIZE(samsung_gpio_cfgs));

Oh is that how you do it? It looks fragile.

Can't you check if you have the pinctrl node atleast?

Yours,
Linus Walleij
