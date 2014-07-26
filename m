Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaGZNoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 09:44:13 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:26583
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751319AbaGZNoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 09:44:11 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Sitsofe Wheeler <sitsofe@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Topic: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Index: AQHPqCl0fmLHK0GnrkSEOCNbbvYH8ZuyXrXw
Date: Sat, 26 Jul 2014 13:44:08 +0000
Message-ID: <e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(13464003)(377454003)(199002)(189002)(21056001)(77982001)(85306003)(99396002)(95666004)(81542001)(105586002)(101416001)(19580405001)(20776003)(92566001)(81342001)(106116001)(74502001)(64706001)(4396001)(33646002)(87936001)(85852003)(54356999)(83072002)(76176999)(74662001)(110136001)(79102001)(19580395003)(83322001)(76576001)(77096002)(2656002)(80022001)(86612001)(99286002)(74316001)(107046002)(50986999)(86362001)(46102001)(66066001)(31966008)(76482001)(93886003)(106356001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Friday, July 25, 2014 9:57 AM
> To: KY Srinivasan
> Cc: Martin K. Petersen; Sitsofe Wheeler; Christoph Hellwig;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> 
> KY> For the pass through case, the host validates the request and passes
> KY> the request to the device.  However, not all scsi commands are
> KY> passed through even though the device it is being passed through may
> KY> support the command. WRITE_SAME is one such command.
> Consequently,
> KY> in the EVPD page, we will set state indicating that WRITE_SAME is
> KY> not supported (even if the device supports it).
> 
> The LBP VPD page flags UNMAP as being supported. Do you actually support
> UNMAP to DSM TRIM SCSI-ATA translation?

Martin,

I have been told by the Windows folks that this is done. I am trying to get
additional details.

K. Y
> 
> One challenge in that department is that a single UNMAP command may turn
> into many, many, many DSM TRIM commands on the underlying SATA
> device.
> That's why we went with WRITE SAME for the internal Linux SATL, capping
> the maximum number of blocks to what we can fit in a single DSM TRIM
> command.
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
