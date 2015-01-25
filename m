Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbbAYSWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:22:52 -0500
Received: from mail-by2on0123.outbound.protection.outlook.com ([207.46.100.123]:49376
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755756AbbAYSWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:22:49 -0500
X-Greylist: delayed 893 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2015 13:22:49 EST
From: KY Srinivasan <kys@microsoft.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Haiyang Zhang <haiyangz@microsoft.com>, Jiri Kosina <jkosina@suse.cz>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3 v2] hyperv: hid-hyperv.c: match
 wait_for_completion_timeout return type
Thread-Topic: [PATCH 3/3 v2] hyperv: hid-hyperv.c: match
 wait_for_completion_timeout return type
Thread-Index: AQHQOK78pesA0zj0PEGzmebwQYJEiZzRIMnQ
Date: Sun, 25 Jan 2015 18:07:53 +0000
Message-ID: <BY2PR0301MB07116F48FBCAC922CD8A33E3A0340@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1422197267-8001-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1422197267-8001-1-git-send-email-der.herr@hofr.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:548:a62e:74ba:769d]
authentication-results: hofr.at; dkim=none (message not signed)
 header.d=none;hofr.at; dmarc=none action=none header.from=microsoft.com;
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0773;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0773;
x-forefront-prvs: 046753C63C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(51704005)(377454003)(46102003)(54206007)(62966003)(54606007)(76576001)(106116001)(19580405001)(76176999)(50986999)(54356999)(19580395003)(74316001)(99286002)(86362001)(87936001)(110136001)(92566002)(102836002)(33656002)(2656002)(77156002)(2950100001)(2900100001)(122556002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0773;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2015 18:07:53.8863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0773
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Nicholas Mc Guire [mailto:der.herr@hofr.at]
> Sent: Sunday, January 25, 2015 6:48 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; Jiri Kosina; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; Nicholas Mc Guire
> Subject: [PATCH 3/3 v2] hyperv: hid-hyperv.c: match
> wait_for_completion_timeout return type
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Thank you.
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
> 
> v2: fixed subject line
> 
> The return type of wait_for_completion_timeout is unsigned long not int.
> This patch fixes up the declarations only.
> 
> Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
> CONFIG_HYPERV=m, CONFIG_HID_HYPERV_MOUSE=m
> 
> Patch is against 3.19.0-rc5 -next-20150123
> 
>  drivers/hid/hid-hyperv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c index
> 31fad64..6039f07 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -381,7 +381,7 @@ static void mousevsc_on_channel_callback(void
> *context)  static int mousevsc_connect_to_vsp(struct hv_device *device)  {
>  	int ret = 0;
> -	int t;
> +	unsigned long t;
>  	struct mousevsc_dev *input_dev = hv_get_drvdata(device);
>  	struct mousevsc_prt_msg *request;
>  	struct mousevsc_prt_msg *response;
> --
> 1.7.10.4

