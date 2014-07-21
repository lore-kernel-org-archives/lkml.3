Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaGUNTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:19:13 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:58308
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754607AbaGUNTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:19:12 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Thread-Topic: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Thread-Index: AQHPpIwNoeZ0nX8rfkqMxEgYWPOEzZuqZEwAgAAeRHA=
Date: Mon, 21 Jul 2014 13:19:08 +0000
Message-ID: <a496b63900874bd396e85a24505e383b@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405913622-14266-1-git-send-email-kys@microsoft.com>
 <20140721112704.GA15455@infradead.org>
In-Reply-To: <20140721112704.GA15455@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0279B3DD0D
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(13464003)(189002)(199002)(51704005)(99286002)(74662001)(80022001)(105586002)(81342001)(66066001)(95666004)(77982001)(74502001)(79102001)(107046002)(101416001)(4396001)(33646002)(99396002)(110136001)(76482001)(106116001)(20776003)(64706001)(21056001)(81542001)(92566001)(83072002)(85852003)(76576001)(46102001)(77096002)(2656002)(87936001)(76176999)(74316001)(54356999)(50986999)(106356001)(19580395003)(83322001)(85306003)(19580405001)(86362001)(31966008)(86612001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, July 21, 2014 4:27 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; hch@infradead.org;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
> 
> On Sun, Jul 20, 2014 at 08:33:42PM -0700, K. Y. Srinivasan wrote:
> > Add blist flags to permit the reading of the VPD pages even when the
> > target may claim SPC-2 compliance. MSFT targets currently claim SPC-2
> > compliance while they implement post SPC-2 features.
> > With this patch we can correctly handle WRITE_SAME_16 issues.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> This looks way to complicated - should be a single line added to your
> slave_configure function, maybe plus a comment stating what you do in your
> commit message:
> 
> 
> 	sdev->sdev_bflags |= BLIST_TRY_VPD_PAGES;

Thanks Christoph. We can go with this. I will re-send the patch.


K. Y
