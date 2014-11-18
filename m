Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaKRO04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:26:56 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:48462 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbaKRO0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:26:52 -0500
Date: Tue, 18 Nov 2014 14:26:45 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: cros_ec: Create sysfs attributes for the
 ChromeOS EC.
Message-ID: <20141118142645.GD24004@x1>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
 <1416238213-15263-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416238213-15263-3-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Javier Martinez Canillas wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> This adds the first few sysfs attributes for the Chrome OS EC. These
> controls are made available under /sys/devices/virtual/chromeos/cros_ec
> 
>     flashinfo   - display current flash info

drivers/mtd?

>     reboot      - tell the EC to reboot in various ways

drivers/power?

>     version     - information about the EC software and hardware

What's the difference between this version and the version you can
read in the new _dev driver?

> Future changes will build on this to add additional controls.
> 
> From a root shell, you should be able to do things like this:
> 
>     cd /sys/devices/virtual/chromeos/cros_ec
>     cat flashinfo
>     cat version
>     echo rw > reboot
>     cat version
>     echo ro > reboot
>     cat version
>     echo rw > reboot
>     cat version
>     echo cold > reboot
> 
> That last command will reboot the AP too.
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Reviewed-by: Olof Johansson <olofj@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/mfd/Makefile        |   3 +-
>  drivers/mfd/cros_ec_dev.c   |  10 +-
>  drivers/mfd/cros_ec_dev.h   |  26 +++++
>  drivers/mfd/cros_ec_sysfs.c | 271 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 307 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/mfd/cros_ec_dev.h
>  create mode 100644 drivers/mfd/cros_ec_sysfs.c

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
