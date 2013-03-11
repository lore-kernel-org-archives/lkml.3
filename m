Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3CKVCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:02:04 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59203 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3CKVCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:02:01 -0400
MIME-Version: 1.0
In-Reply-To: <1363031174-22525-1-git-send-email-gheorghiuandru@gmail.com>
References: <1363031174-22525-1-git-send-email-gheorghiuandru@gmail.com>
Date: Mon, 11 Mar 2013 22:01:59 +0100
Message-ID: <CAMeQTsb5Tqx8ts=FYS42TQhOAnbwRx7e7n-2UEL9e6BWvdPESg@mail.gmail.com>
Subject: Re: [PATCH] drivers: gpu: drm: gma500: Replaced calls kzalloc &
 memcpy with kmemdup
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alan Cox <alan@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 8:46 PM, Alexandru Gheorghiu
<gheorghiuandru@gmail.com> wrote:
> Replaced calls kzalloc followed by memcpy with call to kmemdup.
> Patch found using coccinelle.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  drivers/gpu/drm/gma500/intel_bios.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/gma500/intel_bios.c b/drivers/gpu/drm/gma500/intel_bios.c
> index 403fffb..d349734 100644
> --- a/drivers/gpu/drm/gma500/intel_bios.c
> +++ b/drivers/gpu/drm/gma500/intel_bios.c
> @@ -218,12 +218,11 @@ static void parse_backlight_data(struct drm_psb_private *dev_priv,
>         bl_start = find_section(bdb, BDB_LVDS_BACKLIGHT);
>         vbt_lvds_bl = (struct bdb_lvds_backlight *)(bl_start + 1) + p_type;
>
> -       lvds_bl = kzalloc(sizeof(*vbt_lvds_bl), GFP_KERNEL);
> +       lvds_bl = kmemdup(vbt_lvds_bl, sizeof(*vbt_lvds_bl), GFP_KERNEL);
>         if (!lvds_bl) {
>                 dev_err(dev_priv->dev->dev, "out of memory for backlight data\n");
>                 return;
>         }
> -       memcpy(lvds_bl, vbt_lvds_bl, sizeof(*vbt_lvds_bl));
>         dev_priv->lvds_bl = lvds_bl;
>  }
>
> --
> 1.7.9.5

Reviewed-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
