Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaHGHKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 03:10:46 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43909 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaHGHKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 03:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <1406299645-29043-1-git-send-email-acourbot@nvidia.com>
References: <1406299645-29043-1-git-send-email-acourbot@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 7 Aug 2014 16:10:24 +0900
Message-ID: <CAAVeFu+c5Wx3wExeqpFX3YfGisZwr32XbgPo6f7FpOpieiZR3w@mail.gmail.com>
Subject: Re: [PATCH] drm/panel: simple: Use devm_gpiod_get_optional()
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, Thierry?

On Fri, Jul 25, 2014 at 11:47 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Use the new devm_gpiod_get_optional() to simplify the probe code.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> index a251361..91bf566 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -185,16 +185,14 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
>         if (IS_ERR(panel->supply))
>                 return PTR_ERR(panel->supply);
>
> -       panel->enable_gpio = devm_gpiod_get(dev, "enable");
> +       panel->enable_gpio = devm_gpiod_get_optional(dev, "enable");
>         if (IS_ERR(panel->enable_gpio)) {
>                 err = PTR_ERR(panel->enable_gpio);
> -               if (err != -ENOENT) {
> -                       dev_err(dev, "failed to request GPIO: %d\n", err);
> -                       return err;
> -               }
> +               dev_err(dev, "failed to request GPIO: %d\n", err);
> +               return err;
> +       }
>
> -               panel->enable_gpio = NULL;
> -       } else {
> +       if (panel->enable_gpio) {
>                 err = gpiod_direction_output(panel->enable_gpio, 0);
>                 if (err < 0) {
>                         dev_err(dev, "failed to setup GPIO: %d\n", err);
> --
> 2.0.2
>
