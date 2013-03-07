Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab3CGDX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:23:57 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:51535 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3CGDX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:23:56 -0500
MIME-Version: 1.0
In-Reply-To: <1361978715-14948-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1361978715-14948-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 7 Mar 2013 04:23:56 +0100
Message-ID: <CACRpkdb21s+XDc+Ad0RBDT+KQ2C7CbK-rPO3GwEU4mOzpjj+TQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-ich: fix ichx_gpio_check_available() return
 what callers expect
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Peter Tyser <ptyser@xes-inc.com>, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Wed, Feb 27, 2013 at 4:25 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> -static int ichx_gpio_check_available(struct gpio_chip *gpio, unsigned nr)
> +static bool ichx_gpio_check_available(struct gpio_chip *gpio, unsigned nr)
>  {
> -       return (ichx_priv.use_gpio & (1 << (nr / 32))) ? 0 : -ENXIO;
> +       return ichx_priv.use_gpio & (1 << (nr / 32));
>  }

Strictly speaking what you're returning there is not a bool.
Shouldn't it be:

return !!(ichx_priv.use_gpio & (1 << (nr / 32)));

?

Yours,
Linus Walleij
