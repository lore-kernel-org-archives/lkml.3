Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaG3Pl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:41:57 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:44196
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754109AbaG3Ply (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:41:54 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: Borislav Petkov <bp@alien8.de>
CC: "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        Michal Simek <michals@xilinx.com>,
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
Subject: RE: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Thread-Topic: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr
 ecc controller
Thread-Index: Ac+sDL1D4VO4hX43QSOxWbwM1x4+UA==
Date: Wed, 30 Jul 2014 15:41:47 +0000
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.231.182]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <9dc2a947-d2ab-4f00-8ed3-d2499cb6fdfd@BN1BFFO11FD002.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(13464003)(51704005)(377454003)(24454002)(199002)(189002)(19580405001)(50986999)(19580395003)(83322001)(64706001)(86362001)(110136001)(83072002)(23676002)(47776003)(85306003)(79102001)(81342001)(53416004)(80022001)(74316001)(21056001)(2656002)(50466002)(33646002)(77096002)(70736001)(44976005)(46102001)(92726001)(31696002)(104016003)(92566001)(77982001)(76482001)(74502001)(95666004)(99396002)(1496007)(85852003)(87936001)(20776003)(106466001)(74662001)(6806004)(107046002)(54356999)(81542001)(31966008)(4396001)(107986001)(23106004)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB067;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0288CD37D9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6UFg17i002122

Hi Boris,

>-----Original Message-----
>From: Borislav Petkov [mailto:bp@alien8.de]
>Sent: Monday, July 28, 2014 11:32 PM
>To: Punnaiah Choudary Kalluri
>Cc: Punnaiah Choudary Kalluri; dougthompson@xmission.com;
>robh+dt@kernel.org; pawel.moll@arm.com; Michal Simek;
>mark.rutland@arm.com; ijc+devicetree@hellion.org.uk; Kumar Gala; Rob
>Landley; devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-
>edac@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org; Punnaiah Choudary; Anirudha Sarangi; Srikanth
>Vemula
>Subject: Re: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr
>ecc controller
>
>On Mon, Jul 28, 2014 at 10:53:26PM +0530, punnaiah choudary kalluri wrote:
>> I can agree with you that we can use shorter names.But ZYNQ has
>> programmable logic next to processing system where one can add soft
>> memory controller in the same system and may use different driver. So,
>> the edac driver for zynq may include multiple drivers for different
>> memory controllers in the same file. In this case it is difficult to
>> maintain generic macros as you suggested above.
>
>So?
>
>You can still shorten them a bit - the current names are awfully long.
>SYNPS_DDRC_ECC_ is too much information, for example. We know it is DDR
>and we know it is about ECC. So do SYNPS and ZYNQ or OTHER or whatever
>you wanna call it prefix and then the rest. I.e.,
>
>    SYNPS_<reg>_<bits*>
>    ZYNQ_<reg>_bits*>
>
>You can even use single letter prefixes like S_ and Z_ and add a comment
>explaining what those mean. Still much more readable than the long
>repeating prefixes currently.

Ok.
>
>> Also the current edac framework for edac memory controllers is
>> expecting the mc_num from the driver while allocating the memory
>> controller instance using the edac_mc_alloc function. This requirement
>> mandates that if the system contains two different memory controllers
>> then the corresponding edac drivers should be in single file.
>
>So you're telling me that you want one edac driver for *two* memory
>controllers which can be present on a single system *at* *the* *same*
>*time*? Is that it?

Yes.
>
>How exactly is that topology supposed to look like, work, etc, etc? What
>kind of error reporting do you imagine you want to do with EDAC?

Zynq (All programmable SOC) contains a dual core ARM cortex A9 based processing
System(PS) and Xilinx programmable logic(PL) in a single device.

Assume the application is a broadcast camera. The design for this system use PS as
Control plane and use PL as data plane for processing the video data. So, the design 
may have two different memory controllers one in PS and another one in PL.   
PS is running with Linux OS and PL doesn't have the OS and it is  controlled by the 
OS running on PS.
 Now the requirement is to develop a monitoring system for all the hardware failures 
Including ddr ecc errors. Since the broadcast camera involves more data processing and
DDR memory access, there is a high probability of getting ddr ecc errors over the period.
So, the user should be intimated with these errors when they occur and if the error rate
 is high, then the user can consider the preventive methods. Without this error reporting
mechanism it is difficult to debug the issues like memory corruption, kernel oops which
 may occur due to ddr ecc failures.

Since, the memory controllers are different, it need two edac drivers for reporting the ecc 
errors and also maintaining the statistics of that particular memory controller. With the current
framework, there is a chance that both the drivers get mc_num as zero and malfunction. 
Assume the code for the two drivers looks like below

Driver 1:
	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
			    sizeof(struct  ctrl1_drvdata));

Driver 2:
	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
			    sizeof(struct ctrl2_drvdata));

Issue:
  Since driver is providing the mc_num to framework, now there is chance that only one device active as
 both the drivers claiming the same number.

Solution 1:
 Keep two drivers in single file and use static global variable for tracking the mc_num. This solution looks
good but the drivers may not be generic as these driver would be in a zynq_edac.c file. So others may not
reuse these drivers
static int mc_num = 0;

Driver 1:
	mci = edac_mc_alloc(mc_num, ARRAY_SIZE(layers), layers,
			    sizeof(struct  ctrl1_drvdata));
              mc_num++;

Driver 2:
	mci = edac_mc_alloc(mc_num, ARRAY_SIZE(layers), layers,
			    sizeof(struct ctrl2_drvdata));
                 mc_num++;

Solution 2:
  Let the framework assign the mc_num to the edac driver

     mc_num = edac_mc_get_id(); /* returns the next available mci slot */
     mci = edac_mc_alloc(mc_num,...);


In my opinion solution 2  looks neat and it eliminates the dependency on tracking
 the mc_num.

Please suggest your view on this solution.
 
At this point of time, my requirement is reporting the ecc correctable and uncorrectable
 errors and also maintaining the error stats for future decision making. Since the linux edac
Framework is ready, we decided to use this framework.
 
Meanwhile, I will  submit the next revision of the patch for the above cooments. 

Regards,
Punnaiah
>
>IOW, more info would be appreciated.
>
>Thanks.
>
>--
>Regards/Gruss,
>    Boris.
>
>Sent from a fat crate under my desk. Formatting is fine.
>--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
