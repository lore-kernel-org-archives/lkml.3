Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab3DCQVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:21:45 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:49138 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab3DCQVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
References: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
Date: Wed, 3 Apr 2013 18:21:43 +0200
Message-ID: <CACRpkdbnHd+HVedHzQZ8-QO8VJE-Wx+0EazYb2mh9uJHi4OfVw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: add suspend-resume support
From: Linus Walleij <linus.walleij@linaro.org>
To: Bibek Basu <bbasu@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 6:11 PM, Bibek Basu <bbasu@nvidia.com> wrote:

Hm I recognize this name :-)

> This patch adds suspend and resume callbacks to the pinctrl-tegra driver.

Please be more verbose. How is this achieved? I have to
guess what the code is doing..

> +#ifdef CONFIG_PM_SLEEP
> +
> +static int pinctrl_suspend(void)
> +{
> +       int i, j;
> +       u32 *pg_data = pmx->pg_data;
> +       u32 *regs;
> +
> +       for (i = 0; i < pmx->nbanks; i++) {
> +               regs = pmx->regs[i];
> +               for (j = 0; j < pmx->regs_size[i] / 4; j++)
> +                       *pg_data++ = readl(regs++);
> +       }
> +       return 0;
> +}
> +
> +static void pinctrl_resume(void)
> +{
> +       int i, j;
> +       u32 *pg_data = pmx->pg_data;
> +       u32 *regs;
> +
> +       for (i = 0; i < pmx->nbanks; i++) {
> +               regs = pmx->regs[i];
> +               for (j = 0; j < pmx->regs_size[i] / 4; j++)
> +                       writel(*pg_data++, regs++);
> +       }
> +}
> +
> +static struct syscore_ops pinctrl_syscore_ops = {
> +       .suspend = pinctrl_suspend,
> +       .resume = pinctrl_resume,
> +};
> +
> +#endif
(...)
> +#ifdef CONFIG_PM_SLEEP
> +       register_syscore_ops(&pinctrl_syscore_ops);
> +#endif

So Stephen already commented that syscore ops is maybe too big
a sledgehammer for a fine-granular problem.

I mainly want to know what is happening above, it looks like
a state save/restore for all registers or something like this?

Yours,
Linus Walleij
