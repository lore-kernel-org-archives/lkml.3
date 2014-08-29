Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaH2MI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:08:56 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:47150 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaH2MIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:08:54 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: huangtao@rock-chips.com
X-FST-TO: huangtao@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: huangtao@rock-chips.com
X-UNIQUE-TAG: <766a18d078addef3bab3b6407c56332e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <54006D4C.2070404@rock-chips.com>
Date: Fri, 29 Aug 2014 20:08:44 +0800
From: Huang Tao <huangtao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "edubezval@gmail.com" <edubezval@gmail.com>,
        =?UTF-8?B?6LW15Luq5bOw?= <zyf@rock-chips.com>
CC: =?UTF-8?B?SGVpa29TdMO8Ym5lcg==?= <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        "rui.zhang" <rui.zhang@intel.com>,
        "grant.likely" <grant.likely@linaro.org>, robh+dt <robh+dt@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>,
        =?UTF-8?B?6JSh5p6r?= <cf@rock-chips.com>,
        dianders <dianders@chromium.org>, dtor <dtor@chromium.org>,
        =?UTF-8?B?6ZKf5YuH5rGq?= <zyw@rock-chips.com>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "dmitry.torokhov" <dmitry.torokhov@gmail.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v3 1/4] thermal: rockchip: add driver for thermal
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>	<2852853.mfRZfFVSev@wuerfel>	<20140828143733.GA18084@developer>	<3440260.edal29kzlR@diego>	<2014082909531345696848@rock-chips.com> <CAC-25o-winy6jVjh9_hQ-t2VO2UfxG67pW5DpOve8A2o39EJSw@mail.gmail.com>
In-Reply-To: <CAC-25o-winy6jVjh9_hQ-t2VO2UfxG67pW5DpOve8A2o39EJSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eduardo Bezerra Valentin:

在 2014年08月29日 19:39, edubezval@gmail.com 写道:
> Hello Zhao,
>
> On Thu, Aug 28, 2014 at 9:54 PM, 赵仪峰 <zyf@rock-chips.com> wrote:
>> Hi Heiko，
>>
>>    The TS-ADC on RK3288 has two component, a tsadc and a tsadc controller.
>> The tsadc controller is similar like the thermal manager unit on other SOCs.
>> We followed the naming of 3066, but not named as the Thermal Manager.
>>
>>    Moreover,there is only one set of apb registers to access the tsadc
>> controller,and the tsadc is controlled by the tsadc controller,could not
>> access directly. If we write a general tsadc driver by accessed tsadc
>> controller registers, and it hardly to write a driver for the tsadc
>> controller.
> As suggested by Arnd, you can use the generic driver as interface
> between thermal framework and IIO layer. The driver you are going to
> write to your ADC is going to be in the IIO subsystem. The only
> difference is that the generic driver would work for any ADC driver in
> the IIO subsystem.
> https://lkml.org/lkml/2014/2/5/810
>
> In fact, there is already a generic driver. We just need to get it up
> to date.  I see some testing has been already done, and results sound
> promising.
This iio_thermal driver only support get temperature from the ADC IIO
channel.
It dose not support any advanced feature such as configure the
temperature when system should be reset.
So if we adapt it, we will access the register form both TSADC IIO
driver and  thermal driver.
I don't thank this is a good ideal.

In fact, we should ignore the "ADC" stuff. This sensor use ADC internal,
but it is transparent to software, especially in automatic mode.
>
>>    So, I do not agree to write a generic adc driver for the rk3288-tsadc.
>>
>> ________________________________
>> Yifeng Zhao
>>
>>


