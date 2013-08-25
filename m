Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3HYTgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:36:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3HYTgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:36:52 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Stephen Warren" <swarren@wwwdotorg.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@linaro.org, pawel.moll@arm.com
Subject: Re: [PATCH V3] gpio: New driver for LSI ZEVIO SoCs
References: <1375879989-18606-1-git-send-email-fabian@ritter-vogt.de>
 <5217BB73.8050907@wwwdotorg.org>
Date: Sun, 25 Aug 2013 21:44:29 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Fabian Vogt" <fabian@ritter-vogt.de>
Message-ID: <op.w2d04ftpu7prd4@fabians-laptop.fritz.box>
In-Reply-To: <5217BB73.8050907@wwwdotorg.org>
User-Agent: Opera Mail/12.15 (Linux)
X-Provags-ID: V02:K0:+uB066rHWAftaZx9fTKaX+K5Eg6EHJ49IIWJL9RaYwi
 tJgMaaEmzSkTlsK0jsC/hOxCFNVfuuaB3SgZNKE4jrXqOtYB6T
 3yRLiSTOyqtu0IjauA+xYevuEg8xgMgfUr7zPnGqRMmQWvD/1r
 SH4Z3kuCj6YUKzT3obQuxNEqDULaHZdqy9z52SdD2PXIU/C/1n
 FdUqUQA/rb2O4nfk4UODIncmqAOHL3X7MQKncM064vHmcAdAUl
 2bk4xFT/hgx6Fd4BpZkkEbexz/C1WTjApYeWxTvKWEO4ntzhue
 7Hp/xsEH/td9TiKa/4WUDBeGys1GjkVprrmKFZ9l4o0xxqdLZE
 dnsXUuhdmY1Hs4+vvdw2zLptLsCOKv9O5GBxyIWlPTvb7wq9sM
 3c5xWDYSnZo2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On 08/07/2013 06:53 AM, Fabian Vogt wrote:
>> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
>> It has been successfully tested on a TI nspire CX calculator.
>
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-zevio.txt  
>> b/Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>
>> +Zevio GPIO controller
>> +
>> +Required properties:
>> +- compatible = "lsi,zevio-gpio"
>
> Is there only one zevio chip, or a series? Is "zevio" the full name of
> the chip, including any version number?
We don't know, it's a relableled chip with
TI-NSPIRE / L9A0702 / TI-NS2006A-0 / LSI LOGIC / ZEVIO / U 0714 /  
WYJ14052-1
on it. But this driver should match the other drivers (lsi,zevio-intc,  
lsi,zevio-timer).

>> +- reg = <BASEADDR SIZE>
>> +- #gpio-cells = <2>
>> +- gpio-controller;
>> +
>> +Optional:
>> +- #ngpios = <32>: Number of GPIOs. Defaults to 32 if absent
>
> Perhaps one can derive that from the compatible value? The fact this
> property exists implies there's more than one zevio chip, so perhaps
> each should have an explicit compatible value described above?
I added it just for someone who maybe needs it. It's only two lines and  
maybe
it'll be helpful for someone. We don't know whether some similiar or this  
controller
exist in different configurations (pin count, section sice, register  
layout).
Also I hate hardcoded values which require a recompile to change..

> Is the GPIO block not also an interrupt source/controller? I see the
> following in the patch, and references to some IRQ registers...
>
>> +	select GENERIC_IRQ_CHIP
I forgot to remove this line after testing the interrupts, the tests went  
horribly (hard lockups)...

V4 should be underway soon.

Bye,
Fabian
