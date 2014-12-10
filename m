Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbaLJXad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:30:33 -0500
Received: from mail-by2on0129.outbound.protection.outlook.com ([207.46.100.129]:7557
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758230AbaLJXac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:30:32 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Long Li <longli@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Topic: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Index: AQHQFEr2lRl5lG262U+8PhB4FFpJLJyJU4TcgAAVCoCAABEBoA==
Date: Wed, 10 Dec 2014 23:30:30 +0000
Message-ID: <BY2PR0301MB0711CF1C9FBD8EFED89B3911A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
 <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
In-Reply-To: <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(377454003)(13464003)(54206007)(86612001)(102836002)(2421001)(106356001)(46102003)(74316001)(101416001)(76576001)(33656002)(86362001)(21056001)(19580395003)(92566001)(2561002)(31966008)(77156002)(68736005)(62966003)(64706001)(20776003)(40100003)(107046002)(122556002)(87936001)(120916001)(2656002)(4396001)(105586002)(97736003)(76176999)(19580405001)(99286002)(54606007)(1511001)(50986999)(106116001)(99396003)(54356999)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0776;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Long Li
> Sent: Wednesday, December 10, 2014 2:28 PM
> To: Martin K. Petersen
> Cc: KY Srinivasan; Haiyang Zhang; JBottomley@parallels.com; linux-
> scsi@vger.kernel.org; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
> 
> > >>>>> "Long" == Long Li <longli@microsoft.com> writes:
> >
> > Long> MSFT targets currently claim SPC-2 compliance while they
> > Long> implement post SPC-2 features. With this patch we can correctly
> > Long> handle
> > Long> WRITE_SAME_16 issues.
> >
> > Handle the issues or handle WRITE SAME(10/16)?
> 
> With this patch, the SCSI layer will be able to correctly send WRITE_SAME_16
> to the Hyper-V host. It will not send WRITE_SAME_10: it has been disabled in
> the driver template. Do you want me to send another patch with these
> details?
> 
> >
> > +	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},
> >
> > Is that version field meaningful or is it safe for us to inquire about
> > VPD pages without problems on older versions?
> 
> This version is used in all current Hyper-V hosts: Windows 2008 R2, 2012 and
> 2012 R2. However it may change in future Windows releases.

The next version of the host will be claiming conformance to SPC-3

K. Y
> 
> >
> > --
> > Martin K. Petersen	Oracle Linux Engineering
