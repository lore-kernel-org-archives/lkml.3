Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828AbaGRRFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:05:50 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:43665
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965324AbaGRRFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:05:48 -0400
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Topic: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Index: AQHPgAqq5L1zp+ngQ0O2dQQp+rFvKZthLVSAgAABPoCAAh+9gIAAFcfQgADyoICAAAl2AIAACGQAgBY2XeCAKpUUYIABAMeAgAAYEBCAAAW3gIAAAfiQ
Date: Fri, 18 Jul 2014 17:05:45 +0000
Message-ID: <7c46a791325a40fd82572fd3a09726d9@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
	 <1401901323.17510.23.camel@dabdike>
	 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
	 <53911A35.7010805@cs.wisc.edu>
	 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
	 <5391F801.4010107@cs.wisc.edu>
	 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
	 <539206FA.1020001@kernel.dk>
	 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
	 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
	 <20140718151039.GA7425@infradead.org>
	 <2d43adebbc47441084d8e1284507a427@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <1405702633.30262.3.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1405702633.30262.3.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:6096:f50e:99e4:cc9a]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(24454002)(51704005)(13464003)(377454003)(199002)(377424004)(46102001)(93886003)(81342001)(74316001)(86612001)(101416001)(74502001)(106116001)(106356001)(110136001)(76482001)(77096002)(33646002)(54356999)(105586002)(74662001)(83072002)(81542001)(79102001)(80022001)(20776003)(76176999)(107046002)(83322001)(85306003)(85852003)(2656002)(19580395003)(92566001)(31966008)(19580405001)(86362001)(77982001)(4396001)(87936001)(50986999)(15975445006)(21056001)(99286002)(15202345003)(76576001)(95666004)(99396002)(64706001)(108616002)(3826002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Friday, July 18, 2014 9:57 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org; apw@canonical.com;
> devel@linuxdriverproject.org; michaelc@cs.wisc.edu; axboe@kernel.dk;
> linux-scsi@vger.kernel.org; ohering@suse.com;
> gregkh@linuxfoundation.org; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
> from the basic I/O timeout
> 
> On Fri, 2014-07-18 at 16:44 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Christoph Hellwig (hch@infradead.org)
> > > [mailto:hch@infradead.org]
> > > Sent: Friday, July 18, 2014 8:11 AM
> > > To: KY Srinivasan
> > > Cc: Jens Axboe; James Bottomley; michaelc@cs.wisc.edu; Christoph
> > > Hellwig (hch@infradead.org); linux-scsi@vger.kernel.org;
> > > gregkh@linuxfoundation.org; jasowang@redhat.com; linux-
> > > kernel@vger.kernel.org; ohering@suse.com; apw@canonical.com;
> > > devel@linuxdriverproject.org
> > > Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the
> > > FLUSH_TIMEOUT from the basic I/O timeout
> > >
> > > On Thu, Jul 17, 2014 at 11:53:33PM +0000, KY Srinivasan wrote:
> > > > I still see this problem. There was talk of fixing it elsewhere.
> > >
> > > Well, what we have right not is entirely broken, given that the
> > > block layer doesn't initialize ->timeout on TYPE_FS requeuests.
> > >
> > > We either need to revert that initial commit or apply something like
> > > the attached patch as a quick fix.
> > I had sent this exact patch sometime back:
> >
> > http://www.spinics.net/lists/linux-scsi/msg75385.html
> 
> Actually, no you didn't.  The difference is in the derivation of the timeout.
> Christoph's patch is absolute in terms of SD_TIMEOUT; yours is relative to the
> queue timeout setting ... I thought there was a reason for preferring the
> relative version.

You are right; sorry about that. I think my version is better since we do want to base the
flush timeout relative to the basic timeout.

K. Y
> 
> James

