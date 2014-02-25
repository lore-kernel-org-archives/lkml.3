Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaBYL2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:28:55 -0500
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:51634
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752942AbaBYL2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:28:53 -0500
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Will Deacon <will.deacon@arm.com>,
        srikanth TS <srikantht.shivanand@gmail.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "sungjinn.chung@samsung.com" <sungjinn.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ts.srikanth@samsung.com" <ts.srikanth@samsung.com>
Subject: RE: your mail
Thread-Topic: your mail
Thread-Index: AQHPMXubTQzokZ7KHEeVt2HkNdiwNZrEqMsAgAEr10A=
Date: Tue, 25 Feb 2014 11:28:49 +0000
Message-ID: <42a1041ac2df4a73a94dc4516969e35d@BL2PR03MB468.namprd03.prod.outlook.com>
References: <CAM0G4zvu1BHcOrSgBuobvb-+fVsNWXjXdzZdV51T70B9_ZC4XQ@mail.gmail.com>
 <20140224172850.GG2553@mudshark.cambridge.arm.com>
In-Reply-To: <20140224172850.GG2553@mudshark.cambridge.arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 01334458E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(13464003)(199002)(189002)(24454002)(377454003)(92566001)(93516002)(81342001)(94316002)(81542001)(83322001)(80976001)(19580395003)(19580405001)(86362001)(87936001)(50986001)(33646001)(74876001)(83072002)(47736001)(2656002)(76796001)(4396001)(87266001)(221733001)(49866001)(47976001)(69226001)(56816005)(90146001)(85306002)(76786001)(76576001)(74706001)(76482001)(51856001)(74662001)(81816001)(59766001)(77982001)(95416001)(74366001)(95666003)(93136001)(31966008)(85852003)(56776001)(54356001)(94946001)(63696002)(80022001)(79102001)(81686001)(46102001)(66066001)(47446002)(74316001)(54316002)(53806001)(74502001)(65816001)(111123002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB402;H:BL2PR03MB468.namprd03.prod.outlook.com;CLIP:192.88.169.1;FPR:3E8ED996.9F121D2A.71DBB56C.84E4FA3C.202AC;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Will Deacon
> Sent: Monday, February 24, 2014 10:59 PM
> To: srikanth TS
> Cc: iommu@lists.linux-foundation.org; sungjinn.chung@samsung.com; linux-
> kernel@vger.kernel.org; ts.srikanth@samsung.com
> Subject: Re: your mail
> 
> On Mon, Feb 24, 2014 at 03:12:21PM +0000, srikanth TS wrote:
> > Hi Will Deacon,
> 
> Hello,
> 
> > Currently SMMU driver expecting all stream ID used by respective
> > master should be defined in the DT.
> >
> > We want to know how to handle in the case of virtual functions
> > dynamically created and destroyed.
> >
> > Is PCI driver responsible for creating stream ID respective BDand
> > requesting SMMU to add to the mapping table[stream Id to context
> > mapping table]?
> >
> > Or is there any right way of doing it?
> 
> Correct, the driver currently doesn't support dynamic mappings (mainly
> because I didn't want to try and invent something that I couldn't test).
> 
> There are a couple of ways to solve this:
> 
>   (1) Add a way for a PCI RC to dynamically allocate StreamIDs on an SMMU
>       within a fixed range. That would probably need some code in the bus
>       layer, so that a bus notifier can kick and call back to the
> relevant
>       SMMU.
This could be done in add device notifier. I am working on similar(not PCI) hot plug device infrastructure for arm smmu driver. I will post an RFC patch by next week.

-Varun

