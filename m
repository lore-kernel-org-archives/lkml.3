Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaBZPAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:00:15 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59993 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbaBZPAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:00:09 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Turquette <mturquette@linaro.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: RE: linux-next: manual merge of the clk tree with the keystone tree
Thread-Topic: linux-next: manual merge of the clk tree with the keystone tree
Thread-Index: AQHPMsLGwzRB7MeXvEW0Bpa76daRKJrHzk6A///SnOA=
Date: Wed, 26 Feb 2014 15:00:00 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7046C1288@DFLE11.ent.ti.com>
References: <20140226181521.e8cecdff21d892ea1f037bff@canb.auug.org.au>
 <530DD2CD.7000302@ti.com>
In-Reply-To: <530DD2CD.7000302@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Khoronzhuk, Ivan
>Sent: Wednesday, February 26, 2014 6:41 AM
>To: Stephen Rothwell; Mike Turquette; Shilimkar, Santosh
>Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Karicheri, Muralidharan;
>Strashko, Grygorii
>Subject: Re: linux-next: manual merge of the clk tree with the keystone tree
>
>
>On 02/26/2014 09:15 AM, Stephen Rothwell wrote:
>> Hi Mike,
>>
>> Today's linux-next merge of the clk tree got a conflict in
>> arch/arm/boot/dts/keystone-clocks.dtsi between commit 0cfc9ccec2a8 ("ARM:
>> dts: keystone: preparatory patch to support K2L and K2E SOCs") from
>> the keystone tree and commit 565bbdcd3b91 ("ARM: keystone: dts: fix
>> clkvcp3 control register address") from the clk tree.
>>
>> I fixed it up (by adding the following merge fix patch) and can carry
>> the fix as necessary (no action is required).
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Wed, 26 Feb 2014 18:12:55 +1100
>> Subject: [PATCH] ARM: keystone: dts: fix for code movement
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>   arch/arm/boot/dts/k2hk-clocks.dtsi | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/k2hk-clocks.dtsi
>> b/arch/arm/boot/dts/k2hk-clocks.dtsi
>> index 4eed84feb761..a71aa2996321 100644
>> --- a/arch/arm/boot/dts/k2hk-clocks.dtsi
>> +++ b/arch/arm/boot/dts/k2hk-clocks.dtsi
>> @@ -339,7 +339,7 @@ clocks {
>>   		compatible = "ti,keystone,psc-clock";
>>   		clocks = <&chipclk13>;
>>   		clock-output-names = "vcp-3";
>> -		reg = <0x0235000a8 0xb00>, <0x02350060 0x400>;
>> +		reg = <0x023500a8 0xb00>, <0x02350060 0x400>;
>>   		reg-names = "control", "domain";
>>   		domain-id = <24>;
>>   	};
>
>The patch "ARM: dts: keystone: preparatory patch to support K2L and K2E SOCs"
>is from "[PATCH 0/4] ARM: dts: keystone: Add support for K2H and K2E SOCs/EVMs"
>series (http://www.spinics.net/lists/arm-kernel/msg310946.html).
>
>As I understand, this series splits keystone clock tree into tree boards.
>As result clock "clkvcp3" (for wich reg is corrected) is moved to the following two dts:
>
>k2hk-clocks.dtsi
>k2l-clocks.dtsi
>
>So probably you should apply this change to k2l-clocks.dtsi too.
>

Yes. The fix is needed for k2l-clocks.dtsi also. Thanks for taking care of this.

Murali Karicheri
Linux Kernel, Software Development

>--
>Regards,
>Ivan Khoronzhuk

