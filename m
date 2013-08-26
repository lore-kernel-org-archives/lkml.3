Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3HZQ5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:57:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46112 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3HZQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:57:38 -0400
Message-ID: <521B88FE.4070000@wwwdotorg.org>
Date: Mon, 26 Aug 2013 10:57:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fabian Vogt <fabian@ritter-vogt.de>
CC: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@linaro.org, pawel.moll@arm.com
Subject: Re: [PATCH V3] gpio: New driver for LSI ZEVIO SoCs
References: <1375879989-18606-1-git-send-email-fabian@ritter-vogt.de> <5217BB73.8050907@wwwdotorg.org> <op.w2d04ftpu7prd4@fabians-laptop.fritz.box>
In-Reply-To: <op.w2d04ftpu7prd4@fabians-laptop.fritz.box>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2013 01:44 PM, Fabian Vogt wrote:
> Hi,
> 
>> On 08/07/2013 06:53 AM, Fabian Vogt wrote:
>>> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
>>> It has been successfully tested on a TI nspire CX calculator.
>>
>>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>>> b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>>
>>> +Zevio GPIO controller
>>> +
>>> +Required properties:
>>> +- compatible = "lsi,zevio-gpio"
>>
>> Is there only one zevio chip, or a series? Is "zevio" the full name of
>> the chip, including any version number?
>
> We don't know, it's a relableled chip with
> TI-NSPIRE / L9A0702 / TI-NS2006A-0 / LSI LOGIC / ZEVIO / U 0714 /
> WYJ14052-1
> on it. But this driver should match the other drivers (lsi,zevio-intc,
> lsi,zevio-timer).

OK, I guess that's fine then. I suppose if we find "zevio2" chips, we
can always use that for the compatible value later.

>>> +- reg = <BASEADDR SIZE>
>>> +- #gpio-cells = <2>
>>> +- gpio-controller;
>>> +
>>> +Optional:
>>> +- #ngpios = <32>: Number of GPIOs. Defaults to 32 if absent
>>
>> Perhaps one can derive that from the compatible value? The fact this
>> property exists implies there's more than one zevio chip, so perhaps
>> each should have an explicit compatible value described above?
>
> I added it just for someone who maybe needs it. It's only two lines and
> maybe
> it'll be helpful for someone. We don't know whether some similiar or
> this controller
> exist in different configurations (pin count, section sice, register
> layout).
> Also I hate hardcoded values which require a recompile to change..

If there's no reason for this property, I think we should remove it.

