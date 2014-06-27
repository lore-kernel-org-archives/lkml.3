Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaF0XUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:20:14 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:28200
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751745AbaF0XUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:20:12 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>
CC: Dexuan Cui <decui@microsoft.com>, Thomas Shao <huishao@microsoft.com>
Subject: RE: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
Thread-Topic: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
Thread-Index: AQHPkl3sCu+G7SXcCkCbF+fIpgaFm5uFl1Eg
Date: Fri, 27 Jun 2014 23:20:10 +0000
Message-ID: <ec1eb9430bac4572a0dad7dc2f9a6332@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1403914608-21604-1-git-send-email-yuezha@microsoft.com>
In-Reply-To: <1403914608-21604-1-git-send-email-yuezha@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(199002)(189002)(13464003)(51704005)(19580405001)(64706001)(83322001)(66066001)(85852003)(83072002)(80022001)(101416001)(76482001)(20776003)(92566001)(19580395003)(77982001)(33646001)(46102001)(76576001)(2656002)(50986999)(87936001)(54356999)(4396001)(81342001)(21056001)(76176999)(106356001)(31966008)(99286002)(95666004)(85306003)(86362001)(2201001)(74316001)(99396002)(105586002)(81542001)(107046002)(106116001)(74662001)(1511001)(79102001)(74502001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Yue Zhang [mailto:yuezha@microsoft.com]
> Sent: Friday, June 27, 2014 5:17 PM
> To: KY Srinivasan; Haiyang Zhang; driverdev-devel@linuxdriverproject.org;
> linux-kernel@vger.kernel.org; olaf@aepfle.de; jasowang@redhat.com;
> apw@canonical.com
> Cc: Dexuan Cui; Thomas Shao
> Subject: [PATCH] Tools: hv: fix file overwriting of hv_fcopy_daemon
> 
> From: Yue Zhang <yuezha@microsoft.com>
> 
> hv_fcopy_daemon fails to overwrite a file if the target file already exits.
> 
> Add O_TRUNC flag on opening.
> 
> MS-TFS: 341345
You need to include Greg in the "to list". Also get rid of the MS-TFS tag.

> 
> Signed-off-by: Yue Zhang <yuezha@microsoft.com>
> ---
>  tools/hv/hv_fcopy_daemon.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
> index fba1c75..2a86297 100644
> --- a/tools/hv/hv_fcopy_daemon.c
> +++ b/tools/hv/hv_fcopy_daemon.c
> @@ -88,7 +88,8 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
>  		}
>  	}
> 
> -	target_fd = open(target_fname, O_RDWR | O_CREAT | O_CLOEXEC,
> 0744);
> +	target_fd = open(target_fname,
> +			O_RDWR | O_CREAT | O_TRUNC | O_CLOEXEC,
> 0744);
Please align properly and there is no need for three lines here.

K. Y
