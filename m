Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaGKS4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:56:25 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:38330
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755089AbaGKS4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:56:22 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2014 14:56:22 EDT
X-WSS-ID: 0N8K9XN-07-E64-02
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
Thread-Index: AQHPnIkb5diGFGXBaU2zmOlo79UQFpubXkIA///KTOCAAEhWAP//xU+AgABGFQD//71L0A==
Date: Fri, 11 Jul 2014 18:56:12 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01031CAD@storexdag02.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
 <20140711170411.GJ1870@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01031B37@storexdag02.amd.com>
 <20140711181053.GK1870@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01031C4E@storexdag02.amd.com>
 <20140711185138.GN1870@gmail.com>
In-Reply-To: <20140711185138.GN1870@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(377454003)(13464003)(189002)(199002)(51704005)(95666004)(20776003)(31966008)(74662001)(106466001)(80022001)(86362001)(107046002)(55846006)(99396002)(106116001)(92726001)(54356999)(74502001)(83322001)(105586002)(19580395003)(33656002)(23756003)(4396001)(110136001)(50466002)(19580405001)(44976005)(47776003)(101416001)(2656002)(77982001)(83072002)(64706001)(21056001)(79102001)(84676001)(77096002)(97736001)(81342001)(46102001)(68736004)(92566001)(93886003)(50986999)(87936001)(53416004)(85852003)(85306003)(76482001)(81542001)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB036;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02698DF457
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Jerome Glisse [mailto:j.glisse@gmail.com]
>Sent: Friday, July 11, 2014 2:52 PM
>To: Bridgman, John
>Cc: Oded Gabbay; David Airlie; Deucher, Alexander; linux-
>kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Lewycky, Andrew;
>Joerg Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J. Wysocki; Kishon
>Vijay Abraham I; Sandeep Nair; Kenneth Heitke; Srinivas Pandruvada;
>Santosh Shilimkar; Andreas Noever; Lucas Stach; Philipp Zabel
>Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for
>AMD's GPUs
>
>On Fri, Jul 11, 2014 at 06:46:30PM +0000, Bridgman, John wrote:
>> >From: Jerome Glisse [mailto:j.glisse@gmail.com]
>> >Sent: Friday, July 11, 2014 2:11 PM
>> >To: Bridgman, John
>> >Cc: Oded Gabbay; David Airlie; Deucher, Alexander; linux-
>> >kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; Lewycky,
>> >Andrew; Joerg Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J.
>> >Wysocki; Kishon Vijay Abraham I; Sandeep Nair; Kenneth Heitke;
>> >Srinivas Pandruvada; Santosh Shilimkar; Andreas Noever; Lucas Stach;
>> >Philipp Zabel
>> >Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver
>> >for AMD's GPUs
>> >
>> >On Fri, Jul 11, 2014 at 06:02:39PM +0000, Bridgman, John wrote:
>> >> >From: Jerome Glisse [mailto:j.glisse@gmail.com]
>> >> >Sent: Friday, July 11, 2014 1:04 PM
>> >> >To: Oded Gabbay
>> >> >Cc: David Airlie; Deucher, Alexander;
>> >> >linux-kernel@vger.kernel.org;
>> >> >dri- devel@lists.freedesktop.org; Bridgman, John; Lewycky, Andrew;
>> >> >Joerg Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J. Wysocki;
>> >> >Kishon Vijay Abraham I; Sandeep Nair; Kenneth Heitke; Srinivas
>> >> >Pandruvada; Santosh Shilimkar; Andreas Noever; Lucas Stach;
>> >> >Philipp Zabel
>> >> >Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver
>> >> >for AMD's GPUs
>> >> >
>> >> >On Fri, Jul 11, 2014 at 12:50:09AM +0300, Oded Gabbay wrote:
>> >> >> This patch adds the code base of the hsa driver for AMD's GPUs.
>> >> >>
>> >> >> This driver is called kfd.
>> >> >>
>> >> >> This initial version supports the first HSA chip, Kaveri.
>> >> >>
>> >> >> This driver is located in a new directory structure under drivers/gpu.
>> >> >>
>> >> >> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> >> >
>> >> >There is too coding style issues. While we have been lax on the
>> >> >enforcing the scripts/checkpatch.pl rules i think there is a limit
>> >> >to that. I am not strict on the 80chars per line but others things
>> >> >needs fixing
>> >so we stay inline.
>> >> >
>> >> >Also i am a bit worried about the license, given top comment in
>> >> >each of the files i am not sure this is GPL2 compatible. I would
>> >> >need to ask lawyer to review that.
>> >> >
>> >>
>> >> Hi Jerome,
>> >>
>> >> Which line in the license are you concerned about ? In theory we're
>> >> using
>> >the same license as the initial code pushes for radeon, and I just
>> >did a side-by side compare with the license header on cik.c in the
>> >radeon tree and confirmed that the two licenses are identical.
>> >>
>> >> The cik.c header has an additional "Authors:" line which the kfd
>> >> files do
>> >not, but AFAIK that is not part of the license text proper.
>> >>
>> >
>> >You can not claim GPL if you want to use this license. radeon is
>> >weird best for historical reasons as we wanted to share code with BSD
>> >thus it is dual licensed and this is reflected with :
>> >MODULE_LICENSE("GPL and additional rights");
>> >
>> >inside radeon_drv.c
>> >
>> >So if you want to have MODULE_LICENSE(GPL) then you should have
>> >header that use the GPL license wording and no wording from BSD like
>license.
>> >Otherwise change the MODULE_LICENSE and it would also be good to say
>> >dual licensed at top of each files (or least next to each license) so
>> >that it is clear this is BSD & GPL license.
>>
>> Got it. Missed that we had a different MODULE_LICENSE.
>>
>> Since the goal is license compatibility with radeon so we can update the
>interface and move code between the drivers in future I guess my
>preference would be to update MODULE_LICENSE in the kfd code to "GPL and
>additional rights", do you think that would be OK ?
>
>I am not a lawyer and nothing that i said should be considered as legal advice
>(on the contrary ;)) I think you need to be more clear with each license to
>clear says GPLv2 or BSD ie dual licensed but the dual license is a beast you
>would definitly want to talk to lawyer about.

Yeah, dual license seems horrid in its implications for developers so we've always tried to avoid it. GPL hurts us for porting to other OSes so the X11 / "GPL with additional rights" combo seemed like the ideal solution and we made it somewhat of a corporate standard. Hope that doesn't come back to haunt us. 

Meditate on this I will. Thanks !

>
>Cheers,
>Jérôme
