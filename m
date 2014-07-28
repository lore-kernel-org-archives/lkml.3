Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaG1TFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:05:19 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:32916
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750956AbaG1TFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:05:14 -0400
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
Thread-Index: AQHPqpaEfmLHK0GnrkSEOCNbbvYH8Zu12EaQ
Date: Mon, 28 Jul 2014 19:05:10 +0000
Message-ID: <548c8b1bae75483aa47c9493b62dc04d@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
	<e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq17g30dprc.fsf@sermon.lab.mkp.net>
	<cc4a3fd5451242739929d266b88fa8fa@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq138dnexcn.fsf@sermon.lab.mkp.net>
	<43306901b1dc4e5dbe014a431e0935ea@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <yq11tt5cnmx.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq11tt5cnmx.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.16]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0286D7B531
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199002)(13464003)(377454003)(51704005)(66066001)(101416001)(80022001)(95666004)(77096002)(79102001)(99286002)(85306003)(106356001)(86612001)(105586002)(86362001)(99396002)(106116001)(93886003)(76576001)(77982001)(20776003)(87936001)(2656002)(85852003)(107046002)(110136001)(4396001)(83072002)(92566001)(31966008)(83322001)(81542001)(19580395003)(19580405001)(74662001)(54356999)(81342001)(76176999)(33646002)(64706001)(50986999)(46102001)(74502001)(76482001)(74316001)(21056001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Monday, July 28, 2014 12:03 PM
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
> KY,
> 
> KY> "At the time thin-provisioning was defined, the discovery
> KY> information was first proposed in READ CAPACITY 16 command. And
> then
> KY> moved into the new dedicated VPD page - B2h. You can see the
> KY> information reported in this VPD page is richer than READ CAPACITY
> KY> 16 command. As this transition happened during we added the feature,
> KY> Windows uses the newer method that based on VPD page B2h. It looks
> KY> Linux tries to use both new and old method which is weird to me."
> 
> The READ CAPACITY(16) response is not optional.

Ok; that settles the issue then. I will attempt to get it fixed on Windows.

K. Y

> 
> --
> Martin K. Petersen	Oracle Linux Engineering
