Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaJXCTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:19:13 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:56181 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJXCTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:19:10 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zhengsq@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <86ab694e264e69002c4b4e5e67c038f1>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5449B72B.5090005@rock-chips.com>
Date: Fri, 24 Oct 2014 10:19:23 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v13 3/5] ARM: dts: add RK3288 Thermal data
References: <1414057207-1576-1-git-send-email-caesar.wang@rock-chips.com> <1414057207-1576-4-git-send-email-caesar.wang@rock-chips.com> <20141024004811.GE9463@dtor-ws>
In-Reply-To: <20141024004811.GE9463@dtor-ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

在 2014/10/24 8:48, Dmitry Torokhov 写道:
> Hi Caesar,
>
> On Thu, Oct 23, 2014 at 05:40:05PM +0800, Caesar Wang wrote:
>> This patch changes a dtsi file to contain the thermal data
>> on RK3288 and later SoCs. This data will
>> enable a thermal shutdown over 125C.
>>
>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>> ---
>>   arch/arm/boot/dts/rk3288-thermal.dtsi | 65 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 65 insertions(+)
>>   create mode 100644 arch/arm/boot/dts/rk3288-thermal.dtsi
>>
>> diff --git a/arch/arm/boot/dts/rk3288-thermal.dtsi b/arch/arm/boot/dts/rk3288-thermal.dtsi
>> new file mode 100644
>> index 0000000..c361262
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/rk3288-thermal.dtsi
>> @@ -0,0 +1,65 @@
>> +/*
>> + * Device Tree Source for RK3288 SoC thermal
>> + *
>> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
>> + *
>> + * This file is licensed under the terms of the GNU General Public License
>> + * version 2.  This program is licensed "as is" without any warranty of any
>> + * kind, whether express or implied.
>> + */
>> +
>> +#include <dt-bindings/thermal/thermal.h>
>> +
>> +reserve_thermal: reserve_thermal {
>> +	polling-delay-passive = <500>; /* milliseconds */
>> +	polling-delay = <1000>; /* milliseconds */
>> +
>> +			/* sensor	ID */
>> +	thermal-sensors = <&tsadc	0>;
>> +
>> +};
>> +
>> +cpu_thermal: cpu_thermal {
>> +	polling-delay-passive = <500>; /* milliseconds */
>> +	polling-delay = <1000>; /* milliseconds */
> Given that the hardware supports alarm interrupts I think we should be
> able to lower polling frequency. I'd say 5 seconds for polling-delay and
> 1 second for when we trip over passive point?
As you say:

+cpu_thermal: cpu_thermal {
+	polling-delay-passive = <1000>; /* milliseconds */
+	polling-delay = <5000>; /* milliseconds */

I think it's ok for me if the driver follow your change.


>
> Thanks.
>

-- 
Best regards,
Caesar


