Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaGJWXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:23:03 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:35420
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751404AbaGJWXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:23:01 -0400
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
Subject: RE: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Thread-Topic: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Thread-Index: AQHPmwbgHQRbrGSDW0yYxe5G8grckJuXbgyAgAClIWCAAQcAgIAAyiKQ
Date: Thu, 10 Jul 2014 22:22:57 +0000
Message-ID: <2e5ae79793bf4e17b05bc5285ca73bda@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
 <20140709084453.GG6012@infradead.org>
 <651b6b11c6d6415cb0046ce03b6b2c63@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140710101713.GC1151@infradead.org>
In-Reply-To: <20140710101713.GC1151@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.160.237]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(24454002)(13464003)(51704005)(199002)(189002)(110136001)(86612001)(19580405001)(85306003)(99286002)(86362001)(81542001)(31966008)(83072002)(21056001)(80022001)(74662001)(101416001)(74502001)(92566001)(106116001)(66066001)(76176999)(76482001)(99396002)(79102001)(19580395003)(83322001)(50986999)(77982001)(74316001)(107046002)(64706001)(54356999)(76576001)(4396001)(85852003)(46102001)(33646001)(87936001)(105586002)(81342001)(93886003)(106356001)(2656002)(20776003)(95666004)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, July 10, 2014 3:17 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; jasowang@redhat.com; apw@canonical.com;
> linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
> 
> On Wed, Jul 09, 2014 at 06:40:09PM +0000, KY Srinivasan wrote:
> > > On Tue, Jul 08, 2014 at 05:46:51PM -0700, K. Y. Srinivasan wrote:
> > > > Correctly set SRB flags for all valid I/O directions. Some IHV
> > > > drivers on the Windows host require this.
> > >
> > > What are IHV drivers?
> >
> > If the target is a SAN device, the host simply passes the request over to the
> native driver stack on the host. Some specific hardware (IHV - independent
> hadware vendor) drivers on Windows require that SRB flags be correctly set
> in all cases.
> >
> 
> I'm fine with putting this in, but treating I/O request from guests as trusted in
> a hypervisor doesn't seem like a good idea in general..

The host does  validate the guest request before forwarding the request to the appropriate target.

K. Y
