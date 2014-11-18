Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaKROWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:22:51 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41029 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaKROWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:22:49 -0500
Date: Tue, 18 Nov 2014 14:22:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: cros_ec: Expose Chrome OS Lightbar to users
Message-ID: <20141118142242.GC24004@x1>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
 <1416238213-15263-4-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416238213-15263-4-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Javier Martinez Canillas wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> This adds some sysfs entries to provide userspace control of the
> four-element LED "lightbar" on the Chromebook Pixel. This only instantiates
> the lightbar controls if the device actually exists.
> 
> To prevent DoS attacks, this interface is limited to 20 accesses/second,
> although that rate can be adjusted by a privileged user.
> 
> On Chromebooks without a lightbar, this should have no effect. On the
> Chromebook Pixel, you should be able to do things like this:
> 
>     $ cd /sys/devices/virtual/chromeos/cros_ec/lightbar
>     $ echo 0x80 > brightness
>     $ echo 255 > brightness
>     $
>     $ cat sequence
>     S0
>     $ echo konami > sequence
>     $ cat sequence
>     KONAMI
>     $
>     $ cat sequence
>     S0
> 
> And
> 
>     $ cd /sys/devices/virtual/chromeos/cros_ec/lightbar
>     $ echo stop > sequence
>     $ echo "4 255 255 255" > led_rgb
>     $ echo "0 255 0 0  1 0 255 0  2 0 0 255  3 255 255 0" > led_rgb
>     $ echo run  > sequence
> 
> Test the DoS prevention with this:
> 
>     $ cd /sys/devices/virtual/chromeos/cros_ec/lightbar
>     $ echo 500 > interval_msec
>     $ time (cat version version version version version version version)
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Reviewed-by: Olof Johansson <olofj@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Benson Leung <bleung@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/mfd/Makefile           |   2 +-
>  drivers/mfd/cros_ec_dev.c      |   2 +
>  drivers/mfd/cros_ec_dev.h      |   3 +
>  drivers/mfd/cros_ec_lightbar.c | 347 +++++++++++++++++++++++++++++++++++++++++

By the sounds of the description, it doesn't seem as though this
driver lives in MFD.  I suggest another home, such as drivers/led.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
