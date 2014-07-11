Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaGKSCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:02:51 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:48462
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754725AbaGKSCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:02:49 -0400
X-WSS-ID: 0N8K7GD-07-B9F-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Jerome Glisse <j.glisse@gmail.com>, Oded Gabbay <oded.gabbay@gmail.com>
CC: David Airlie <airlied@linux.ie>,
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
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: RE: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for AMD's
 GPUs
Thread-Topic: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for
 AMD's GPUs
Thread-Index: AQHPnIkb5diGFGXBaU2zmOlo79UQFpubXkIA///KTOA=
Date: Fri, 11 Jul 2014 18:02:39 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01031B37@storexdag02.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
 <20140711170411.GJ1870@gmail.com>
In-Reply-To: <20140711170411.GJ1870@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(13464003)(377454003)(189002)(51704005)(199002)(31966008)(85306003)(107046002)(106466001)(21056001)(106116001)(105586002)(4396001)(47776003)(68736004)(83322001)(23726002)(53416004)(77982001)(55846006)(76482001)(79102001)(95666004)(77096002)(97756001)(101416001)(92726001)(50466002)(99396002)(76176999)(33656002)(54356999)(86362001)(81542001)(83072002)(2656002)(84676001)(81342001)(87936001)(92566001)(74502001)(64706001)(97736001)(44976005)(80022001)(19580395003)(19580405001)(74662001)(20776003)(85852003)(50986999)(46102001)(46406003);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB048;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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
>Sent: Friday, July 11, 2014 1:04 PM
>To: Oded Gabbay
>Cc: David Airlie; Deucher, Alexander; linux-kernel@vger.kernel.org; dri-
>devel@lists.freedesktop.org; Bridgman, John; Lewycky, Andrew; Joerg
>Roedel; Gabbay, Oded; Greg Kroah-Hartman; Rafael J. Wysocki; Kishon Vijay
>Abraham I; Sandeep Nair; Kenneth Heitke; Srinivas Pandruvada; Santosh
>Shilimkar; Andreas Noever; Lucas Stach; Philipp Zabel
>Subject: Re: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for
>AMD's GPUs
>
>On Fri, Jul 11, 2014 at 12:50:09AM +0300, Oded Gabbay wrote:
>> This patch adds the code base of the hsa driver for
>> AMD's GPUs.
>>
>> This driver is called kfd.
>>
>> This initial version supports the first HSA chip, Kaveri.
>>
>> This driver is located in a new directory structure under drivers/gpu.
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>
>There is too coding style issues. While we have been lax on the enforcing the
>scripts/checkpatch.pl rules i think there is a limit to that. I am not strict
>on the 80chars per line but others things needs fixing so we stay inline.
>
>Also i am a bit worried about the license, given top comment in each of the
>files i am not sure this is GPL2 compatible. I would need to ask lawyer to
>review that.
>

Hi Jerome,

Which line in the license are you concerned about ? In theory we're using the same license as the initial code pushes for radeon, and I just did a side-by side compare with the license header on cik.c in the radeon tree and confirmed that the two licenses are identical. 

The cik.c header has an additional "Authors:" line which the kfd files do not, but AFAIK that is not part of the license text proper.

JB
