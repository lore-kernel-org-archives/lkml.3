Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaG2RlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:41:12 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:15052
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750862AbaG2RlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:41:08 -0400
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "sitsofe@gmail.com" <sitsofe@gmail.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Topic: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Thread-Index: AQHPqpaEfmLHK0GnrkSEOCNbbvYH8Zu12EaQgACFs4CAAPUWYA==
Date: Tue, 29 Jul 2014 17:41:04 +0000
Message-ID: <a445e81eb25f46918e85f51c631f6094@BY2PR0301MB0711.namprd03.prod.outlook.com>
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
	 <548c8b1bae75483aa47c9493b62dc04d@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <1406577767.19418.11.camel@jarvis>
In-Reply-To: <1406577767.19418.11.camel@jarvis>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.159.173]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0287BBA78D
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377424004)(13464003)(377454003)(199002)(189002)(24454002)(51704005)(164054003)(93886003)(80022001)(66066001)(86612001)(20776003)(54356999)(86362001)(76176999)(106116001)(4396001)(81342001)(105586002)(95666004)(99286002)(74316001)(99396002)(101416001)(64706001)(81542001)(50986999)(77982001)(76482001)(83322001)(46102001)(87936001)(74662001)(19580405001)(74502001)(19580395003)(2656002)(85306003)(92566001)(31966008)(107046002)(77096002)(85852003)(76576001)(33646002)(83072002)(106356001)(110136001)(21056001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6THfGUZ026635



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Monday, July 28, 2014 1:03 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org; sitsofe@gmail.com;
> devel@linuxdriverproject.org; apw@canonical.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
> ohering@suse.com; gregkh@linuxfoundation.org; jasowang@redhat.com
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> On Mon, 2014-07-28 at 19:05 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> > > Sent: Monday, July 28, 2014 12:03 PM
> > > To: KY Srinivasan
> > > Cc: Martin K. Petersen; Sitsofe Wheeler; Christoph Hellwig;
> > > gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> > > jasowang@redhat.com; jbottomley@parallels.com; linux-
> > > scsi@vger.kernel.org
> > > Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks
> > > tests
> > >
> > > >>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:
> > >
> > > KY,
> > >
> > > KY> "At the time thin-provisioning was defined, the discovery
> > > KY> information was first proposed in READ CAPACITY 16 command. And
> > > then
> > > KY> moved into the new dedicated VPD page - B2h. You can see the
> > > KY> information reported in this VPD page is richer than READ
> > > KY> CAPACITY
> > > KY> 16 command. As this transition happened during we added the
> > > KY> feature, Windows uses the newer method that based on VPD page
> > > KY> B2h. It looks Linux tries to use both new and old method which is
> weird to me."
> > >
> > > The READ CAPACITY(16) response is not optional.
> >
> > Ok; that settles the issue then. I will attempt to get it fixed on Windows.
> 
> Like Martin says, this isn't optional either/or; it's mandatory to support the RC
> 16 bits.  If you don't want to get into playing the messenger between us and
> the windows guys on SCSI standards, we'd be happy to communicate
> directly, either by email or a phone meeting.

We will fix this bug in the next release of Windows; we are also looking at backporting the fix to prior versions of Windows.

Thanks,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
