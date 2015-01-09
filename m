Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbbAICDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:03:16 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:36539 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbAICDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:03:15 -0500
MIME-Version: 1.0
In-Reply-To: <1420768075-22588-1-git-send-email-hl@rock-chips.com>
References: <1420768075-22588-1-git-send-email-hl@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 9 Jan 2015 10:02:38 +0800
X-Google-Sender-Auth: mukVXZ4FIMn6iJ0oA2ew98sYCxI
Message-ID: <CAGS+omCa1WRdR-rH86DppvPs=HNeRmnUP2fWyP_LOnznNZ+MGA@mail.gmail.com>
Subject: Re: [PATCH] drm/panel: Add support for AUO b101ean01 panel
To: huang lin <hl@rock-chips.com>
Cc: Douglas Anderson <dianders@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hl,

Thanks for submitting this patch.

On Fri, Jan 9, 2015 at 9:47 AM, huang lin <hl@rock-chips.com> wrote:
>
> The AUO b101ean01 panel is a 10.1" 1280x800 panel,
> which can be supported by the simple panel driver.
>
> Signed-off-by: huang lin <hl@rock-chips.com>
>
> ---
>
>  drivers/gpu/drm/panel/panel-simple.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> index e95385b..4f2baee 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -392,6 +392,29 @@ static const struct panel_desc auo_b116xw03 = {
>         },
>  };
>

nit: I think this hunk should go after auo_b101aw03, to match the
(alphabetical) ordering of platform_of_match[].

> +static const struct drm_display_mode auo_b101ean01_mode = {
> +       .clock = 72500,
> +       .hdisplay = 1280,
> +       .hsync_start = 1280 + 200,
> +       .hsync_end = 1280 + 200 + 147,
> +       .htotal = 1280 + 200 + 147 + 32,
> +       .vdisplay = 800,
> +       .vsync_start = 800 + 16,
> +       .vsync_end = 800 + 16 + 4,
> +       .vtotal = 800 + 16 + 4 + 4,
> +       .vrefresh = 60,
> +};
> +
> +static const struct panel_desc auo_b101ean01 = {
> +       .modes = &auo_b101ean01_mode,
> +       .num_modes = 1,
> +       .bpc = 6,
> +       .size = {
> +               .width = 228,
> +               .height = 148,
> +       },
> +};
> +
>  static const struct drm_display_mode auo_b133xtn01_mode = {
>         .clock = 69500,
>         .hdisplay = 1366,
> @@ -727,6 +750,9 @@ static const struct of_device_id platform_of_match[] = {
>                 .compatible = "auo,b101aw03",
>                 .data = &auo_b101aw03,
>         }, {
> +               .compatible = "auo,b101ean01",
> +               .data = &auo_b101ean01,
> +       }, {
>                 .compatible = "auo,b101xtn01",
>                 .data = &auo_b101xtn01,
>         }, {
> --
> 1.9.1
>
>
