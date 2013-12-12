Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3LLSTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:19:38 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41641 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LLSTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:19:35 -0500
MIME-Version: 1.0
In-Reply-To: <1386477638-6331-1-git-send-email-caesarxuchao@gmail.com>
References: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
	<1386477638-6331-1-git-send-email-caesarxuchao@gmail.com>
Date: Thu, 12 Dec 2013 19:19:35 +0100
Message-ID: <CACRpkdaD13JnGetD-GLpxSoaf_LkRKYFjis7Tftc6U38E1ES5A@mail.gmail.com>
Subject: Re: [RFC/RFT/PATCH V3] gpio: omap: refresh patch "be more aggressive
 with pm_runtime" against v3.12-rc5
From: Linus Walleij <linus.walleij@linaro.org>
To: Chao Xu <caesarxuchao@gmail.com>
Cc: Linux-OMAP <linux-omap@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 8, 2013 at 5:40 AM, Chao Xu <caesarxuchao@gmail.com> wrote:

> From: Felipe Balbi <balbi@ti.com>
>
> try to keep gpio block suspended as much as possible.
>
> Tested with pandaboard and a sysfs exported gpio.
>
> Signed-off-by: Felipe Balbi <balbi at ti.com>
>
> [caesarxuchao@gmail.com : Refreshed against v3.12-rc5, and added
> revision check to enable aggressive pm_runtime on OMAP4-only. Because
> am33xx_gpio_sysc.idlemodes seems to be wrongly marked as
> SIDLE_SMART_WKUP, which might cause missed interrupts with this patch.
> Tested on Pandaboard rev A2.]
> Signed-off-by: Chao Xu <caesarxuchao@gmail.com>
> ---
> changes since v2:
> *add wrapper function to avoid 'is_aggressive_pm' check everywhere, as
> suggested by Santosh Shilimkar
> *fix format issue in commit log

I'm dropping this until you convince Kevin/Tony that this is
the way to go.

One thing caught my eye, you add:

> +static void _aggressive_pm_runtime_get_sync(struct gpio_bank *bank)
> +static void _aggressive_pm_runtime_put(struct gpio_bank *bank)
(..)

Then everywhere:

> +       _aggressive_pm_runtime_get_sync(bank);
(...)
> +       _aggressive_pm_runtime_put(bank);

Aggressive, argh, runtime PM is agressive by definition. If you
want to switch this on and off use the compile option
to enable/disable runtime PM altogether and do not wrap it
like this.

Yours,
Linus Walleij
