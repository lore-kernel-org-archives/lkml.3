Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaIHGud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 02:50:33 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33371 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaIHGub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 02:50:31 -0400
Message-ID: <540D51B2.9000908@collabora.co.uk>
Date: Mon, 08 Sep 2014 08:50:26 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 3/5] rtc: max77686: Fail to probe if no RTC regmap
 irqchip is set
References: <1408350877-15921-1-git-send-email-javier.martinez@collabora.co.uk> <1408350877-15921-4-git-send-email-javier.martinez@collabora.co.uk> <1409217715.20020.7.camel@AMDC1943>
In-Reply-To: <1409217715.20020.7.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

Sorry for the late response, I was on holidays and slowly catching up on email.

On 08/28/2014 11:21 AM, Krzysztof Kozlowski wrote:
> On pon, 2014-08-18 at 10:34 +0200, Javier Martinez Canillas wrote:
>> The max77686 mfd driver adds a regmap IRQ chip which creates an
>> IRQ domain that is used to map the virtual RTC alarm1 interrupt.
>> 
>> The RTC driver assumes that this will always be true since the
>> PMIC IRQ is a required property according to the max77686 DT
>> binding doc. If an "interrupts" property is not defined for a
>> max77686 PMIC, then the mfd probe function will fail and the
>> RTC platform driver will never be probed. But even when it is
>> not possible to probe the rtc-max77686 driver without a regmap
>> IRQ chip, it's better to explicitly check if the IRQ chip data
>> is not NULL and gracefully fail instead of getting an OOPS.
> 
> The OOPS was possible only with Bartlomiej's patch because he changed
> the MFD driver probe function to skip IRQ setup on lack of interrupts.
> In current state the OOPS should not happen so mentioning OOPS in commit
> message may be misleading. Maybe just don't put the OOPS here?
> 
> Anyway the patch looks good and a check for non-null
> regmap_irq_chip_data is still a valid precaution so:
>

Yes I know but as you said the check for non-null is still a valid precaution
(albeit maybe paranoid) just in case someone find that not having the IRQ
hooked makes sense in a design and changes the mfd driver in the future.

> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Best regards,
> Krzysztof
> 
> 

Best regards,
Javier
