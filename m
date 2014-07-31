Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaGaOTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:19:48 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:57423
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750859AbaGaOTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:19:45 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: Borislav Petkov <bp@alien8.de>, Michal Simek <michals@xilinx.com>
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
Subject: RE: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Thread-Topic: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr
 ecc controller
Thread-Index: AQHPrLM94VO4hX43QSOxWbwM1x4+UJu6KhS2gAALH+2AAAFz4A==
Date: Thu, 31 Jul 2014 14:19:20 +0000
References: <9dc2a947-d2ab-4f00-8ed3-d2499cb6fdfd@BN1BFFO11FD002.protection.gbl>
 <20140731113324.GB4375@pd.tnic>
 <808655a9-77eb-4e3a-9781-2b059ad9517b@BN1AFFO11FD020.protection.gbl>
 <20140731131702.GC4375@pd.tnic>
 <a366b39c-b354-4d90-8b1e-71e74ab77cf3@BL2FFO11FD011.protection.gbl>
 <20140731135652.GD4375@pd.tnic>
In-Reply-To: <20140731135652.GD4375@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.228.130]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <299a13fb-f442-4ebf-b0fc-d09d0dfc536d@BN1AFFO11FD019.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(52044002)(13464003)(189002)(199002)(51704005)(24454002)(377454003)(33646002)(83072002)(76482001)(74316001)(92726001)(77982001)(81342001)(2656002)(64706001)(87936001)(50986999)(92566001)(83322001)(21056001)(79102001)(74502001)(70736001)(4396001)(74662001)(104016003)(19580405001)(46102001)(50466002)(54356999)(6806004)(107046002)(31966008)(81542001)(85306003)(95666004)(93886003)(1496007)(76176999)(86362001)(44976005)(85852003)(53416004)(47776003)(19580395003)(20776003)(106466001)(80022001)(31696002)(106116001)(77096002)(107986001)(217873001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB026;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0289B6431E
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6VEJr4s008995

Hi Boris,

>-----Original Message-----
>From: Borislav Petkov [mailto:bp@alien8.de]
>Sent: Thursday, July 31, 2014 7:27 PM
>To: Michal Simek
>Cc: Punnaiah Choudary Kalluri; dougthompson@xmission.com;
>robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com;
>ijc+devicetree@hellion.org.uk; Kumar Gala; Rob Landley;
>devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-
>edac@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org; Punnaiah Choudary; Anirudha Sarangi; Srikanth
>Vemula
>Subject: Re: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr
>ecc controller
>
>On Thu, Jul 31, 2014 at 03:36:35PM +0200, Michal Simek wrote:
>> Mixing functions for two/more different controller seems to me
>> really messy.
>
>Just stating that something is "really messy" without giving at least
>one technical reason for it is not going to get you any further. So let
>me give you mine:
>
>I think it is not messy because one file contains all the EDAC code for
>that system. Like every other system out there uses one EDAC driver.
>Everything is nicely contained in one place, any communication between
>the two memory controllers is done internally in that driver.
>
>Having two drivers would make that much more complicated. But hey, if
>you want to make your life more complicated because it is not enough
>complicated, feel free to do so. Just make sure you don't impose any
>restrictions on the rest of the subsystem.

Here we are also considering reusability of the driver. Let's say if some other
SOC contains Synopsys ddr controller then this driver can be reused. In this case,
Having separate driver would be good. But as you said in your previous comment,
We will talk about this later. 

Thanks,
Punnaiah
>
>> > -ENOPARSE for this sentence.
>>
>> I meant by this this scenario - please correct me if I am completely wrong
>> because I am not playing with this subsystem. My expectation is that
>> memory controller number should be same all the time.
>>
>> two memory controllers with the same edac driver.
>>
>> Normal calling sequence:
>> X probe - number 0
>> Y probe - number 1
>>
>> Different order/name (I think order is taken at the first place)
>> in DTS should caused that X will have number 1 and Y number 0.
>>
>> Another scenario:
>> two controllers and one with external gpio reset for example.
>>
>> X probe is called but gpio controller is not ready and gpio driver returns
>> -EPROBE_DEFER then Y probe is called and get number 0. Then X probe is
>called
>> again and get number 1.
>
>Right, since you have a heterogeneous design, you'd need to account
>for all that in your driver and deal with probing order. Like having a
>way to ask a controller what kind of a controller it is and so on. I'm
>afraid I don't know anything about your design to be of more help there.
>
>However, doing this in one <name>_edac.c file is almost trivial than
>doing it with two separate drivers. Unless you don't need to do any
>meaningful communication between the PS and PL. Then it doesn't matter.
>
>If I were you, I'd spend a more time on a proper design now so that all
>my work later is easy. Adding two drivers just because it seems messy is
>not a very good idea. What I would do is analyze all my use cases and
>come up with a proper design then. But this is just me.
>
>HTH.
>
>--
>Regards/Gruss,
>    Boris.
>
>Sent from a fat crate under my desk. Formatting is fine.
>--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
