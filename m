Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab3AQJgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:36:23 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64790 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759421Ab3AQJgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:36:19 -0500
MIME-Version: 1.0
In-Reply-To: <1357555480-24022-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
	<1357555480-24022-7-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 17 Jan 2013 10:36:19 +0100
Message-ID: <CACRpkdZBF0SkW+Ux7+HdsSQwnnxXG6o4yNp9mrmufXD=yrTwTg@mail.gmail.com>
Subject: Re: [PATCH 06/11] spi/pxa2xx: use the private DMA API only when
 CONFIG_ARCH_PXA is set
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        eric.y.miao@gmail.com, linux@arm.linux.org.uk,
        haojian.zhuang@gmail.com, broonie@opensource.wolfsonmicro.com,
        chao.bi@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 11:44 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> The PXA SPI driver uses PXA platform specific private DMA implementation
> which does not work on non-PXA platforms. In order to use this driver on
> other platforms we need to move the private DMA implementation into a
> separate functions that get stubbed out when !CONFIG_ARCH_PXA.
>
> While we are there we can kill the dummy DMA bits in pxa2xx_spi.h as they
> are not needed anymore for CE4100.
>
> Once this is done we can add the generic DMA engine support to the driver
> that allows usage of any DMA controller that implements DMA engine API.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/spi/spi-pxa2xx.c       |  612 +++++++++++++++++++++++-----------------
>  include/linux/spi/pxa2xx_spi.h |   80 ------

Can you even break this out to its own file?

Like drivers/spi/spi-pxa2xx-pxadma.c/.h
with stubs in the header file or something so we need
no #ifdefs in the main driver file?

The kernel looks better after this patch anyway, so
Acked-by: Linus Walleij <linus.walleij@linaro.org>
in any case.

Yours,
Linus Walleij
