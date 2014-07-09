Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaGIUHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:07:30 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:29614
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753923AbaGIUH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:07:28 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect
 the values on the host
Thread-Topic: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect
 the values on the host
Thread-Index: AQHPmwbkhR2ZqN76CEKfQBmR/e5a65uXbKgAgAC+28A=
Date: Wed, 9 Jul 2014 20:07:25 +0000
Message-ID: <e5e366a15a9f4a6fa1817b0f3b25a482@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <20140709083954.GA6012@infradead.org>
In-Reply-To: <20140709083954.GA6012@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(377454003)(189002)(199002)(51704005)(13464003)(85306003)(85852003)(81542001)(20776003)(105586002)(76482001)(95666004)(81342001)(86612001)(74316001)(74502001)(66066001)(21056001)(110136001)(77982001)(33646001)(107046002)(79102001)(86362001)(74662001)(76576001)(83072002)(106356001)(87936001)(76176999)(54356999)(80022001)(101416001)(64706001)(106116001)(4396001)(19580395003)(2656002)(99286002)(92566001)(50986999)(99396002)(31966008)(46102001)(19580405001)(83322001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:40 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect the
> values on the host
> 
> On Tue, Jul 08, 2014 at 05:46:45PM -0700, K. Y. Srinivasan wrote:
> > + * In Hyper-V, each port/path/target maps to 1 scsi host adapter.
> 
> Does it still?  The STORVSC_FC_MAX_TARGETS define suggests otherwise.

I will fix the comments and get rid of unnecessary comments.

> 
> > -	.cmd_per_lun =		1,
> > +	.cmd_per_lun =		255,
> 
> This looks like an unrelated change.

I will have a separate patch for this.
> 
> > +		/* max # of devices per target */
> > +		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
> > +		/* max # of targets per channel */
> > +		host->max_id = STORVSC_FC_MAX_TARGETS;
> > +		/* max # of channels */
> > +		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;
> 
> I don't think these comments add any value..

I will get rid of the comments.

> 
> Also any reason you use off by one defines for max_channel, but not the
> others?

No particular reason; I will clean this up.


Thanks Christoph for the detailed comments. I will re-spin these after I address your comments.

Regards,

K. Y
