Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaL3T2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:28:30 -0500
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:57176
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbaL3T22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:28:28 -0500
From: Long Li <longli@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 4/4] Drivers: scsi: storvsc: Force SPC-3 compliance on
 win8 and win8 r2 hosts
Thread-Topic: [PATCH 4/4] Drivers: scsi: storvsc: Force SPC-3 compliance on
 win8 and win8 r2 hosts
Thread-Index: AQHQGWx3OTsjV6b81Uqc4oT40FBSb5yompfg
Date: Tue, 30 Dec 2014 19:28:26 +0000
Message-ID: <BLUPR03MB407AC20093909377CDA6A4ECE5E0@BLUPR03MB407.namprd03.prod.outlook.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-4-git-send-email-kys@microsoft.com>
In-Reply-To: <1418764905-11250-4-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.22.8.192]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0705;
x-forefront-prvs: 04410E544A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(51704005)(199003)(189002)(13464003)(31966008)(74316001)(64706001)(77156002)(105586002)(68736005)(77096005)(102836002)(15975445007)(1720100001)(54206007)(62966003)(66066001)(33656002)(2900100001)(2950100001)(20776003)(50986999)(54606007)(92566001)(1511001)(54356999)(76176999)(86612001)(107886001)(122556002)(40100003)(19580405001)(106356001)(107046002)(19580395003)(76576001)(101416001)(21056001)(2421001)(46102003)(97736003)(87936001)(106116001)(4396001)(2201001)(2501002)(99286002)(120916001)(86362001)(99396003)(2656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0705;H:BLUPR03MB407.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2014 19:28:26.1083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0705
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of K. Y. Srinivasan
> Sent: Tuesday, December 16, 2014 1:22 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: [PATCH 4/4] Drivers: scsi: storvsc: Force SPC-3 compliance on win8
> and win8 r2 hosts
> 
> On win8 and win8 r2 hosts force SPC-3 compliance for MSFT virtual disks.
> Ubuntu has been carrying a similar patch outside the tree for a while now.
> Starting with win10, the host will support SPC-3 compliance. Based on all the
> testing that has been done on win8 and win8 r2 hosts, we are comfortable
> claiming SPC-3 compliance on these hosts as well. This will enable TRIM
> support on these hosts.
> 
> Suggested by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> fdc5164..7487e07 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1468,6 +1468,19 @@ static int storvsc_device_configure(struct
> scsi_device *sdevice)
>  	 */
>  	sdevice->sdev_bflags |= msft_blist_flags;
> 
> +	/*
> +	 * If the host is WIN8 or WIN8 R2, claim conformance to SPC-3
> +	 * if the device is a MSFT virtual device.
> +	 */
> +	if (!strncmp(sdevice->vendor, "Msft", 4)) {
> +		switch (vmbus_proto_version) {
> +		case VERSION_WIN8:
> +		case VERSION_WIN8_1:
> +			sdevice->scsi_level = SCSI_SPC_3;
> +			break;
> +		}
> +	}
> +
>  	return 0;
>  }
> 
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
