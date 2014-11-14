Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaKNH1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 02:27:00 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:60379 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbaKNH06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 02:26:58 -0500
MIME-Version: 1.0
In-Reply-To: <1415917702-6742-2-git-send-email-khilman@kernel.org>
References: <1415917702-6742-1-git-send-email-khilman@kernel.org>
	<1415917702-6742-2-git-send-email-khilman@kernel.org>
Date: Fri, 14 Nov 2014 08:26:58 +0100
Message-ID: <CAPDyKFou5iwX2Oe9K6n=2u6xRAqUtVNRrDn736oo0kGf0GgaLQ@mail.gmail.com>
Subject: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when
 genpd enabled
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2014 23:28, Kevin Hilman <khilman@kernel.org> wrote:
> From: Kevin Hilman <khilman@linaro.org>
>
> It makes little sense to use generic power domains without runtime PM.
> Also, since the complexities of handling the !PM_RUNTIME case are
> causing more trouble and confusion than they're worth, let's simplify
> the world by making genpd always enable runtime PM.

I do agree that your above statement seems reasonable, even if can't
really tell if that would break some SOCs use-cases.

My concern is though, that I fear we will be taking short-cuts in
genpd that might bite us later on, but I might be wrong.

The reason for my concern is that on every other place, like in the
subsystem level, driver core, PM core and of course in drivers -  we
need to cope with all the combinations of CONFIG_PM_SLEEP and
CONFIG_PM_SLEEP.  So theoretically, why shouldn't genpd be able to do
that as well?

>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/power/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index 3d39cc0228e9..2a8c64d0a43c 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -271,7 +271,7 @@ config PM_CLK
>
>  config PM_GENERIC_DOMAINS
>         bool
> -       depends on PM
> +       select PM_RUNTIME

Shouldn't we actually depend on PM_RUNTIME instead?

>
>  config WQ_POWER_EFFICIENT_DEFAULT
>         bool "Enable workqueue power-efficient mode by default"
> --
> 2.1.3
>

Kind regards
Uffe
