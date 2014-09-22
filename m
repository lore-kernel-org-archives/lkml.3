Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaIVEiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:38:54 -0400
Received: from mail-am1on0142.outbound.protection.outlook.com ([157.56.112.142]:29247
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750758AbaIVEix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:38:53 -0400
Message-ID: <541FA7C9.30509@toradex.com>
Date: Mon, 22 Sep 2014 10:08:33 +0530
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: <shawn.guo@freescale.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ARM: dts: vf610-colibri: Add PWM support
References: <cover.1411130205.git.bhuvanchandra.dv@toradex.com> <d28bb6c5aeee7b5b4b7b20484fbaf0ba4eeb4ad4.1411130205.git.bhuvanchandra.dv@toradex.com> <e63381e2dd14625e5395f892928b38f2@agner.ch>
In-Reply-To: <e63381e2dd14625e5395f892928b38f2@agner.ch>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: DM2PR00CA0002.namprd00.prod.outlook.com (25.160.243.12) To
 AM3PR05MB257.eurprd05.prod.outlook.com (10.242.249.14)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AM3PR05MB257;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(377454003)(189002)(199003)(24454002)(377424004)(51704005)(90102001)(23746002)(92726001)(92566001)(77096002)(50986999)(85852003)(575784001)(21056001)(20776003)(95666004)(33656002)(47776003)(65956001)(76176999)(36756003)(99396002)(66066001)(4396001)(64706001)(86362001)(54356999)(50466002)(101416001)(87976001)(74662003)(106356001)(107046002)(77982003)(81342003)(74502003)(81542003)(46102003)(19580405001)(83322001)(76482002)(79102003)(80022003)(19580395003)(42186005)(110136001)(83072002)(105586002)(85306004)(83506001)(97736003)(31966008)(120916001)(7059019)(414714003)(473944003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM3PR05MB257;H:[10.18.0.136];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 19 September 2014 09:30 PM, Stefan Agner wrote:

> Am 2014-09-19 15:38, schrieb Bhuvanchandra DV:
>> The Colibri standard defines four pins as PWM outputs, two of them (PWM
>> A and C) are routed to FTM instance 0 and the other two (PWM B and D)
>> are routed to FTM instance 1. Hence enable both FTM instances for the
>> Colibri module and mux the four pins accordingly.
>>
>> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
>> ---
>>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    8 +++++++
>>  arch/arm/boot/dts/vf610-colibri.dtsi        |   31 +++++++++++++++++++++++----
>>  2 files changed, 35 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> index 7fb3066..00f63d9 100644
>> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> @@ -33,6 +33,14 @@
>>  	status = "okay";
>>  };
>>  
>> +&pwm0 {
>> +	status = "okay";
>> +};
>> +
>> +&pwm1 {
>> +	status = "okay";
>> +};
>> +
>>  &uart0 {
>>  	status = "okay";
>>  };
>> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi
>> b/arch/arm/boot/dts/vf610-colibri.dtsi
>> index 0cd8343..560cd69 100644
>> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
>> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
>> @@ -13,10 +13,6 @@
>>  	model = "Toradex Colibri VF61 COM";
>>  	compatible = "toradex,vf610-colibri_vf61", "fsl,vf610";
>>  
>> -	memory {
>> -		reg = <0x80000000 0x10000000>;
>> -	};
>> -
>>  	clocks {
>>  		enet_ext {
>>  			compatible = "fixed-clock";
>> @@ -25,6 +21,9 @@
>>  		};
>>  	};
>>  
>> +	memory {
>> +		reg = <0x80000000 0x10000000>;
>> +	};
> Memory is a bit an exception here: In almost all device tree this is the
> first node after model/compatible. Also, it's generally not allowed to
> make changes outside of the topic (PWM in this case)... Hence I would
> drop this change.
>
> The rest
> Acked-By: Stefan Agner <stefan@agner.ch>

OK. Will drop the change.

>>  };
>>  
>>  &esdhc1 {
>> @@ -44,6 +43,16 @@
>>  	arm,tag-latency = <3 2 3>;
>>  };
>>  
>> +&pwm0 {
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <&pinctrl_pwm0>;
>> +};
>> +
>> +&pwm1 {
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <&pinctrl_pwm1>;
>> +};
>> +
>>  &uart0 {
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&pinctrl_uart0>;
>> @@ -97,6 +106,20 @@
>>  			>;
>>  		};
>>  
>> +		pinctrl_pwm0: pwm0grp {
>> +			fsl,pins = <
>> +				VF610_PAD_PTB0__FTM0_CH0		0x1182
>> +				VF610_PAD_PTB1__FTM0_CH1		0x1182
>> +			>;
>> +		};
>> +
>> +		pinctrl_pwm1: pwm1grp {
>> +			fsl,pins = <
>> +				VF610_PAD_PTB8__FTM1_CH0		0x1182
>> +				VF610_PAD_PTB9__FTM1_CH1		0x1182
>> +			>;
>> +		};
>> +
>>  		pinctrl_uart0: uart0grp {
>>  			fsl,pins = <
>>  				VF610_PAD_PTB10__UART0_TX		0x21a2

