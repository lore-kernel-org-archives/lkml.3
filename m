Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaAFPpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:45:00 -0500
Received: from [213.199.154.251] ([213.199.154.251]:24513 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbaAFPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:44:59 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z579ehz9371Ic89bh542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh109h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h1155h)
X-WSS-ID: 0MYZL00-08-EB4-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Airlie <airlied@linux.ie>,
        "Daenzer, Michel" <Michel.Daenzer@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH 32/85] drivers: gpu: Move prototype declarations to
 header file atombios.h
Thread-Topic: [PATCH 32/85] drivers: gpu: Move prototype declarations to
 header file atombios.h
Thread-Index: AQHPCvVSFMiGsyQxj0mW2WsY1qhsd5p31eBg
Date: Mon, 6 Jan 2014 15:43:38 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D030AC572A@satlexdag05.amd.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
 <f4d1b2f307e9ebd14d9f397913298d22ffc464f7.1389018325.git.rashika.kheria@gmail.com>
In-Reply-To: <f4d1b2f307e9ebd14d9f397913298d22ffc464f7.1389018325.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s06Fj7R4007435

> -----Original Message-----
> From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
> Sent: Monday, January 06, 2014 10:38 AM
> To: linux-kernel@vger.kernel.org
> Cc: David Airlie; Deucher, Alexander; Rashika Kheria; Daenzer, Michel;
> Koenig, Christian; Dave Airlie; RafaÅ‚ MiÅ‚ecki; Damien Lespiau; dri-
> devel@lists.freedesktop.org; josh@joshtriplett.org
> Subject: [PATCH 32/85] drivers: gpu: Move prototype declarations to header
> file atombios.h
> 
> Move prototype declarations of functions radeon_atom_get_tv_timings()
> and radeon_atombios_connected_scratch_regs() to header file
> drm/radeon/atombios.h because they are used by more than one file.
> 
> Include the header file in atombios_encoders.c, radeon_atombios.c and
> radeon_connectors.c because they use the function whose prototype
> declarations are present in it.

It would be better to add these to radeon_mode.h for consistency with combios.

Alex

> 
> This eliminates the following warnings in drm/radeon/radeon_atombios.c:
> drivers/gpu/drm/radeon/radeon_atombios.c:1766:6: warning: no previous
> prototype for â€˜radeon_atom_get_tv_timingsâ€™ [-Wmissing-prototypes]
> drivers/gpu/drm/radeon/radeon_atombios.c:4012:1: warning: no previous
> prototype for â€˜radeon_atombios_connected_scratch_regsâ€™ [-Wmissing-
> prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/gpu/drm/radeon/atombios.h          |    8 ++++++++
>  drivers/gpu/drm/radeon/atombios_encoders.c |    6 +-----
>  drivers/gpu/drm/radeon/radeon_atombios.c   |    1 +
>  drivers/gpu/drm/radeon/radeon_connectors.c |    5 +----
>  4 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/atombios.h
> b/drivers/gpu/drm/radeon/atombios.h
> index 92be50c..72a3aa7c 100644
> --- a/drivers/gpu/drm/radeon/atombios.h
> +++ b/drivers/gpu/drm/radeon/atombios.h
> @@ -193,6 +193,14 @@
>  #define	OFFSET_TO_GET_ATOMBIOS_STRINGS_NUMBER
> 	0x002f
>  #define	OFFSET_TO_GET_ATOMBIOS_STRINGS_START
> 	0x006e
> 
> +bool radeon_atom_get_tv_timings(struct radeon_device *rdev, int index,
> +				struct drm_display_mode *mode);
> +void
> +radeon_atombios_connected_scratch_regs(struct drm_connector
> *connector,
> +				       struct drm_encoder *encoder,
> +				       bool connected);
> +
> +
>  /* Common header for all ROM Data tables.
>    Every table pointed  _ATOM_MASTER_DATA_TABLE has this common
> header.
>    And the pointer actually points to this header. */
> diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c
> b/drivers/gpu/drm/radeon/atombios_encoders.c
> index a42d615..641298d 100644
> --- a/drivers/gpu/drm/radeon/atombios_encoders.c
> +++ b/drivers/gpu/drm/radeon/atombios_encoders.c
> @@ -28,6 +28,7 @@
>  #include <drm/radeon_drm.h>
>  #include "radeon.h"
>  #include "atom.h"
> +#include "atombios.h"
>  #include <linux/backlight.h>
> 
>  extern int atom_debug;
> @@ -283,11 +284,6 @@ static void radeon_atom_backlight_exit(struct
> radeon_encoder *encoder)
> 
>  #endif
> 
> -/* evil but including atombios.h is much worse */
> -bool radeon_atom_get_tv_timings(struct radeon_device *rdev, int index,
> -				struct drm_display_mode *mode);
> -
> -
>  static inline bool radeon_encoder_is_digital(struct drm_encoder *encoder)
>  {
>  	struct radeon_encoder *radeon_encoder =
> to_radeon_encoder(encoder);
> diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c
> b/drivers/gpu/drm/radeon/radeon_atombios.c
> index 5c39bf7..39f1fd6 100644
> --- a/drivers/gpu/drm/radeon/radeon_atombios.c
> +++ b/drivers/gpu/drm/radeon/radeon_atombios.c
> @@ -28,6 +28,7 @@
>  #include "radeon.h"
> 
>  #include "atom.h"
> +#include "atombios.h"
>  #include "atom-bits.h"
> 
>  /* from radeon_encoder.c */
> diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c
> b/drivers/gpu/drm/radeon/radeon_connectors.c
> index 20a768a..9070487 100644
> --- a/drivers/gpu/drm/radeon/radeon_connectors.c
> +++ b/drivers/gpu/drm/radeon/radeon_connectors.c
> @@ -30,6 +30,7 @@
>  #include <drm/radeon_drm.h>
>  #include "radeon.h"
>  #include "atom.h"
> +#include "atombios.h"
> 
>  #include <linux/pm_runtime.h>
> 
> @@ -37,10 +38,6 @@ extern void
>  radeon_combios_connected_scratch_regs(struct drm_connector
> *connector,
>  				      struct drm_encoder *encoder,
>  				      bool connected);
> -extern void
> -radeon_atombios_connected_scratch_regs(struct drm_connector
> *connector,
> -				       struct drm_encoder *encoder,
> -				       bool connected);
> 
>  void radeon_connector_hotplug(struct drm_connector *connector)
>  {
> --
> 1.7.9.5
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
