Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaA3T2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:28:10 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59517 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaA3T2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:28:09 -0500
MIME-Version: 1.0
Date: Thu, 30 Jan 2014 14:28:08 -0500
X-Google-Sender-Auth: jTI5xYYpYKB3OgxBzT6VaaFJ5Ag
Message-ID: <CA+5PVA555XRvPfnJpDU2t-iCA1Ay2F-pxWACO_Hj_XBzjScK1w@mail.gmail.com>
Subject: imx-hdmi fails to build with v3.13-10094-g9b0cd30
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Fabio Estevam <fabio.estevam@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@gmail.com>
Cc: devel@driverdev.osuosl.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

After the DRM merge the imx-hdmi driver fails to build with the error
below.  I'm somewhat surprised this wasn't hit in linux-next.

josh

drivers/staging/imx-drm/imx-hdmi.c:55:6: error: nested redefinition of
'enum hdmi_colorimetry'
 enum hdmi_colorimetry {
      ^
drivers/staging/imx-drm/imx-hdmi.c:55:6: error: redeclaration of 'enum
hdmi_colorimetry'
In file included from include/drm/drm_crtc.h:33:0,
                 from include/drm/drmP.h:711,
                 from drivers/staging/imx-drm/imx-hdmi.c:24:
include/linux/hdmi.h:48:6: note: originally defined here
 enum hdmi_colorimetry {
      ^
make[3]: *** [drivers/staging/imx-drm/imx-hdmi.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/staging/imx-drm] Error 2
make[1]: *** [drivers/staging] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2
+ exit 1
