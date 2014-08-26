Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaHZWy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:54:57 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:59748
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754972AbaHZWy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:54:56 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "hare@suse.de" <hare@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Thread-Topic: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Thread-Index: AQHPub/3ru/V8HVQikSS8hrqZWq1G5vYOcGAgAtT+GA=
Date: Tue, 26 Aug 2014 22:54:51 +0000
Message-ID: <c5da85b38a2a4b26b9a7a7fadc40bcc2@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-2-git-send-email-kys@microsoft.com>
 <20140819175431.GA4617@infradead.org>
In-Reply-To: <20140819175431.GA4617@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e8:ed31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03152A99FF
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(199003)(189002)(377454003)(24454002)(51704005)(54094003)(19580395003)(21056001)(83322001)(19580405001)(101416001)(99396002)(76176999)(81342001)(76576001)(74316001)(85852003)(87936001)(83072002)(86362001)(95666004)(106356001)(33646002)(105586002)(64706001)(20776003)(99286002)(106116001)(92566001)(74662001)(31966008)(74502001)(76482001)(85306004)(108616004)(90102001)(77982001)(80022001)(93886004)(77096002)(50986999)(107046002)(110136001)(79102001)(46102001)(4396001)(81542001)(2656002)(54356999)(86612001)(3826002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, August 19, 2014 10:55 AM
> To: KY Srinivasan
> Cc: hare@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; linux-scsi@vger.kernel.org; Martin K. Petersen
> Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
> may have been removed.
> 
> On Sat, Aug 16, 2014 at 08:09:48PM -0700, K. Y. Srinivasan wrote:
> > The host asks the guest to scan when a LUN is removed or added.
> > The only way a guest can identify the removed LUN is when an I/O is
> > attempted on a removed LUN - the SRB status code indicates that the
> > LUN is invalid. We currently handle this SRB status and remove the device.
> >
> > Rather than waiting for an I/O to remove the device, force the
> > discovery of LUNs that may have been removed prior to discovering LUNs
> > that may have been added.
> 
> This looks pretty reasonable to me, but I wonder if we should move this up
> to common code so that it happens for any host rescan triggered by sysfs or
> other drivers as well.
Ping. Any decision on if/when this patch may be checked in.

Regards,

K. Y

