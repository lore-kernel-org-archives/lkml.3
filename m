Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3KVJbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:31:32 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37858 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3KVJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:31:27 -0500
Date: Fri, 22 Nov 2013 09:31:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3 1/5] mfd: max14577: Add max14577 MFD driver core
Message-ID: <20131122093118.GH23067@lee--X1>
References: <1385109972-28059-1-git-send-email-k.kozlowski@samsung.com>
 <1385109972-28059-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385109972-28059-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013, Krzysztof Kozlowski wrote:

> From: Chanwoo Choi <cw00.choi@samsung.com>
> 
> This patch adds max14577 core/irq driver to support MUIC(Micro USB IC)
> device and charger device and support irq domain method to control
> internal interrupt of max14577 device. Also, this patch supports DT
> binding with max14577_i2c_parse_dt().
> 
> The MAXIM 14577 chip contains Micro-USB Interface Circuit and Li+ Battery
> Charger. It contains accessory and USB charger detection logic. It supports
> USB 2.0 Hi-Speed, UART and stereo audio signals over Micro-USB connector.
> 
> The battery charger is compliant with the USB Battery Charging Specification
> Revision 1.1. It has also SFOUT LDO output for powering USB devices.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/Kconfig                  |   13 ++
>  drivers/mfd/Makefile                 |    1 +
>  drivers/mfd/max14577.c               |  241 +++++++++++++++++++++++++
>  include/linux/mfd/max14577-private.h |  324 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max14577.h         |   70 ++++++++
>  5 files changed, 649 insertions(+)
>  create mode 100644 drivers/mfd/max14577.c
>  create mode 100644 include/linux/mfd/max14577-private.h
>  create mode 100644 include/linux/mfd/max14577.h

<snip>

> +static struct mfd_cell max14577_devs[] = {
> +	{ .name = "max14577-muic", },
> +	{ .name = "max14577-regulator", },
> +	{ .name = "max14577-charger", },
> +};

If these all support device tree, shouldn't you be populating
max14577_devs[x].of_compatible too? That way the MFD core will
automatically setup your dev.of_node pointers for you?

<snip>

> +	max14577->vendor_id = (reg_data & 0x7);
> +	max14577->device_id = ((reg_data & 0xF8) >> 0x3);

I'm not too keen on these magic numbers, can you create #defines for
them please? If there are any other interesting address, it might be
worth creating some for those too.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
