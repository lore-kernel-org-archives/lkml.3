Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaI3IS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:18:29 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:35332 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaI3IS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:18:27 -0400
Message-ID: <542A674E.8040901@linaro.org>
Date: Tue, 30 Sep 2014 09:18:22 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org
CC: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 4/4] ARM: DT: apq8064: Add SATA controller support.
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982134-8090-1-git-send-email-srinivas.kandagatla@linaro.org> <5429DB3D.5080701@codeaurora.org>
In-Reply-To: <5429DB3D.5080701@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 29/09/14 23:20, Stephen Boyd wrote:
> On 09/29/14 02:15, Srinivas Kandagatla wrote:
>> @@ -396,6 +407,35 @@
>>   			usb-phy		= <&usb4_phy>;
>>   		};
>>
>> +		sata_phy0:sata-phy@1b400000{
>
> add some spaces here?
Will fix this in next version.
>
>> +			compatible	= "qcom,apq8064-sata-phy";
>> +			reg		= <0x1b400000 0x200>;
>> +			reg-names	= "phy_mem";
>> +			clocks		= <&gcc SATA_PHY_CFG_CLK>;
>> +			clock-names = "cfg";
>> +			#phy-cells = <0>;
>
> These two lost the pretty tabs.
>
Will fix this in next version.
>> +		};
>> +
>> +		sata0: sata@29000000 {
>> +			compatible	= "generic-ahci";
>> +			reg		= <0x29000000 0x180>;
>> +			interrupts	= <0 209 0>;
>
> Sorry I'm nitpicking but it annoys me. Either align it all or don't
> align it.
I Will fix this in next version.

thanks,
srini
>
>> +			clocks = <&gcc SFAB_SATA_S_H_CLK>, <&gcc SATA_H_CLK>,
>> +				 <&gcc SATA_A_CLK>, <&gcc SATA_RXOOB_CLK>,
>> +				 <&gcc SATA_PMALIVE_CLK>;
>> +
>> +			clock-names = "slave_iface", "iface",
>> +				      "bus", "rxoob",
>> +				      "core_pmalive";
>> +			assigned-clocks = <&gcc SATA_RXOOB_CLK>,
>> +						<&gcc SATA_PMALIVE_CLK>;
>> +			assigned-clock-rates = <100000000>, <100000000>;
>> +
>> +			phys  = <&sata_phy0>;
>> +			phy-names = "sata-phy";
>> +			target-supply = <&pm8921_s4>;
>> +		};
>> +
>>   		/* Temporary fixed regulator */
>>   		vsdcc_fixed: vsdcc-regulator {
>>   			compatible = "regulator-fixed";
>
>
