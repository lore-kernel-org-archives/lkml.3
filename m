Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3GJNXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:23:35 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:33297 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3GJNXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:23:34 -0400
MIME-Version: 1.0
In-Reply-To: <1373454996-21706-1-git-send-email-geert@linux-m68k.org>
References: <1373454996-21706-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 10 Jul 2013 09:23:33 -0400
Message-ID: <CADnq5_M5L8UCGuj1eCorzt440sCuciPkXPvgx0Laq4s1TNktaQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] drm/edid: Fix constness warning in drm_load_edid_firmware()
From: Alex Deucher <alexdeucher@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 7:16 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> drivers/gpu/drm/drm_edid_load.c: In function ‘drm_load_edid_firmware’:
> drivers/gpu/drm/drm_edid_load.c:245: warning: initialization discards qualifiers from pointer target type
>
> drm_get_connector_name() returns a "const char *", hence propagate the
> const where needed.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

For the series:

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/drm_edid_load.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
> index a4f5ce1..2c2803f 100644
> --- a/drivers/gpu/drm/drm_edid_load.c
> +++ b/drivers/gpu/drm/drm_edid_load.c
> @@ -134,7 +134,7 @@ static u8 generic_edid[GENERIC_EDIDS][128] = {
>  };
>
>  static u8 *edid_load(struct drm_connector *connector, char *name,
> -                       char *connector_name)
> +                       const char *connector_name)
>  {
>         const struct firmware *fw;
>         struct platform_device *pdev;
> @@ -242,7 +242,7 @@ out:
>
>  int drm_load_edid_firmware(struct drm_connector *connector)
>  {
> -       char *connector_name = drm_get_connector_name(connector);
> +       const char *connector_name = drm_get_connector_name(connector);
>         char *edidname = edid_firmware, *last, *colon;
>         int ret;
>         struct edid *edid;
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
