Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3FQFqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:46:52 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:59464 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3FQFqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <06f2fd99878260f42468d607eb7878dd4f59c6ef.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
	<06f2fd99878260f42468d607eb7878dd4f59c6ef.1370262666.git.michal.simek@xilinx.com>
Date: Mon, 17 Jun 2013 07:46:50 +0200
Message-ID: <CACRpkdbHviP-n_Azso+WcqYeoENNtYjKVbWMp5nbeMt310_LGQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] GPIO: xilinx: Use __raw_readl/__raw_writel IO functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 2:31 PM, Michal Simek <michal.simek@xilinx.com> wrote:

> This driver can be used on Xilinx ARM Zynq platform
> where in_be32/out_be32 functions are not implemented.
> Use __raw_readl/__raw_writel functions which are
> implemented on Microblaze and PowerPC.
> For ARM readl/writel functions are used instead.
>
> The correct way how to implement this is to detect
> endians directly on IP. But for the gpio case
> without interrupt connected(it means without
> interrupt logic) there are just 2 registers
> data and tristate where auto detection can't be done.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Changes in v2:
> - New patch in this series
>
> I have chosen to use readl/writel for ARM because
> of barriers and keep __raw versions for microblaze
> and ppc where this is not a problem.
> The reason why in_be32/out_be32 can't be used
> is that it won't work on Microblaze LE when
> I fix Microblaze IO function implementation which
> is broken right now.

Makes perfect sense.

Patch applied.

Yours,
Linus Walleij
