Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3KZI5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:57:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50138 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab3KZI5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:57:02 -0500
Message-ID: <52946243.70903@ti.com>
Date: Tue, 26 Nov 2013 10:56:35 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        dt list <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: dts: omap3-beagle: Fix USB host on beagle boards
 (for 3.13)
References: <1385387745-7162-1-git-send-email-rogerq@ti.com> <CAGo_u6ryFJvBwd=S9A-nJw+eoGguPj0jMOtgMiZ7mXXAbh4i+w@mail.gmail.com>
In-Reply-To: <CAGo_u6ryFJvBwd=S9A-nJw+eoGguPj0jMOtgMiZ7mXXAbh4i+w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 05:50 PM, Nishanth Menon wrote:
> On Mon, Nov 25, 2013 at 7:55 AM, Roger Quadros <rogerq@ti.com> wrote:
>> Beagle (rev. C4) and Beagle-XM (all revs) need VAUX2 1.8V supply
>> for the USB PHY.
>>
>> As the generic PHY driver can't handle more than one supply
>> at the moment, we configure this supply to be always on.
>> This will cause a very small power impact if the USB host subsystem
>> is not in use, about 76.86 micro-W + LDO power.
> 
>>
>> Older Beagle boards (prior to C4) don't have VAUX2 connected anywhere,
>> so there won't be any functional impact on those boards other than
>> some additional LDO power consumption.
>>
>> Reported-by: Nishanth Menon <nm@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Tested-by: Nishanth Menon <nm@ti.com>

Thanks Nishant.
> 
> I might suggest though that the better alternative might be to get phy
> driver to handle multiple regulators considering that DT is supposed
> to represent the h/w topology.

Noted. I will work on this for 3.14.

cheers,
-roger

> 
>> ---
>>  arch/arm/boot/dts/omap3-beagle-xm.dts | 8 ++++++++
>>  arch/arm/boot/dts/omap3-beagle.dts    | 8 ++++++++
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
>> index 31a632f..b39918e 100644
>> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
>> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
>> @@ -215,3 +215,11 @@
>>  &usbhsehci {
>>         phys = <0 &hsusb2_phy>;
>>  };
>> +
>> +&vaux2 {
>> +       regulator-name = "usb_1v8";
>> +       regulator-min-microvolt = <1800000>;
>> +       regulator-max-microvolt = <1800000>;
>> +       regulator-always-on;
>> +};
>> +
>> diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
>> index fa532aa..9764556 100644
>> --- a/arch/arm/boot/dts/omap3-beagle.dts
>> +++ b/arch/arm/boot/dts/omap3-beagle.dts
>> @@ -178,3 +178,11 @@
>>         mode = <3>;
>>         power = <50>;
>>  };
>> +
>> +&vaux2 {
>> +       regulator-name = "vdd_ehci";
>> +       regulator-min-microvolt = <1800000>;
>> +       regulator-max-microvolt = <1800000>;
>> +       regulator-always-on;
>> +};
>> +
>> --
>> 1.8.3.2
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

