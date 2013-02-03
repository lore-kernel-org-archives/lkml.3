Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3BCMSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 07:18:18 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:34280 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3BCMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:18:17 -0500
MIME-Version: 1.0
In-Reply-To: <510E4FB8.4050705@ti.com>
References: <1359380879-26306-1-git-send-email-prabhakar.lad@ti.com>
 <1359380879-26306-3-git-send-email-prabhakar.lad@ti.com> <510E4FB8.4050705@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 3 Feb 2013 17:47:53 +0530
Message-ID: <CA+V-a8uMeG-=hTgTSOMRJ-Cr9mXwidu4mQaT5eQ+U7wiWj8MuQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ARM: davinci: da850: add DT node for mdio device
To: Sekhar Nori <nsekhar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Heiko Schocher <hs@denx.de>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar,

On Sun, Feb 3, 2013 at 5:23 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 1/28/2013 7:17 PM, Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> Add mdio device tree node information to da850 by
>> providing register details and bus frequency of mdio.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: davinci-linux-open-source@linux.davincidsp.com
>> Cc: netdev@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> Cc: Heiko Schocher <hs@denx.de>
>> ---
>>  arch/arm/boot/dts/da850-evm.dts |    3 +++
>>  arch/arm/boot/dts/da850.dtsi    |    7 +++++++
>>  2 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
>> index 98c1a48..a319491 100644
>> --- a/arch/arm/boot/dts/da850-evm.dts
>> +++ b/arch/arm/boot/dts/da850-evm.dts
>> @@ -27,6 +27,9 @@
>>               serial2: serial@1d0d000 {
>>                       status = "okay";
>>               };
>> +             mdio: davinci_mdio@1e24000 {
>
> This should just be:
>
> mdio: mdio@1e24000
>
> inline with how we avoid adding davinci prefix to each node name.
>
Ok

>> +                     status = "okay";
>> +             };
>>       };
>>       nand_cs3@62000000 {
>>               status = "okay";
>> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
>> index 7c84822..ba28f2d 100644
>> --- a/arch/arm/boot/dts/da850.dtsi
>> +++ b/arch/arm/boot/dts/da850.dtsi
>> @@ -81,6 +81,13 @@
>>                       interrupts = <61>;
>>                       status = "disabled";
>>               };
>> +             mdio: davinci_mdio@1e24000 {
>> +                     compatible = "ti,davinci_mdio";
>> +                     #address-cells = <1>;
>> +                     #size-cells = <0>;
>> +                     reg = <0x224000 0x1000>;
>> +                     bus_freq = <2200000>;
>
> The bus frequency is board specific and it is better this is defined in
> da850-evm.dts
>
Ok I'll move this to dts file.

Regards,
--Prabhakar

> Thanks,
> Sekhar
