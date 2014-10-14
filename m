Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaJNHYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:24:17 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:61985 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaJNHYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:24:15 -0400
MIME-Version: 1.0
In-Reply-To: <4094180.e6s5oT6HgP@phil>
References: <1412965848-18663-1-git-send-email-djkurtz@chromium.org>
 <1412965848-18663-4-git-send-email-djkurtz@chromium.org> <4094180.e6s5oT6HgP@phil>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Tue, 14 Oct 2014 15:23:54 +0800
X-Google-Sender-Auth: 95gwnyB2O3ZMtQN0lPPN588LD8o
Message-ID: <CAGS+omB5tuDHFgUGvypaSfxBW-3fhVtTOyWuve-dopeEF3Em6A@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ARM: dts: rk3288: add VOP iommu nodes
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        Grant Grundler <grundler@chromium.org>, Simon Xue <xxm@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 6:33 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Hi Daniel,
>
> Am Samstag, 11. Oktober 2014, 02:30:48 schrieb Daniel Kurtz:
>> Add device nodes for the VOP iommus.
>> Device nodes for other iommus will be added in later patches.
>>
>> The iommu nodes use the #iommu-cells property as described in:
>>   Documentation/devicetree/bindings/iommu/iommu.txt
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> Signed-off-by: Simon Xue <xxm@rock-chips.com>
>> ---
>>  arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
>> index 5950b0a..cbc92fa 100644
>> --- a/arch/arm/boot/dts/rk3288.dtsi
>> +++ b/arch/arm/boot/dts/rk3288.dtsi
>> @@ -271,6 +271,24 @@
>>               status = "disabled";
>>       };
>>
>> +     vopb_mmu: iommu@0xff930300 {
>
> please use the address without the 0x here ... iommu@ff930300

I've been doing it wrong for a while and no one else noticed :-).  Thanks!
I will resend.

> Thanks
> Heiko
>
>> +             compatible = "rockchip,iommu";
>> +             reg = <0xff930300 0x100>;
>> +             interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
>> +             interrupt-names = "vopb_mmu";
>> +             #iommu-cells = <0>;
>> +             status = "disabled";
>> +     };
>> +
>> +     vopl_mmu: iommu@0xff940300 {
>> +             compatible = "rockchip,iommu";
>> +             reg = <0xff940300 0x100>;
>> +             interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
>> +             interrupt-names = "vopl_mmu";
>> +             #iommu-cells = <0>;
>> +             status = "disabled";
>> +     };
>> +
>>       gic: interrupt-controller@ffc01000 {
>>               compatible = "arm,gic-400";
>>               interrupt-controller;
>
