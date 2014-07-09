Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaGIXjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:39:47 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:43626
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbaGIXjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:39:45 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Christoph Hellwig <hch@infradead.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "ohering@suse.com" <ohering@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect
 the values on the host
Thread-Topic: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect
 the values on the host
Thread-Index: AQHPmwbkhR2ZqN76CEKfQBmR/e5a65uXbKgAgAC+28CAADmnkA==
Date: Wed, 9 Jul 2014 23:39:42 +0000
Message-ID: <70a32eae84164a60b6318246fcedfa55@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <20140709083954.GA6012@infradead.org>
 <e5e366a15a9f4a6fa1817b0f3b25a482@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <e5e366a15a9f4a6fa1817b0f3b25a482@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:bcf5:5a77:a2be:83f5]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(13464003)(24454002)(377454003)(189002)(199002)(81542001)(86612001)(74502001)(107046002)(79102001)(105586002)(86362001)(92566001)(106356001)(76482001)(99396002)(46102001)(19580405001)(64706001)(31966008)(93886003)(83322001)(1511001)(83072002)(76576001)(21056001)(85306003)(4396001)(81342001)(77982001)(87936001)(50986999)(33646001)(20776003)(101416001)(80022001)(74316001)(106116001)(54356999)(76176999)(19580395003)(85852003)(95666004)(99286002)(74662001)(2656002)(108616002)(3826002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: driverdev-devel-bounces@linuxdriverproject.org [mailto:driverdev-
> devel-bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Wednesday, July 9, 2014 1:07 PM
> To: Christoph Hellwig
> Cc: linux-scsi@vger.kernel.org; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; jbottomley@parallels.com; ohering@suse.com;
> stable@vger.kernel.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: RE: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect the
> values on the host
> 
> 
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Wednesday, July 9, 2014 1:40 AM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> > apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> > Subject: Re: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to
> > reflect the values on the host
> >
> > On Tue, Jul 08, 2014 at 05:46:45PM -0700, K. Y. Srinivasan wrote:
> > > + * In Hyper-V, each port/path/target maps to 1 scsi host adapter.
> >
> > Does it still?  The STORVSC_FC_MAX_TARGETS define suggests otherwise.
> 
> I will fix the comments and get rid of unnecessary comments.
> 
> >
> > > -	.cmd_per_lun =		1,
> > > +	.cmd_per_lun =		255,
> >
> > This looks like an unrelated change.
> 
> I will have a separate patch for this.
> >
> > > +		/* max # of devices per target */
> > > +		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
> > > +		/* max # of targets per channel */
> > > +		host->max_id = STORVSC_FC_MAX_TARGETS;
> > > +		/* max # of channels */
> > > +		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;
> >
> > I don't think these comments add any value..
> 
> I will get rid of the comments.
> 
> >
> > Also any reason you use off by one defines for max_channel, but not
> > the others?
> 
> No particular reason; I will clean this up.

On further examination max_channel is the maximum number of channels including channel 0. Thus the value set for
max_channel is correct. max_id appears to indicate the limit. In scsi_scan_channel the loop control  is (id < max_id) and
hence the value I have here is correct. max_lun is also used like max_id to indicate the limit. In scsi_sequential_lun_scan()
the loop control is (lun < max_dev_lun) and hence I think the value I have here is fine.

Regards,

K. Y 

