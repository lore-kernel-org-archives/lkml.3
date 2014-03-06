Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaCFP6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:58:49 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:32971 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaCFP6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:58:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140306135019.GF18529@joshc.qualcomm.com>
References: <1393369261-17469-1-git-send-email-delicious.quinoa@gmail.com>
	<20140306135019.GF18529@joshc.qualcomm.com>
Date: Thu, 6 Mar 2014 09:58:28 -0600
Message-ID: <CANk1AXTZFKH45qmGip8sc5KYxHNwfZqogrPfXOzz+sz-xyuosw@mail.gmail.com>
Subject: Re: [PATCH v12] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Linus Walleij <linus.walleij@linaro.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 7:50 AM, Josh Cartwright <joshc@codeaurora.org> wrote:
> On Tue, Feb 25, 2014 at 05:01:01PM -0600, Alan Tull wrote:
>> From: Jamie Iles <jamie@jamieiles.com>
>>
>> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
>> and can be configured to provide multiple banks of GPIO pins.
>>
>> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
>> Signed-off-by: Alan Tull <atull@altera.com>
>> Reviewed-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> [..]
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -128,6 +128,15 @@ config GPIO_GENERIC_PLATFORM
>>       help
>>         Say yes here to support basic platform_device memory-mapped GPIO controllers.
>>
>> +config GPIO_DWAPB
>> +     tristate "Synopsys DesignWare APB GPIO driver"
>> +     select GPIO_GENERIC
>> +     select GENERIC_IRQ_CHIP
>> +     depends on OF_GPIO && IRQ_DOMAIN
>> +     help
>> +       Say Y or M here to build support for the Synopsys DesignWare APB
>> +       GPIO block.
>> +
>
> Looks like this hit next-20140306, when just doing a simple 'make defconfig', I get:
>
> kernel/irq/Kconfig:41:error: recursive dependency detected!
> kernel/irq/Kconfig:41:  symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
> drivers/gpio/Kconfig:131:       symbol GPIO_DWAPB depends on IRQ_DOMAIN
> kernel/irq/Kconfig:46:  symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP
>
> Not sure the best course of action here..
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation

The fix is:

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9979017..0e524d7 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -132,7 +132,7 @@ config GPIO_DWAPB
        tristate "Synopsys DesignWare APB GPIO driver"
        select GPIO_GENERIC
        select GENERIC_IRQ_CHIP
-       depends on OF_GPIO && IRQ_DOMAIN
+       depends on OF_GPIO
        help
          Say Y or M here to build support for the Synopsys DesignWare APB
          GPIO block.

Apologies for missing this.

Alan Tull
aka
delicious quinoa
