Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaGIVOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:14:07 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:10196
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750724AbaGIVOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:14:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Topic: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Index: AQHPmwbc2vh72TcerE+9u7O+On3hT5uXbYYAgACybACAAH8bAP//jcAw
Date: Wed, 9 Jul 2014 21:14:00 +0000
Message-ID: <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
	 <1404866812-26950-1-git-send-email-kys@microsoft.com>
	 <1404866812-26950-4-git-send-email-kys@microsoft.com>
	 <20140709084300.GD6012@infradead.org>
	 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(13464003)(377454003)(189002)(199002)(377424004)(51704005)(20776003)(66066001)(46102001)(21056001)(106116001)(99286002)(80022001)(83072002)(77982001)(101416001)(33646001)(74502001)(110136001)(93886003)(86362001)(107046002)(87936001)(85306003)(81542001)(85852003)(4396001)(76176999)(74662001)(19580395003)(81342001)(76576001)(83322001)(31966008)(105586002)(2656002)(64706001)(19580405001)(106356001)(74316001)(54356999)(95666004)(86612001)(79102001)(50986999)(99396002)(76482001)(92566001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Wednesday, July 9, 2014 12:57 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org;
> devel@linuxdriverproject.org; apw@canonical.com; stable@vger.kernel.org;
> linux-scsi@vger.kernel.org; ohering@suse.com; jasowang@redhat.com
> Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> 
> On Wed, 2014-07-09 at 19:52 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > Sent: Wednesday, July 9, 2014 1:43 AM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> > > apw@canonical.com; linux-scsi@vger.kernel.org;
> > > stable@vger.kernel.org
> > > Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter
> > > WRITE_SAME_16
> > >
> > > On Tue, Jul 08, 2014 at 05:46:48PM -0700, K. Y. Srinivasan wrote:
> > > > Host does not handle WRITE_SAME_16; filter this command out. This
> > > > patch is required to handle large devices (greater than 2 TB disks).
> > >
> > > Storvsc already sets the no_write_same flag, where is the command
> > > coming from?
> >
> > In spite of this flag,  I see WRITE_SAME_16 being issued when I format
> > a device bigger than 2 TB; I tried both xfs and ext4. Windows hosts
> > currently do not handle unsupported commands correctly - The
> > information returned is not sufficient to effect recovery in the Linux guest.
> While this may be addressed in future hosts, this patch fixes the problem.
> 
> What Christoph means is that this looks like a bug somewhere in SCSI itself.
> That means we need to find it and kill it, not add workarounds to every driver
> that sets no_write_same ...

James,

I will try to isolate this issue in the SCSI stack. If it is ok with you guys, I would still want to filter WRITE_SAME_16
(as we currently do WRITE_SAME) in our driver since this would address the problem for a large number of
customers on our platform.

Regards,

K. Y

