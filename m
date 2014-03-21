Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156AbaCUJgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:36:22 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:41826 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760391AbaCUJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:36:18 -0400
Date: Fri, 21 Mar 2014 09:36:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC 6/8] leds: Add support for max77693 mfd flash cell
Message-ID: <20140321093611.GD15213@lee--X1>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-7-git-send-email-j.anaszewski@samsung.com>
 <20140320153443.GD8207@lee--X1>
 <532BF6E3.10003@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <532BF6E3.10003@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>This patch adds led-flash support to Maxim max77693 chipset.
> >>Device can be exposed to user space through LED subsystem
> >>sysfs interface or through V4L2 subdevice when the support
> >>for Multimedia Framework is enabled. Device supports up to
> >>two leds which can work in flash and torch mode. Leds can
> >>be triggered externally or by software.
> >>
> >>Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Bryan Wu <cooloney@gmail.com>
> >>Cc: Richard Purdie <rpurdie@rpsys.net>
> >>Cc: SangYoung Son <hello.son@smasung.com>
> >>Cc: Samuel Ortiz <sameo@linux.intel.com>
> >>Cc: Lee Jones <lee.jones@linaro.org>
> >>---
> >>  drivers/leds/Kconfig         |    9 +
> >>  drivers/leds/Makefile        |    1 +
> >>  drivers/leds/leds-max77693.c |  768 ++++++++++++++++++++++++++++++++++++++++++
> >>  drivers/mfd/max77693.c       |   21 +-
> >>  include/linux/mfd/max77693.h |   32 ++
> >>  5 files changed, 825 insertions(+), 6 deletions(-)
> >>  create mode 100644 drivers/leds/leds-max77693.c
> >
> >[...]
> >>-static const struct mfd_cell max77693_devs[] = {
> >>-	{ .name = "max77693-pmic", },
> >>-	{ .name = "max77693-charger", },
> >>-	{ .name = "max77693-flash", },
> >>-	{ .name = "max77693-muic", },
> >>-	{ .name = "max77693-haptic", },
> >>+enum mfd_devs_idx {
> >>+	IDX_PMIC,
> >>+	IDX_CHARGER,
> >>+	IDX_LED,
> >>+	IDX_MUIC,
> >>+	IDX_HAPTIC,
> >>+};
> >>+
> >>+static struct mfd_cell max77693_devs[] = {
> >>+	[IDX_PMIC]      = { .name = "max77693-pmic", },
> >>+	[IDX_CHARGER]   = { .name = "max77693-charger", },
> >>+	[IDX_LED]       = { .name = "max77693-led",
> >>+			    .of_compatible = "maxim,max77693-led"},
> >>+	[IDX_MUIC]      = { .name = "max77693-muic", },
> >>+	[IDX_HAPTIC]    = { .name = "max77693-haptic", },
> >>  };
> >
> >What is the purpose of this change?
> >
> Introducing mfd_devs_idx itself is a cosmetic change, which
> actually could be avoided. Initialization of the of_compatible field
> is required for the led driver to get matched properly. And as I've
> just realized also max77693-flash name should be preserved.
> I will fix this in the next version of the patch.

I'm happy with the addition of any .of_compatible strings, however
please leave out the IDXs in your next version(s).

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
