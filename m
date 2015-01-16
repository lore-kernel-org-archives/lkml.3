Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbbAPMSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:18:15 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:37872 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbbAPMSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:18:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAGS+omAvxNFaVkKJs2e4fWF-xeuMHrYSHFFeJZtdPETx+o4LFw@mail.gmail.com>
References: <1421375817-21793-1-git-send-email-hl@rock-chips.com> <CAGS+omAvxNFaVkKJs2e4fWF-xeuMHrYSHFFeJZtdPETx+o4LFw@mail.gmail.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 16 Jan 2015 20:17:51 +0800
X-Google-Sender-Auth: -aqm_QktPKM3G5burzqOh-FFmjU
Message-ID: <CAGS+omCgG9vu1hB_63m3VFV7OTcQ-KXUV-ba5J5LtFhm2JZKBQ@mail.gmail.com>
Subject: Re: [PATCH v3] drm/panel: Add support for AUO b101ean01 panel
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

On Fri, Jan 16, 2015 at 11:14 AM, Daniel Kurtz <djkurtz@chromium.org> wrote:
>
> On Fri, Jan 16, 2015 at 10:36 AM, huang lin <hl@rock-chips.com> wrote:
> > The AUO b101ean01 panel is a 10.1" 1280x800 panel,
> > which can be supported by the simple panel driver.
> >
> > Signed-off-by: huang lin <hl@rock-chips.com>
>

Thierry is going to point out  that this patch is missing devicetree
documentation, so I'll beat him to the punch :-).
Please add an "auo,b101ean01" entry to:
  Documentation/devicetree/bindings/panel/

With the above documentation this is:

>
> >
> > ---
> >
> > Changes in v3:
> > - changed moving auo_b101ean01 definitions under auo_b101aw03
> >
> >  drivers/gpu/drm/panel/panel-simple.c | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> > index e95385b..24828e0 100644
> > --- a/drivers/gpu/drm/panel/panel-simple.c
> > +++ b/drivers/gpu/drm/panel/panel-simple.c
> > @@ -345,6 +345,29 @@ static const struct panel_desc auo_b101aw03 = {
> >         },
> >  };
> >
> > +static const struct drm_display_mode auo_b101ean01_mode = {
> > +       .clock = 72500,
> > +       .hdisplay = 1280,
> > +       .hsync_start = 1280 + 147,
> > +       .hsync_end = 1280 + 147 + 32,
> > +       .htotal = 1280 + 147 + 32 + 21,
> > +       .vdisplay = 800,
> > +       .vsync_start = 800 + 4,
> > +       .vsync_end = 800 + 4 + 4,
> > +       .vtotal = 800 + 4 + 4 + 8,
> > +       .vrefresh = 60,
> > +};
> > +
> > +static const struct panel_desc auo_b101ean01 = {
> > +       .modes = &auo_b101ean01_mode,
> > +       .num_modes = 1,
> > +       .bpc = 6,
> > +       .size = {
> > +               .width = 217,
> > +               .height = 136,
> > +       },
> > +};
> > +
> >  static const struct drm_display_mode auo_b101xtn01_mode = {
> >         .clock = 72000,
> >         .hdisplay = 1366,
> > @@ -727,6 +750,9 @@ static const struct of_device_id platform_of_match[] = {
> >                 .compatible = "auo,b101aw03",
> >                 .data = &auo_b101aw03,
> >         }, {
> > +               .compatible = "auo,b101ean01",
> > +               .data = &auo_b101ean01,
> > +       }, {
> >                 .compatible = "auo,b101xtn01",
> >                 .data = &auo_b101xtn01,
> >         }, {
> > --
> > 1.9.1
> >
> >
