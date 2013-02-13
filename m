Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab3BMAha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:37:30 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42109 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3BMAh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:37:28 -0500
MIME-Version: 1.0
In-Reply-To: <1355348028-19017-1-git-send-email-sjg@chromium.org>
References: <1355348028-19017-1-git-send-email-sjg@chromium.org>
Date: Tue, 12 Feb 2013 16:37:27 -0800
X-Google-Sender-Auth: B5U8s6naqv8NXNtj1w5snKzpdjc
Message-ID: <CAPnjgZ3OKUSxZLgu976RD3tRaMDzscL31TMx_tyzm22GmqnznQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add ChromeOS Embedded Controller support
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Simon Glass <sjg@chromium.org>,
        linux-input@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Roland Stigge <stigge@antcom.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Che-Liang Chiou <clchiou@chromium.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jonathan Kliegman <kliegs@chromium.org>, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Wolfram Sang <w.sang@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Luigi Semenzato <semenzato@chromium.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, Dec 12, 2012 at 1:33 PM, Simon Glass <sjg@chromium.org> wrote:
> (get_maintainer.pl has produced an enormous list - I hope you are all
> interested.)
>
> The ChromeOS Embedded Controller (EC) is an Open Source EC implementation
> used on ARM and Intel Chromebooks. Current implementations use a Cortex-M3
> connected on a bus (such as I2C, SPI, LPC) to the AP. A separate interrupt
> line is used to indicate when the EC needs service.
>
> Functions performed by the EC vary by platform, but typically include
> battery charging, keyboard scanning and power sequencing.
>
> This series includes support for the EC message protocol, and implements
> a matrix keyboard handler for Linux using the protocol. The EC performs
> key scanning and passes scan data in response to AP requests. This is
> used on the Samsung ARM Chromebook. No driver is available for LPC at
> present.
>
> This series can in principle operate on any hardware, but for it to actually
> work on the Samsung ARM Chromebook, it needs patches which are currently in
> progress to mainline: Exynos FDT interrupt support and I2C bus arbitration.
>
> The driver is device-tree-enabled and a suitable binding is included in
> this series. Example device tree nodes are included in the examples,
> but no device tree patch for exynos5250-snow is provided at this stage, since
> we must wait for the above-mentioned patches to land to avoid errors from
> dtc. This can be added with a follow-on patch when that work is complete.
>
>
> Simon Glass (5):
>   mfd: Add ChromeOS EC messages header
>   mfd: Add ChromeOS EC implementation
>   mfd: Add ChromeOS EC I2C driver
>   mfd: Add ChromeOS EC SPI driver
>   Input: Add ChromeOS EC keyboard driver

Are you planning to pick the mfd part of this series please? I am
going to send a new version of the input patch on its own now that the
DT binding is agreed.

Regards,
Simon

>
>  .../devicetree/bindings/input/cros-ec-keyb.txt     |   77 ++
>  Documentation/devicetree/bindings/mfd/cros-ec.txt  |   56 +
>  drivers/input/keyboard/Kconfig                     |   10 +
>  drivers/input/keyboard/Makefile                    |    1 +
>  drivers/input/keyboard/cros_ec_keyb.c              |  413 ++++++
>  drivers/mfd/Kconfig                                |   28 +
>  drivers/mfd/Makefile                               |    3 +
>  drivers/mfd/cros_ec.c                              |  219 ++++
>  drivers/mfd/cros_ec_i2c.c                          |  262 ++++
>  drivers/mfd/cros_ec_spi.c                          |  412 ++++++
>  include/linux/mfd/cros_ec.h                        |  190 +++
>  include/linux/mfd/cros_ec_commands.h               | 1369 ++++++++++++++++++++
>  12 files changed, 3040 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/cros-ec-keyb.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/cros-ec.txt
>  create mode 100644 drivers/input/keyboard/cros_ec_keyb.c
>  create mode 100644 drivers/mfd/cros_ec.c
>  create mode 100644 drivers/mfd/cros_ec_i2c.c
>  create mode 100644 drivers/mfd/cros_ec_spi.c
>  create mode 100644 include/linux/mfd/cros_ec.h
>  create mode 100644 include/linux/mfd/cros_ec_commands.h
>
> --
> 1.7.7.3
>
