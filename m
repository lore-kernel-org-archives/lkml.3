Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbaGaMOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:14:24 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:40120
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750738AbaGaMOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:14:21 -0400
Date: Thu, 31 Jul 2014 14:13:48 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>
CC: "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Punnaiah Choudary <kpc528@gmail.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        Srikanth Vemula <svemula@xilinx.com>
Subject: Re: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr ecc
 controller
References: <9dc2a947-d2ab-4f00-8ed3-d2499cb6fdfd@BN1BFFO11FD002.protection.gbl>
 <20140731113324.GB4375@pd.tnic>
In-Reply-To: <20140731113324.GB4375@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <808655a9-77eb-4e3a-9781-2b059ad9517b@BN1AFFO11FD020.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(24454002)(479174003)(377454003)(51704005)(164054003)(50986999)(83072002)(76176999)(102836001)(92566001)(50466002)(83506001)(74316001)(79102001)(31696002)(81342001)(85852003)(65806001)(87936001)(54356999)(4396001)(76482001)(106466001)(74502001)(64706001)(33646002)(86362001)(46102001)(31966008)(21056001)(47776003)(70736001)(1496007)(44976005)(80022001)(65956001)(6806004)(83322001)(77982001)(81542001)(95666004)(92726001)(107046002)(85306003)(20776003)(74662001)(104016003)(65826006)(1834003)(107986001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB054;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0289B6431E
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 01:33 PM, Borislav Petkov wrote:
> On Wed, Jul 30, 2014 at 03:41:47PM +0000, Punnaiah Choudary Kalluri wrote:
>>> So you're telling me that you want one edac driver for *two* memory
>>> controllers which can be present on a single system *at* *the* *same*
>>> *time*? Is that it?
>>
>> Yes.
> 
> Oh, this'll be fun. :-P

just to give me one more possible and more crazy example.
You can start system with one memory controller - then use partial
reconfiguration and add others at run time till you have enough pins
on your board. You can also remove it when you decide to do so.
And every boot can be different on the same board.


>>>
>>> How exactly is that topology supposed to look like, work, etc, etc? What
>>> kind of error reporting do you imagine you want to do with EDAC?
>>
>> Zynq (All programmable SOC) contains a dual core ARM cortex A9 based processing
>> System(PS) and Xilinx programmable logic(PL) in a single device.
>>
>> Assume the application is a broadcast camera. The design for this system use PS as
>> Control plane and use PL as data plane for processing the video data. So, the design 
>> may have two different memory controllers one in PS and another one in PL.   
>> PS is running with Linux OS and PL doesn't have the OS and it is  controlled by the 
>> OS running on PS.
> 
> Ok.
> 
>>  Now the requirement is to develop a monitoring system for all the
>> hardware failures Including ddr ecc errors. Since the broadcast camera
>> involves more data processing and DDR memory access, there is a high
>> probability of getting ddr ecc errors over the period.
> 
> So you're saying the camera has memory with ECC? People really pay
> attention on getting error free video frames? :-)
> 
> Or this is just an example? You're saying the PL will need ECC for some
> applications?

I believe that this is real example.
The another example can also be that Linux uses this PL memory with ECC
and PS memory for application because of whatever reason - speed for example.

But that configurations are real.

> 
>> So, the user should be intimated with these errors when they occur and if the error rate
>>  is high, then the user can consider the preventive methods. Without this error reporting
>> mechanism it is difficult to debug the issues like memory corruption, kernel oops which
>>  may occur due to ddr ecc failures.
>>
>> Since, the memory controllers are different, it need two edac drivers for reporting the ecc 
>> errors and also maintaining the statistics of that particular memory controller. With the current
>> framework, there is a chance that both the drivers get mc_num as zero and malfunction. 
>> Assume the code for the two drivers looks like below
>>
>> Driver 1:
>> 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
>> 			    sizeof(struct  ctrl1_drvdata));
>>
>> Driver 2:
>> 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
>> 			    sizeof(struct ctrl2_drvdata));
>>
>> Issue:
>>   Since driver is providing the mc_num to framework, now there is chance that only one device active as
>>  both the drivers claiming the same number.
>>
>> Solution 1:
>>  Keep two drivers in single file and use static global variable for tracking the mc_num. This solution looks
>> good but the drivers may not be generic as these driver would be in a zynq_edac.c file. So others may not
>> reuse these drivers
> 
> Ok, I think I know what you mean. And this architecture works just fine.
> On x86 we have one EDAC instance per memory controller so on a multinode
> machine with multiple memory controllers, we do edac_mc_alloc() per
> memory controller.
> 
> For examples, see amd64_edac::init_one_instance() and sb_edac should
> have this too. So you basically have a local array of instances which
> you allocate and setup.
> 
> If someone wants to reuse the driver, then we can talk about this later,
> when the time comes.
>
> For now I think you should put both PS and PL stuff in one file,
> zynq_edac or so.
> 
> Any issues with this design?

Mixing two drivers in the one file is not a good idea because with more
memory controllers it is just a mess and you are not able to cover all cases.

If this is just about providing uniq number we can easily extend binding
and provide that uniq value.
That's remind me solution with edac_mc_get_id() can caused that you won't have
exact number all the time - depends on driver loading (deferred probing too).

One option via DT can be via aliases where you can easily specify order.
But all of these issues can be solved in follow-up patch.

Thanks,
Michal


