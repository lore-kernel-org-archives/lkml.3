Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3HWRmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:42:35 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:42512 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3HWRmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:42:32 -0400
MIME-Version: 1.0
In-Reply-To: <1377134300-25480-1-git-send-email-syin@broadcom.com>
References: <1376606573-15093-1-git-send-email-syin@broadcom.com>
	<1377134300-25480-1-git-send-email-syin@broadcom.com>
Date: Fri, 23 Aug 2013 19:42:32 +0200
Message-ID: <CACRpkdZeET601+jOsjQxu-VAhi1owgtMX60Fij=uU489eGVFXg@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: Pass all configs to driver on pin_config_set()
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, Matt Porter <matt.porter@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 3:18 AM, Sherman Yin <syin@broadcom.com> wrote:

> When setting pin configuration in the pinctrl framework, pin_config_set() or
> pin_config_group_set() is called in a loop to set one configuration at a time
> for the specified pin or group.
>
> This patch 1) removes the loop and 2) changes the API to pass the whole pin
> config array to the driver.  It is now up to the driver to loop through the
> configs.  This allows the driver to potentially combine configs and reduce the
> number of writes to pin config registers.
>
> All c files changed have been build-tested to verify the change compiles and
> that the corresponding .o is successfully generated.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>

Didn't you get review from Stephen Warren?

> ---
> Please refer to the discussion with Linus W. "[PATCH] ARM: Adds pin config API
> to set all configs in one function" here:
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166567.html
>
> All c files changed have been build-tested to verify the change compiles and
> that the corresponding .o are successfully generated.
>
> [v2]    rebased on LinusW's linux-pinctrl.git "devel" branch.  Fixed and build-
>         tested pinctrl-sunxi.c
> ---
>  drivers/pinctrl/mvebu/pinctrl-mvebu.c |   26 +++--
>  drivers/pinctrl/pinconf.c             |   42 ++++----
>  drivers/pinctrl/pinctrl-abx500.c      |  187 ++++++++++++++++++---------------
>  drivers/pinctrl/pinctrl-at91.c        |   48 +++++----
>  drivers/pinctrl/pinctrl-bcm2835.c     |   43 ++++----
>  drivers/pinctrl/pinctrl-exynos5440.c  |  113 +++++++++++---------
>  drivers/pinctrl/pinctrl-falcon.c      |   63 ++++++-----
>  drivers/pinctrl/pinctrl-imx.c         |   28 ++---
>  drivers/pinctrl/pinctrl-mxs.c         |   91 ++++++++--------
>  drivers/pinctrl/pinctrl-nomadik.c     |  125 ++++++++++++----------
>  drivers/pinctrl/pinctrl-rockchip.c    |   57 ++++++----
>  drivers/pinctrl/pinctrl-samsung.c     |   17 ++-
>  drivers/pinctrl/pinctrl-single.c      |   33 ++++--
>  drivers/pinctrl/pinctrl-st.c          |   11 +-
>  drivers/pinctrl/pinctrl-sunxi.c       |   95 +++++++++--------
>  drivers/pinctrl/pinctrl-tegra.c       |   69 ++++++------
>  drivers/pinctrl/pinctrl-tz1090-pdc.c  |  135 ++++++++++++++----------
>  drivers/pinctrl/pinctrl-tz1090.c      |  140 +++++++++++++-----------
>  drivers/pinctrl/pinctrl-u300.c        |   18 ++--
>  drivers/pinctrl/pinctrl-xway.c        |  119 +++++++++++++--------
>  drivers/pinctrl/sh-pfc/pinctrl.c      |   42 ++++----
>  drivers/pinctrl/vt8500/pinctrl-wmt.c  |   54 +++++-----
>  include/linux/pinctrl/pinconf.h       |    6 +-
>  23 files changed, 889 insertions(+), 673 deletions(-)

Please try to put all the maintainers for the above files on the To: line
so they get a chance to review/ack the patch.

Yours,
Linus Walleij
