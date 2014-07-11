Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaGKTCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:02:19 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:15603
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751876AbaGKTCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:02:17 -0400
X-WSS-ID: 0N8K9HK-08-K2G-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Jerome Glisse <j.glisse@gmail.com>
CC: Oded Gabbay <oded.gabbay@gmail.com>, David Airlie <airlied@linux.ie>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, "Gabbay, Oded" <Oded.Gabbay@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Santosh Shilimkar" <santosh.shilimkar@ti.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        "Philipp Zabel" <p.zabel@pengutronix.de>
Subject: RE: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for AMD's
 GPUs
Thread-Topic: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for
 AMD's GPUs
Thread-Index: AQHPnIkb5diGFGXBaU2zmOlo79UQFpubXkIA///KTOCAAEhWAP//xU+A
Date: Fri, 11 Jul 2014 18:46:30 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01031C4E@storexdag02.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
 <20140711170411.GJ1870@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01031B37@storexdag02.amd.com>
 <20140711181053.GK1870@gmail.com>
In-Reply-To: <20140711181053.GK1870@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(51704005)(377454003)(199002)(24454002)(13464003)(81542001)(81342001)(84676001)(2656002)(83072002)(33656002)(76176999)(54356999)(86362001)(87936001)(23756003)(50986999)(46102001)(85852003)(74502001)(92566001)(64706001)(19580395003)(20776003)(19580405001)(74662001)(44976005)(97736001)(80022001)(47776003)(83322001)(68736004)(4396001)(77982001)(93886003)(53416004)(21056001)(106466001)(31966008)(85306003)(107046002)(106116001)(105586002)(110136001)(99396002)(79102001)(55846006)(76482001)(101416001)(50466002)(92726001)(95666004)(77096002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB048;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02698DF457
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Jerome Glisse [mailto:j.glisse@gmail.com]
>Sent: Friday, July 11, 2014 2:11 PM
>To: Bridgman, John
>Cc: Oded Gabbay; David Airlie; Deucher, Alexander; linux-
>kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Lewycky, Andrew;
>Joerg Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J. Wysocki; Kishon
>Vijay Abraham I; Sandeep Nair; Kenneth Heitke; Srinivas Pandruvada;
>Santosh Shilimkar; Andreas Noever; Lucas Stach; Philipp Zabel
>Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for
>AMD's GPUs
>
>On Fri, Jul 11, 2014 at 06:02:39PM +0000, Bridgman, John wrote:
>> >From: Jerome Glisse [mailto:j.glisse@gmail.com]
>> >Sent: Friday, July 11, 2014 1:04 PM
>> >To: Oded Gabbay
>> >Cc: David Airlie; Deucher, Alexander; linux-kernel@vger.kernel.org;
>> >dri- devel@lists.freedesktop.org; Bridgman, John; Lewycky, Andrew;
>> >Joerg Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J. Wysocki;
>> >Kishon Vijay Abraham I; Sandeep Nair; Kenneth Heitke; Srinivas
>> >Pandruvada; Santosh Shilimkar; Andreas Noever; Lucas Stach; Philipp
>> >Zabel
>> >Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver
>> >for AMD's GPUs
>> >
>> >On Fri, Jul 11, 2014 at 12:50:09AM +0300, Oded Gabbay wrote:
>> >> This patch adds the code base of the hsa driver for AMD's GPUs.
>> >>
>> >> This driver is called kfd.
>> >>
>> >> This initial version supports the first HSA chip, Kaveri.
>> >>
>> >> This driver is located in a new directory structure under drivers/gpu.
>> >>
>> >> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> >
>> >There is too coding style issues. While we have been lax on the
>> >enforcing the scripts/checkpatch.pl rules i think there is a limit to
>> >that. I am not strict on the 80chars per line but others things needs fixing
>so we stay inline.
>> >
>> >Also i am a bit worried about the license, given top comment in each
>> >of the files i am not sure this is GPL2 compatible. I would need to
>> >ask lawyer to review that.
>> >
>>
>> Hi Jerome,
>>
>> Which line in the license are you concerned about ? In theory we're using
>the same license as the initial code pushes for radeon, and I just did a side-by
>side compare with the license header on cik.c in the radeon tree and
>confirmed that the two licenses are identical.
>>
>> The cik.c header has an additional "Authors:" line which the kfd files do
>not, but AFAIK that is not part of the license text proper.
>>
>
>You can not claim GPL if you want to use this license. radeon is weird best for
>historical reasons as we wanted to share code with BSD thus it is dual
>licensed and this is reflected with :
>MODULE_LICENSE("GPL and additional rights");
>
>inside radeon_drv.c
>
>So if you want to have MODULE_LICENSE(GPL) then you should have header
>that use the GPL license wording and no wording from BSD like license.
>Otherwise change the MODULE_LICENSE and it would also be good to say
>dual licensed at top of each files (or least next to each license) so that it is
>clear this is BSD & GPL license.

Got it. Missed that we had a different MODULE_LICENSE.

Since the goal is license compatibility with radeon so we can update the interface and move code between the drivers in future I guess my preference would be to update MODULE_LICENSE in the kfd code to "GPL and additional rights", do you think that would be OK ?
>
>Cheers,
>Jérôme
