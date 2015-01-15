Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbbAOHlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:41:20 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50590 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbbAOHlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:41:16 -0500
MIME-Version: 1.0
In-Reply-To: <1421302535-9369-1-git-send-email-hl@rock-chips.com>
References: <1421302535-9369-1-git-send-email-hl@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 15 Jan 2015 15:40:55 +0800
X-Google-Sender-Auth: Dr3mVIotT4FqBfcWMjD5_jCvvFM
Message-ID: <CAGS+omA5bNBW8NfE2Y7NtW6o5ubCZGUcYyZxFjiJ3MHaNKNQ5g@mail.gmail.com>
Subject: Re: [PATCH v2] drm/panel: Add support for AUO b101ean01 panel
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

On Thu, Jan 15, 2015 at 2:15 PM, huang lin <hl@rock-chips.com> wrote:
> The AUO b101ean01 panel is a 10.1" 1280x800 panel,
> which can be supported by the simple panel driver.
>
> Signed-off-by: huang lin <hl@rock-chips.com>
>
> ---
>
> Changes in v2:
> - changed panel timing
>
>  drivers/gpu/drm/panel/panel-simple.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> index e95385b..c02f0e6 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -392,6 +392,29 @@ static const struct panel_desc auo_b116xw03 = {
>         },
>  };
>
> +static const struct drm_display_mode auo_b101ean01_mode = {

Perhaps you missed my last review where I suggested moving the
definitions for auo_b101ean01 under auo_b101aw03.
With that change, this patch is

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

> +       .clock = 72500,
> +       .hdisplay = 1280,
> +       .hsync_start = 1280 + 147,
> +       .hsync_end = 1280 + 147 + 32,
> +       .htotal = 1280 + 147 + 32 + 21,
> +       .vdisplay = 800,
> +       .vsync_start = 800 + 4,
> +       .vsync_end = 800 + 4 + 4,
> +       .vtotal = 800 + 4 + 4 + 8,
> +       .vrefresh = 60,
> +};
> +
> +static const struct panel_desc auo_b101ean01 = {
> +       .modes = &auo_b101ean01_mode,
> +       .num_modes = 1,
> +       .bpc = 6,
> +       .size = {
> +               .width = 217,
> +               .height = 136,
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
