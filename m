Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbaISKaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:30:00 -0400
Received: from mail-am1on0130.outbound.protection.outlook.com ([157.56.112.130]:6432
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751829AbaISK37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:29:59 -0400
Message-ID: <541C0517.30804@toradex.com>
Date: Fri, 19 Sep 2014 15:57:35 +0530
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: dts: vf610-colibri: Add backlight support
References: <cover.1410930820.git.bhuvanchandra.dv@toradex.com> <cea494421deefe0b862e31b08685074715acf8d6.1410930820.git.bhuvanchandra.dv@toradex.com> <20140918141705.GM4796@dragon>
In-Reply-To: <20140918141705.GM4796@dragon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: BY2PR04CA049.namprd04.prod.outlook.com (10.141.249.167) To
 DB3PR05MB267.eurprd05.prod.outlook.com (10.141.4.26)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(377454003)(51704005)(199003)(189002)(24454002)(77982003)(19580395003)(20776003)(83072002)(64126003)(101416001)(107046002)(64706001)(102836001)(87976001)(47776003)(80022003)(76176999)(95666004)(110136001)(74502003)(85852003)(19580405001)(42186005)(74662003)(76482002)(50986999)(79102003)(65956001)(81342003)(33656002)(21056001)(65816999)(66066001)(92726001)(31966008)(90102001)(85306004)(23746002)(46102003)(105586002)(99396002)(106356001)(81542003)(83506001)(50466002)(4396001)(97736003)(36756003)(83322001)(92566001)(65806001)(54356999)(77096002)(7059019);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR05MB267;H:[10.18.0.136];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 18 September 2014 07:47 PM, Shawn Guo wrote:

> On Wed, Sep 17, 2014 at 01:46:30PM +0530, Bhuvanchandra DV wrote:
>> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
>> ---
>>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    6 ++++++
>>  arch/arm/boot/dts/vf610-colibri.dtsi        |    7 +++++++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> index ba98039..f1988a0 100644
>> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> @@ -52,3 +52,9 @@
>>  &pwm1 {
>>  	status = "okay";
>>  };
>> +
>> +&backlight {
>> +	brightness-levels = <0 4 8 16 32 64 128 255>;
>> +	default-brightness-level = <6>;
>> +	status  = "okay";
>> +};
>> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
>> index 9bd1415..e725306 100644
>> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
>> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
>> @@ -25,6 +25,13 @@
>>  		};
>>  	};
>>  
>> +	backlight: bl {
> I would suggest we name the node following the example in
> Documentation/devicetree/bindings/pwm/pwm.txt, i.e. bl: backlight.

Will update the node name to bl: backlight

>> +		compitable = "pwm-backlight";
>> +		pwms = <&pwm0 0 5000000 0>;
>> +		pwm-names = " backlight";
> Drop the leading space in the string.
>
> Shawn

Ok

>> +		status = "disabled";
>> +	};
>> +
>>  };
>>  
>>  &esdhc1 {
>> -- 
>> 1.7.9.5
>>

