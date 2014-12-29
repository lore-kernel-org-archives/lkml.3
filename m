Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaL2Vcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 16:32:48 -0500
Received: from mail-bl2on0127.outbound.protection.outlook.com ([65.55.169.127]:19968
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752020AbaL2Vcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 16:32:47 -0500
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being continuous
Thread-Topic: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being
 continuous
Thread-Index: AQHQDos/PK3eN3W9k0ulFthqgd8G05ynOqJg
Date: Mon, 29 Dec 2014 21:17:21 +0000
Message-ID: <BY2PR0301MB0711343056E29FB67B18246FA0510@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417568621-23143-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1417568621-23143-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 0440AC9990
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377454003)(199003)(13464003)(189002)(2201001)(92566001)(76176999)(54606007)(21056001)(31966008)(86362001)(87936001)(107046002)(77156002)(102836002)(54356999)(20776003)(4396001)(62966003)(74316001)(2656002)(54206007)(86612001)(105586002)(64706001)(106356001)(101416001)(106116001)(2421001)(46102003)(19580395003)(97736003)(50986999)(2900100001)(2501002)(1511001)(19580405001)(2561002)(68736005)(33656002)(40100003)(66066001)(2950100001)(99396003)(99286002)(122556002)(120916001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2014 21:17:21.8148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0710
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, December 2, 2014 5:04 PM
> To: x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> hpa@zytor.com
> Cc: KY Srinivasan; stable@vger.kernel.org
> Subject: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being continuous
> 
> The clocksource based on Hyper-V per-partition reference count MSR is
> continuous. Mark it accordingly.

Thomas,

If there are no issues, please pickup this patch.

Regards,

K. Y
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/cpu/mshyperv.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c
> b/arch/x86/kernel/cpu/mshyperv.c index a450373..939155f 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -107,6 +107,7 @@ static struct clocksource hyperv_cs = {
>  	.rating		= 400, /* use this when running on Hyperv*/
>  	.read		= read_hv_clock,
>  	.mask		= CLOCKSOURCE_MASK(64),
> +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
> 
>  static void __init ms_hyperv_init_platform(void)
> --
> 1.7.4.1

