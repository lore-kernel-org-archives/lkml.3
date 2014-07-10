Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaGJWI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:08:28 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:20637
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753150AbaGJWI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:08:26 -0400
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
Subject: RE: [PATCH V2 2/8] Drivers: scsi: storvsc: Set cmd_per_lun to reflect
 value supported by the Host
Thread-Topic: [PATCH V2 2/8] Drivers: scsi: storvsc: Set cmd_per_lun to
 reflect value supported by the Host
Thread-Index: AQHPnASgeQMjhIt900CfLHpji+o+dZuZGluAgADC5iA=
Date: Thu, 10 Jul 2014 22:08:23 +0000
Message-ID: <29c69dee7c6e4462a7d2913ae2b0b522@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404974008-4984-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-2-git-send-email-kys@microsoft.com>
 <20140710102457.GA31692@infradead.org>
In-Reply-To: <20140710102457.GA31692@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.160.237]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(13464003)(377454003)(74316001)(54356999)(95666004)(50986999)(80022001)(99396002)(106356001)(83322001)(105586002)(19580405001)(76576001)(106116001)(76482001)(83072002)(92566001)(86612001)(46102001)(79102001)(21056001)(101416001)(66066001)(74502001)(33646001)(20776003)(81542001)(74662001)(4396001)(81342001)(64706001)(31966008)(2656002)(99286002)(19580395003)(76176999)(107046002)(110136001)(86362001)(87936001)(85852003)(93886003)(85306003)(77982001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, July 10, 2014 3:25 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org;
> jasowang@redhat.com; apw@canonical.com; linux-scsi@vger.kernel.org;
> stable@vger.kernel.org
> Subject: Re: [PATCH V2 2/8] Drivers: scsi: storvsc: Set cmd_per_lun to reflect
> value supported by the Host
> 
> > -	.cmd_per_lun =		1,
> > +	.cmd_per_lun =		255,
> >  	.can_queue =
> 	STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
> 
> slave_configure immediately adjusts this down to
> STORVSC_MAX_IO_REQUESTS (250), any reson to start out with the magic
> 255 here?

The number 255 (set for cmd_per_lun) is what the host can support (I recently discovered this in an MSDN document). STORVSC_MAX_IO_REQUESTS is an implementation limitation in this driver.

Regards,

K. Y
