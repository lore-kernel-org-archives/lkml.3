Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbaGPR2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:28:18 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:38712
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759365AbaGPR1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:27:05 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
CC: "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to
 reflect the values on the host
Thread-Topic: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to
 reflect the values on the host
Thread-Index: AQHPneiplMkhhkmHV0+QeEPfqDp/tZufGiWAgAAl24CAAAeTgIADsoeA
Date: Wed, 16 Jul 2014 17:26:48 +0000
Message-ID: <e6f205c16ba2414ab5645977ac038e6c@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
 <53C37575.5030808@suse.de> <20140714083047.GB22715@infradead.org>
 <53C39B91.4010000@suse.de>
In-Reply-To: <53C39B91.4010000@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.159.47]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(24454002)(51704005)(13464003)(377454003)(479174003)(199002)(74502001)(106356001)(106116001)(81342001)(86612001)(92566001)(31966008)(74316001)(64706001)(81542001)(101416001)(83072002)(33646002)(76482001)(54356999)(77096002)(74662001)(93886003)(46102001)(105586002)(80022001)(20776003)(83322001)(107046002)(76176999)(99286002)(85306003)(66066001)(79102001)(77982001)(76576001)(21056001)(4396001)(99396002)(19580395003)(85852003)(50986999)(86362001)(95666004)(19580405001)(87936001)(2656002)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, July 14, 2014 1:58 AM
> To: Christoph Hellwig
> Cc: KY Srinivasan; jasowang@redhat.com; apw@canonical.com; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; linux-scsi@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to reflect
> the values on the host
> 
> On 07/14/2014 10:30 AM, Christoph Hellwig wrote:
> > On Mon, Jul 14, 2014 at 08:15:17AM +0200, Hannes Reinecke wrote:
> >> Limiting max_lun to 255 will make the driver to _not_ respond to LUNs
> >> higher than that; ie Well-known LUN won't work here.
> >> Also the SCSI stack will be using REPORT LUNS anyway since you're
> >> advertising SPC-2 compliance. So your driver runs into issues if
> >> Hyper-V would ever return more than 256 LUNs with the REPORT LUN
> >> command or if any of the LUNs has an addressing scheme other than
> >> '0x00'.
> >> I would suggest to raise this to the technical limit (ie the largest
> >> LUN which the _protocol_ supports) and let REPORT LUNS deal with the
> >> actual LUNs.
> >
> > I suspect hypverv doesn't support anything more.  For now I'd be
> > inclined to just put it in ASAP and if your suggestion works out fix
> > it up later, although I'll wait a bit for more review feedback.
> >
> Okay, that's fine by me.

Christoph,

Is this patch-set ready to be checked in. Let me know if you want me to make any
further corrections.

Regards,

K. Y
> 
> Cheers,
> 
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
