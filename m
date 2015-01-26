Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbbAZCJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:09:56 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:33406 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbAZCJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:09:53 -0500
MIME-Version: 1.0
In-Reply-To: <1422236845-25672-1-git-send-email-hl@rock-chips.com>
References: <1422236845-25672-1-git-send-email-hl@rock-chips.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 26 Jan 2015 10:09:32 +0800
X-Google-Sender-Auth: vnbeWdi_Frtkd7C1fIi_jF9QJmU
Message-ID: <CAGS+omCeD4X8_L=KevAcjxUFDpfw5fuNhZXK9O3_GBo5H-QMBA@mail.gmail.com>
Subject: Re: [PATCH v4] drm/panel: Add support for AUO b101ean01 panel
To: huang lin <hl@rock-chips.com>
Cc: Douglas Anderson <dianders@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 9:47 AM, huang lin <hl@rock-chips.com> wrote:
> The AUO b101ean01 panel is a 10.1" 1280x800 panel,
> which can be supported by the simple panel driver.
>
> Signed-off-by: huang lin <hl@rock-chips.com>

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

>
> ---
>
> Changes in v4:
> - Add auo,b101ean01.txt file
>
>  .../devicetree/bindings/panel/auo,b101ean01.txt    |  7 ++++++
>  drivers/gpu/drm/panel/panel-simple.c               | 26 ++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/panel/auo,b101ean01.txt
>
> diff --git a/Documentation/devicetree/bindings/panel/auo,b101ean01.txt b/Documentation/devicetree/bindings/panel/auo,b101ean01.txt
> new file mode 100644
> index 0000000..3590b07
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/panel/auo,b101ean01.txt
> @@ -0,0 +1,7 @@
> +AU Optronics Corporation 10.1" WSVGA TFT LCD panel
> +
> +Required properties:
> +- compatible: should be "auo,b101ean01"
> +
> +This binding is compatible with the simple-panel binding, which is specified
> +in simple-panel.txt in this directory.
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> index e95385b..24828e0 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -345,6 +345,29 @@ static const struct panel_desc auo_b101aw03 = {
>         },
>  };
>
> +static const struct drm_display_mode auo_b101ean01_mode = {
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
>  static const struct drm_display_mode auo_b101xtn01_mode = {
>         .clock = 72000,
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
