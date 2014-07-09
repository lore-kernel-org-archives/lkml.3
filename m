Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaGIWgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:36:32 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:58652
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751235AbaGIWga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:36:30 -0400
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mkp@mkp.net" <mkp@mkp.net>, "hch@infradead.org" <hch@infradead.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Topic: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Thread-Index: AQHPmwbc2vh72TcerE+9u7O+On3hT5uXbYYAgACybACAAH8bAP//jcAwgACcZoD//4snYA==
Date: Wed, 9 Jul 2014 22:36:26 +0000
Message-ID: <de81772c7f0c418ba6180ee634ca3ff7@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
	 <1404866812-26950-1-git-send-email-kys@microsoft.com>
	 <1404866812-26950-4-git-send-email-kys@microsoft.com>
	 <20140709084300.GD6012@infradead.org>
	 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
	 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
	 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:bcf5:5a77:a2be:83f5]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0267E514F9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(377454003)(377424004)(189002)(164054003)(199002)(51704005)(13464003)(85852003)(20776003)(81542001)(81342001)(95666004)(76482001)(105586002)(74316001)(21056001)(85306003)(74502001)(86612001)(77982001)(110136001)(33646001)(79102001)(107046002)(86362001)(76576001)(74662001)(106356001)(83072002)(87936001)(76176999)(54356999)(80022001)(101416001)(93886003)(64706001)(106116001)(4396001)(19580395003)(2656002)(99286002)(92566001)(99396002)(50986999)(31966008)(46102001)(19580405001)(83322001)(108616002)(24736002)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Wednesday, July 9, 2014 3:27 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; mkp@mkp.net; hch@infradead.org;
> devel@linuxdriverproject.org; apw@canonical.com; stable@vger.kernel.org;
> linux-scsi@vger.kernel.org; ohering@suse.com; jasowang@redhat.com
> Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> 
> On Wed, 2014-07-09 at 21:14 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: James Bottomley [mailto:jbottomley@parallels.com]
> > > Sent: Wednesday, July 9, 2014 12:57 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; hch@infradead.org;
> > > devel@linuxdriverproject.org; apw@canonical.com;
> > > stable@vger.kernel.org; linux-scsi@vger.kernel.org;
> > > ohering@suse.com; jasowang@redhat.com
> > > Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter
> > > WRITE_SAME_16
> > >
> > > On Wed, 2014-07-09 at 19:52 +0000, KY Srinivasan wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Christoph Hellwig [mailto:hch@infradead.org]
> > > > > Sent: Wednesday, July 9, 2014 1:43 AM
> > > > > To: KY Srinivasan
> > > > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > > > ohering@suse.com; jbottomley@parallels.com;
> jasowang@redhat.com;
> > > > > apw@canonical.com; linux-scsi@vger.kernel.org;
> > > > > stable@vger.kernel.org
> > > > > Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter
> > > > > WRITE_SAME_16
> > > > >
> > > > > On Tue, Jul 08, 2014 at 05:46:48PM -0700, K. Y. Srinivasan wrote:
> > > > > > Host does not handle WRITE_SAME_16; filter this command out.
> > > > > > This patch is required to handle large devices (greater than 2 TB
> disks).
> > > > >
> > > > > Storvsc already sets the no_write_same flag, where is the
> > > > > command coming from?
> > > >
> > > > In spite of this flag,  I see WRITE_SAME_16 being issued when I
> > > > format a device bigger than 2 TB; I tried both xfs and ext4.
> > > > Windows hosts currently do not handle unsupported commands
> > > > correctly - The information returned is not sufficient to effect recovery
> in the Linux guest.
> > > While this may be addressed in future hosts, this patch fixes the problem.
> > >
> > > What Christoph means is that this looks like a bug somewhere in SCSI
> itself.
> > > That means we need to find it and kill it, not add workarounds to
> > > every driver that sets no_write_same ...
> >
> > James,
> >
> > I will try to isolate this issue in the SCSI stack. If it is ok with
> > you guys, I would still want to filter WRITE_SAME_16 (as we currently
> > do WRITE_SAME) in our driver since this would address the problem for a
> large number of customers on our platform.
> 
> If we fix it at source, why would there be any need to filter?  That's the
> reason the no_write_same flag was introduced.  If we can find and fix the
> bug, it can go back into the stable trees as a bug fix, hence nothing should
> ever emit write_same(10 or 16) and additional driver code is redundant (and
> counter productive, since if this ever breaks again you're our best canary).
> 
> This looks like it might be the problem but Martin should confirm (I think the
> problem comes to us from the RC16 code which unconditionally sets WS16).

Ok; I am concerned about older kernels that do not have no_write_same flag.
I suppose I can work directly with these Distros and give them a choice: either implement
the no_write_same flag or filter the command in our driver. I will not include this patch when
I resubmit this patch-set.

Thanks,

K. Y
