Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaHOTJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:09:03 -0400
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:55276 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbaHOTJA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:09:00 -0400
Date: Fri, 15 Aug 2014 15:08:59 -0400 (EDT)
Subject: Re: [PATCH] ARM: apq8064: Add pinmux and i2c pinctrl nodes
From: kiran.padwal@smartplayin.com
To: "Bjorn Andersson" <bjorn@kryo.se>
Cc: "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        "David Brown" <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
Message-ID: <1408129739.03949271@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday, August 14, 2014 6:37pm, "Bjorn Andersson" <bjorn@kryo.se> said:

> On Thu, Aug 14, 2014 at 12:20 AM, Kiran Padwal
> <kiran.padwal@smartplayin.com> wrote:
>> diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi
>> b/arch/arm/boot/dts/qcom-apq8064.dtsi
>> index 92bf793..fbebf5c 100644
>> --- a/arch/arm/boot/dts/qcom-apq8064.dtsi
>> +++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
>> @@ -70,6 +70,17 @@
>>                 ranges;
>>                 compatible = "simple-bus";
>>
>> +               qcom_pinmux: pinmux@800000 {
> 
> There are (at least) three different pinmuxes in these platforms: TLMM, PMIC
> GPIO, PMIC MPP. Also this is the phandle that is used to reference the gpio
> chip throughout the board.
> 
> So I would like to suggest that we name it "tlmm" or like in the downstream
> kernel "msmgpio".

ok. How about "qcomgpio" or rename it to msmgpio?

> 
>> +                       compatible = "qcom,apq8064-pinctrl";
>> +                       reg = <0x800000 0x4000>;
>> +
>> +                       gpio-controller;
>> +                       #gpio-cells = <2>;
>> +                       interrupt-controller;
>> +                       #interrupt-cells = <2>;
>> +                       interrupts = <0 32 0x4>;
> 
> I must have gotten this wrong in the dt binding example, sorry about that.
> interrupts should be <0 16 0x4>.

Thanks for information. I will update that.
 
> 
>> +               };
> 
> Regards,
> Bjorn
> 



