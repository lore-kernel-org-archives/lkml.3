Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3EZMwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 08:52:30 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62402 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3EZMw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 08:52:28 -0400
MIME-Version: 1.0
In-Reply-To: <1369572037-10200-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369572037-10200-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 26 May 2013 18:22:06 +0530
Message-ID: <CA+V-a8tKUwZRsxQQORjD2vg16w6UMVCsWKkTSNOvrQ=mBL97Jw@mail.gmail.com>
Subject: Re: [PATCH v4] media: i2c: tvp514x: add OF support
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Sun, May 26, 2013 at 6:10 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> add OF support for the tvp514x driver.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> ---
>  Tested on da850-evm.
>
>  RFC v1: https://patchwork.kernel.org/patch/2030061/
>  RFC v2: https://patchwork.kernel.org/patch/2061811/
>
>  Changes for current version from RFC v2:
>  1: Fixed review comments pointed by Sylwester.
>
>  Changes for v2:
>  1: Listed all the compatible property values in the documentation text file.
>  2: Removed "-decoder" from compatible property values.
>  3: Added a reference to the V4L2 DT bindings documentation to explain
>     what the port and endpoint nodes are for.
>  4: Fixed some Nits pointed by Laurent.
>  5: Removed unnecessary header file includes and sort them alphabetically.
>
>  Changes for v3:
>  1: Rebased on patch https://patchwork.kernel.org/patch/2539411/
>
>  Changes for v4:
>  1: added missing call for of_node_put().
>  2: Rebased the patch on v3.11.
>
>  .../devicetree/bindings/media/i2c/tvp514x.txt      |   45 ++++++++++++++
>  drivers/media/i2c/tvp514x.c                        |   62 ++++++++++++++++++--
>  2 files changed, 101 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> new file mode 100644
> index 0000000..cc09424
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> @@ -0,0 +1,45 @@
> +* Texas Instruments TVP514x video decoder
> +
> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality, single-chip
> +digital video decoder that digitizes and decodes all popular baseband analog
> +video formats into digital video component. The tvp514x decoder supports analog-
> +to-digital (A/D) conversion of component RGB and YPbPr signals as well as A/D
> +conversion and decoding of NTSC, PAL and SECAM composite and S-video into
> +component YCbCr.
> +
> +Required Properties :
> +- compatible : value should be either one among the following
> +       (a) "ti,tvp5146" for tvp5146 decoder.
> +       (b) "ti,tvp5146m2" for tvp5146m2 decoder.
> +       (c) "ti,tvp5147" for tvp5147 decoder.
> +       (d) "ti,tvp5147m1" for tvp5147m1 decoder.
> +
> +- hsync-active: HSYNC Polarity configuration for endpoint.
> +
> +- vsync-active: VSYNC Polarity configuration for endpoint.
> +
> +- pclk-sample: Clock polarity of the endpoint.
> +
> +
> +For further reading of port node refer Documentation/devicetree/bindings/media/
> +video-interfaces.txt.
> +
> +Example:
> +
> +       i2c0@1c22000 {
> +               ...
> +               ...
> +               tvp514x@5c {
> +                       compatible = "ti,tvp5146";
> +                       reg = <0x5c>;
> +
> +                       port {
> +                               tvp514x_1: endpoint {
> +                                       hsync-active = <1>;
> +                                       vsync-active = <1>;
> +                                       pclk-sample = <0>;
> +                               };
> +                       };
> +               };
> +               ...
> +       };
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index 7438e01..803f3b8 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -38,6 +38,7 @@
>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
> +#include <media/v4l2-of.h>
>  #include <media/v4l2-mediabus.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
> @@ -1055,6 +1056,42 @@ static struct tvp514x_decoder tvp514x_dev = {
>
>  };
>
> +static struct tvp514x_platform_data *
> +tvp514x_get_pdata(struct i2c_client *client)
> +{
> +       struct tvp514x_platform_data *pdata = NULL;
> +       struct v4l2_of_endpoint bus_cfg;
> +       struct device_node *endpoint;
> +       unsigned int flags;
> +
> +       if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +               return client->dev.platform_data;
> +
> +       endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +       if (!endpoint)
> +               goto done;
> +
Ahh this had to be return NULL I'll respin a new version fixing it.

Regards,
--Prabhakar Lad
