Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbaJ3GwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:52:13 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:52969 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbaJ3GwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <20141027173055.GD4971@leverpostej>
References: <1414423637-2817-1-git-send-email-torfl6749@gmail.com>
	<20141027173055.GD4971@leverpostej>
Date: Thu, 30 Oct 2014 07:52:08 +0100
Message-ID: <CANZ4BrT8noz+zueDm2hModbduamnhSZj2F1VamckahoXUjAcGg@mail.gmail.com>
Subject: Re: [PATCH 1/1] spi: spi-gpio: Add dt support for a single device
 with no chip select
From: Torsten Fleischer <torfl6749@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-27 18:30 GMT+01:00 Mark Rutland <mark.rutland@arm.com>:
> On Mon, Oct 27, 2014 at 03:27:17PM +0000, Torsten Fleischer wrote:
>> From: Torsten Fleischer <torfl6749@gmail.com>
>>
>> Use an empty 'cs-gpios' property if a single device is connected which
>> has no chip select.
>> This refers to the discussion at https://lkml.org/lkml/2013/11/13/62.
>>
>> Signed-off-by: Torsten Fleischer <torfl6749@gmail.com>
>> ---
>>  Documentation/devicetree/bindings/spi/spi-gpio.txt |  6 ++++--
>>  drivers/spi/spi-gpio.c                             | 10 +++++++---
>>  2 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/spi/spi-gpio.txt b/Documentation/devicetree/bindings/spi/spi-gpio.txt
>> index 8a824be..ad8795f 100644
>> --- a/Documentation/devicetree/bindings/spi/spi-gpio.txt
>> +++ b/Documentation/devicetree/bindings/spi/spi-gpio.txt
>> @@ -8,8 +8,10 @@ Required properties:
>>   - gpio-sck: GPIO spec for the SCK line to use
>>   - gpio-miso: GPIO spec for the MISO line to use
>>   - gpio-mosi: GPIO spec for the MOSI line to use
>> - - cs-gpios: GPIOs to use for chipselect lines
>> - - num-chipselects: number of chipselect lines
>> + - cs-gpios: GPIOs to use for chipselect lines. Leave this property empty if
>> +             a single device with no chip select is connected.
>> + - num-chipselects: Number of chipselect lines. Has to be "1" even if a single
>> +                    device with no chip select is connected.
>
> Why not just have num-chipselectes = <0>, and no cs-gpios property?
>
> That would match the HW, and is unambigious as the author has to state
> explicitly that there are no chipselects.

Thanks for the objection. I agree to your proposal. This is a clearer
way to describe such
a hardware. I will send an updated patch.

Torsten
