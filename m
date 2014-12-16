Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaLPCMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:12:23 -0500
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:64702
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751053AbaLPCLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:11:22 -0500
From: Long Li <longli@microsoft.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Topic: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Index: AQHQFbg9l6JEzjzL40qd8o/Vn6giApyRf5nA
Date: Tue, 16 Dec 2014 02:11:17 +0000
Message-ID: <BL2PR03MB1327AFA28FF65067FE4672DCE6C0@BL2PR03MB132.namprd03.prod.outlook.com>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
	<yq1h9x3cipr.fsf@sermon.lab.mkp.net>
	<BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
 <yq1vblhbmcv.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1vblhbmcv.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0707;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0707;
x-forefront-prvs: 04270EF89C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(13464003)(199003)(377454003)(189002)(87936001)(31966008)(110136001)(122556002)(46102003)(93886004)(19580405001)(33656002)(19580395003)(120916001)(74316001)(2656002)(54206007)(64706001)(101416001)(99286002)(40100003)(4396001)(102836002)(76576001)(77156002)(86362001)(97736003)(106116001)(50986999)(99396003)(86612001)(68736005)(20776003)(21056001)(62966003)(54356999)(76176999)(54606007)(105586002)(106356001)(92566001)(107046002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0707;H:BL2PR03MB132.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Martin for the explanation.

I'll send out another patch.

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Thursday, December 11, 2014 7:04 PM
> To: Long Li
> Cc: Martin K. Petersen; KY Srinivasan; Haiyang Zhang;
> JBottomley@parallels.com; linux-scsi@vger.kernel.org;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
> 
> >>>>> "Long" == Long Li <longli@microsoft.com> writes:
> 
> >> Handle the issues or handle WRITE SAME(10/16)?
> 
> Long> With this patch, the SCSI layer will be able to correctly send
> Long> WRITE_SAME_16 to the Hyper-V host. It will not send WRITE_SAME_10:
> Long> it has been disabled in the driver template. Do you want me to
> Long> send another patch with these details?
> 
> no_write_same prevents us from attempting to use WRITE SAME(10/16) to zero
> block ranges.
> 
> This is completely orthogonal to using the WRITE SAME(10/16) commands with
> the UNMAP bit set to discard block ranges. The latter is controlled by the logical
> block provisioning heuristics and is not affected by no_write_same at all.
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
