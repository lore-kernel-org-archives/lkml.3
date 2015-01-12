Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbbALD6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 22:58:51 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60237 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbALD6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 22:58:49 -0500
MIME-Version: 1.0
In-Reply-To: <1420926712-13447-1-git-send-email-linus.walleij@linaro.org>
References: <1420926712-13447-1-git-send-email-linus.walleij@linaro.org>
Date: Mon, 12 Jan 2015 09:28:48 +0530
X-Google-Sender-Auth: tWzaeBS3y8CPNYi0qe0Z7tjcWdA
Message-ID: <CAOh2x=kKrv2cBXsLtpOheVqjbiYCMFxEdUx=cWPwCTP_tG_O_A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pass -DDEBUG in subdirs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-gpio@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 3:21 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> When drivers are compiled in subdirectories the -DDEBUG flag need
> to be passed in the individual Makefiles.

This doesn't look good anymore..

> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Suggested-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> This replaces Mika's patch too.
> ---
>  drivers/pinctrl/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> index c030b3db8034..c7139ba195fe 100644
> --- a/drivers/pinctrl/Makefile
> +++ b/drivers/pinctrl/Makefile
> @@ -1,6 +1,6 @@
>  # generic pinmux support
>
> -ccflags-$(CONFIG_DEBUG_PINCTRL)        += -DDEBUG
> +subdir-ccflags-$(CONFIG_DEBUG_PINCTRL) += -DDEBUG
>
>  obj-$(CONFIG_PINCTRL)          += core.o pinctrl-utils.o
>  obj-$(CONFIG_PINMUX)           += pinmux.o
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
