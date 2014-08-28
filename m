Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaH1Tgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:36:53 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:52991 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaH1Tgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:36:49 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: jic23@kernel.org
X-SENDER-IP: 216.239.45.88
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <4636709d02ff70cd29b9efee33e69523>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53FF84C4.9080902@rock-chips.com>
Date: Fri, 29 Aug 2014 03:36:36 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: Eduardo Valentin <edubezval@gmail.com>, rui.zhang@intel.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        zhaoyifeng <zyf@rock-chips.com>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v3 1/4] thermal: rockchip: add driver for thermal
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com> <20140828143733.GA18084@developer> <3440260.edal29kzlR@diego> <4488604.oBeB6it8Vr@wuerfel>
In-Reply-To: <4488604.oBeB6it8Vr@wuerfel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd & Heiko & Eduardo,

OK. Maybe you are right.

This driver should be put into drivers/iio/adc/* ,
Anyway,I will re-edit it ASAP.


在 2014/8/29 0:16, Arnd Bergmann 写道:
> On Thursday 28 August 2014 18:11:43 Heiko Stübner wrote:
>> Am Donnerstag, 28. August 2014, 10:37:35 schrieb Eduardo Valentin:
>>>> On the driver side, I believe the correct way to deal with this setup
>>>> is to split your driver into a generic drivers/iio/adc/rockchips-tsadc.c
>>>> file, and a smaller thermal driver that uses the iio in-kernel interfaces,
>>>> ideally one that is independent of the underlying hardware and can
>>>> work on any ADC implementation.
>>> Agreed. If you can write such interface and make your driver to work in
>>> such way, that would be great.
>> But I currently don't see how you would model the temperature handling parts
>> from a generic thermal driver to a generic adc driver for the rk3288-tsadc.
>>
>> I guess the general temperature irq handling would use iio-triggers? But how
>> does the target temperature get into the TSADC_COMP1_INT register.
>>
>> Also when getting the temperature, Caesar's driver compares it to its trip
>> points and sets the next trip point depending on the current temperature
>> (passive <-> critical) in rockchip_get_temp.
>>
>> Maybe there is some completely easy way for this, but currently I don't see
>> it.
> Eduardo earlier today replied to an email about a generic driver for
> thermal, which was posted in February but hasn't been merged.
> See https://lkml.org/lkml/2014/2/5/810
>
> There may be a newer version of this patch, which I haven't found.
>
> 	Arnd
>
>
>

-- 
Best regards,
Caesar


