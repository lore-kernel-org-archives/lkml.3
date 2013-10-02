Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3JBVUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:20:46 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:48973 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3JBVUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:20:43 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1380670860-17621-4-git-send-email-seanpaul@chromium.org>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
	<1380670860-17621-4-git-send-email-seanpaul@chromium.org>
Date: Wed, 2 Oct 2013 14:20:42 -0700
Message-ID: <CAOesGMjWi3Bk+OtfWjkgHqLk+Zb7cHRjS9S0AfpcPU3UqB+UTw@mail.gmail.com>
Subject: Re: [PATCH 3/5] drm/bridge: Add PTN3460 bridge driver
From: Olof Johansson <olof@lixom.net>
To: Sean Paul <seanpaul@chromium.org>
Cc: dri-devel@lists.freedesktop.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Inki Dae <inki.dae@samsung.com>, airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, Oct 1, 2013 at 4:40 PM, Sean Paul <seanpaul@chromium.org> wrote:
> This patch adds a drm_bridge driver for the PTN3460 DisplayPort to LVDS
> bridge chip.
>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> ---

[...]

> +Example:
> +       ptn3460-bridge@20 {

Nit: Name is usually generic device name, i.e. "lvds-bridge" or
something like that.

> +               compatible = "nxp,ptn3460";
> +               reg = <0x20>;
> +               powerdown-gpio = <&gpy2 5 1 0 0>;
> +               reset-gpio = <&gpx1 5 1 0 0>;
> +               edid-emulation = <5>;
> +       };

[...]


> diff --git a/include/drm/bridge/ptn3460.h b/include/drm/bridge/ptn3460.h
> new file mode 100644
> index 0000000..157ffa1
> --- /dev/null
> +++ b/include/drm/bridge/ptn3460.h
> @@ -0,0 +1,36 @@
> +/*
> + * Copyright (C) 2013 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _DRM_BRIDGE_PTN3460_H_
> +#define _DRM_BRIDGE_PTN3460_H_
> +
> +struct drm_device;
> +struct drm_encoder;
> +struct i2c_client;
> +struct device_node;
> +
> +#ifdef CONFIG_DRM_PTN3460
> +
> +int ptn3460_init(struct drm_device *dev, struct drm_encoder *encoder,
> +               struct i2c_client *client, struct device_node *node);
> +#else
> +
> +int ptn3460_init(struct drm_device *dev, struct drm_encoder *encoder,
> +               struct i2c_client *client, struct device_node *node)

This should be static inline int ptn3460_init(...)

> +{
> +       return 0;
> +}


-0Olof
