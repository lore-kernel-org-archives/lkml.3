Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaG0CJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 22:09:34 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:50153
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751219AbaG0CJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 22:09:33 -0400
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
Thread-Index: AQHPqQdbfmLHK0GnrkSEOCNbbvYH8ZuzLCRw
Date: Sun, 27 Jul 2014 02:09:27 +0000
Message-ID: <84e49b68e6e14d259b5edc2c76fa1f1b@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
	<e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq17g30dprc.fsf@sermon.lab.mkp.net>
	<cc4a3fd5451242739929d266b88fa8fa@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq138dnexcn.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq138dnexcn.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(377454003)(164054003)(189002)(13464003)(199002)(107046002)(95666004)(76176999)(92566001)(31966008)(19580405001)(76576001)(86612001)(99396002)(86362001)(106356001)(33646002)(19580395003)(80022001)(81342001)(101416001)(74502001)(105586002)(74662001)(85306003)(81542001)(21056001)(76482001)(46102001)(83322001)(74316001)(83072002)(2656002)(54356999)(79102001)(99286002)(87936001)(77982001)(64706001)(110136001)(85852003)(106116001)(93886003)(66066001)(4396001)(20776003)(77096002)(50986999)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Saturday, July 26, 2014 12:25 PM
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
> >> Great! I'd just like to have a reasonable level of confidence in
> >> what's happening down the stack before I entertain turning something
> >> on that's not being properly advertised.
> 
> KY> As I look at the output of inquiry between Linux on Hyper-V and
> KY> native Linux, is not specifying conformance level the main issue?
> 
> The main problem for this particular use case (aside from the issue we've
> already addressed) is that the passthrough device (SATA SSD) has
> LBPME=0 in the READ CAPACITY(16) response. The LBP VPD is correctly
> provided with LBPU flag set but because LBPME is reported as disabled we
> will not attempt to issue UNMAP commands to the device.

Oh; ok. I missed the read_capacity response.

Thanks,

K. Y
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
