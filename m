Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaISKTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:19:31 -0400
Received: from mail-am1on0147.outbound.protection.outlook.com ([157.56.112.147]:34507
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754306AbaISKTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:19:30 -0400
Message-ID: <541C031D.2010208@toradex.com>
Date: Fri, 19 Sep 2014 15:49:09 +0530
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: dts: vf610-colibri: Add PWM support
References: <cover.1410930820.git.bhuvanchandra.dv@toradex.com> <819bd3bc9541ca53f005b7cf95bc890f1a9215e5.1410930820.git.bhuvanchandra.dv@toradex.com> <20140918141248.GL4796@dragon>
In-Reply-To: <20140918141248.GL4796@dragon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: BY2PR03CA072.namprd03.prod.outlook.com (10.141.249.45) To
 AMSPR05MB263.eurprd05.prod.outlook.com (10.242.95.26)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB263;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(24454002)(51704005)(189002)(199003)(377454003)(50466002)(83506001)(95666004)(105586002)(106356001)(64126003)(21056001)(101416001)(33656002)(102836001)(76482002)(36756003)(107046002)(97736003)(59896002)(85306004)(31966008)(20776003)(47776003)(90102001)(110136001)(46102003)(77982003)(83072002)(64706001)(85852003)(65806001)(66066001)(42186005)(65956001)(77096002)(87976001)(23746002)(19580395003)(83322001)(80316001)(19580405001)(99396002)(4396001)(79102003)(80022003)(74502003)(74662003)(81542003)(81342003)(575784001)(92566001)(92726001)(87266999)(65816999)(54356999)(76176999)(50986999)(3076001)(7059019)(414714003)(473944003);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB263;H:[10.18.0.136];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 18 September 2014 07:42 PM, Shawn Guo wrote:

> On Wed, Sep 17, 2014 at 01:46:29PM +0530, Bhuvanchandra DV wrote:
>>  The Colibri standard defines four pins as PWM outputs, two of them (PWM
>>  A and C) are routed to FTM instance 0 and the other two (PWM B and D)
>>  are routed to FTM instance 1. Hence enable both FTM instances for the
>>  Colibri module and mux the four pins accordingly.
>>
>> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
>> ---
>>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    8 ++++++++
>>  arch/arm/boot/dts/vf610-colibri.dtsi        |   25 +++++++++++++++++++++++++
>>  2 files changed, 33 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> index 7fb3066..ba98039 100644
>> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> @@ -44,3 +44,11 @@
>>  &uart2 {
>>  	status = "okay";
>>  };
>> +
>> +&pwm0 {
>> +	status = "okay";
>> +};
>> +
>> +&pwm1 {
>> +	status = "okay";
>> +};
> Please sort the node alphabetically, so that we can locate them more
> easily.

Ok, will sort the nodes alphabetically 

>> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
>> index 0cd8343..9bd1415 100644
>> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
>> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
>> @@ -69,6 +69,16 @@
>>  	status = "okay";
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
> Ditto

Ok

>>  &iomuxc {
>>  	vf610-colibri {
>>  		pinctrl_esdhc1: esdhc1grp {
>> @@ -119,5 +129,20 @@
>>  				VF610_PAD_PTD3__UART2_CTS		0x21a1
>>  			>;
>>  		};
>> +
>> +		pinctrl_pwm0: pwm0grp {
> We also maintain the alphabetic order of pinctrl_* entries under iomuxc
> node.
>
> Shawn

Ok

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
>>  	};
>>  };
>> -- 
>> 1.7.9.5
>>

