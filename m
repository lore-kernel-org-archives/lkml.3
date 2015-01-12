Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbbALJYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:24:41 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:40798 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbbALJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:24:35 -0500
MIME-Version: 1.0
In-Reply-To: <1418831474-24428-4-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<1418831474-24428-4-git-send-email-ricardo.ribalda@gmail.com>
Date: Mon, 12 Jan 2015 10:24:34 +0100
Message-ID: <CACRpkdYr6OZUjQ8JLzpktQK1xg1Un_SKtU+xr=gFzpSo+A2C-g@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] gpio/xilinx: Add support for X86 Arch
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Darren Hart <dvhart@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 4:51 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> Core can be accessed via PCIe on X86 platform.
> This patch also allows the driver to be used as module.
>
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

PCIe on x86, using device tree? The ACPI people are just gonna love this.

Patch applied, anyway. DT on x86 is not unheard of.

>  config GPIO_XILINX
> -       bool "Xilinx GPIO support"
> -       depends on PPC_OF || MICROBLAZE || ARCH_ZYNQ
> +       tristate "Xilinx GPIO support"
> +       depends on OF_GPIO && (PPC_OF || MICROBLAZE || ARCH_ZYNQ || ARCH_X86)

Maybe you want to add COMPILE_TEST too?

Yours,
Linus Walleij
