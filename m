Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbbAHTCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:02:09 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:49459 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbbAHTCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:02:08 -0500
X-ME-Helo: beldin
X-ME-Date: Thu, 08 Jan 2015 20:02:06 +0100
X-ME-IP: 109.222.243.71
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "grant.likely\@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] mfd: lubbock_io: add lubbock_io board
References: <1420324515-7444-1-git-send-email-robert.jarzmik@free.fr>
	<20150108133404.GE10537@leverpostej>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 08 Jan 2015 20:02:04 +0100
In-Reply-To: <20150108133404.GE10537@leverpostej> (Mark Rutland's message of
	"Thu, 8 Jan 2015 13:34:05 +0000")
Message-ID: <87y4pd2j0z.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Rutland <mark.rutland@arm.com> writes:

> Hi Robert,
>
> Given the addition of an of_device_id table and some (implicit) property
> parsing, this requires a device tree binding document.
Yes, you're right. I'll prepare that.

>> +	ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler, 0,
>> +			       dev_name(&pdev->dev), cot);
>> +	if (ret == -ENOSYS)
>> +		return -EPROBE_DEFER;
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Couldn't request GPIO : ret = %d\n", ret);
>> +		return ret;
>> +	}
>> +	irq_set_irq_type(cot->irq, IRQ_TYPE_EDGE_FALLING);
>
> Shouldn't that be in the interrupt-specifier when using DT?
Maybe. But what about the platform data case ? I think I wanted to express the
multiple-NOR gate binding all incoming level interrupt into the output cot->irq
interrupt line going to GPIO0.

Do you have an idea for the platform data case ?
>> +static const struct of_device_id lubbock_id_table[] = {
>> +	{ .compatible = "marvell,lubbock_io", },

> When PXA25x it was Intel, not Marvell. So I think the vendor prefix
> should be "intel".
>
> Also s/_/-/ in property names and compatible strings please.
Ok for v3.

Thanks for the review.

-- 
Robert
