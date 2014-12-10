Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaLJWn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:43:58 -0500
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:4145
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933164AbaLJWn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:43:57 -0500
From: Long Li <longli@microsoft.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Topic: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Index: AQHQFEr1l6JEzjzL40qd8o/Vn6giApyJU4P/gAAPgiA=
Date: Wed, 10 Dec 2014 22:28:07 +0000
Message-ID: <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0773;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0773;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51704005)(99396003)(120916001)(97736003)(76576001)(122556002)(107046002)(99286002)(102836002)(110136001)(68736005)(40100003)(105586002)(106356001)(20776003)(106116001)(46102003)(64706001)(86612001)(31966008)(19580405001)(54606007)(4396001)(87936001)(54206007)(76176999)(77156002)(86362001)(50986999)(21056001)(92566001)(101416001)(2656002)(54356999)(33656002)(62966003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0773;H:BL2PR03MB132.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>> "Long" == Long Li <longli@microsoft.com> writes:
> 
> Long> MSFT targets currently claim SPC-2 compliance while they implement
> Long> post SPC-2 features. With this patch we can correctly handle
> Long> WRITE_SAME_16 issues.
> 
> Handle the issues or handle WRITE SAME(10/16)?

With this patch, the SCSI layer will be able to correctly send WRITE_SAME_16 to the Hyper-V host. It will not send WRITE_SAME_10: it has been disabled in the driver template. Do you want me to send another patch with these details?

> 
> +	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},
> 
> Is that version field meaningful or is it safe for us to inquire about VPD pages
> without problems on older versions?

This version is used in all current Hyper-V hosts: Windows 2008 R2, 2012 and 2012 R2. However it may change in future Windows releases.

> 
> --
> Martin K. Petersen	Oracle Linux Engineering
