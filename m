Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaFZUnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:43:51 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:28088
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751904AbaFZUns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:43:48 -0400
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
Thread-Index: AQHPkXqZAHj0PqEENkSegLhluqQpVJuD2uTw
Date: Thu, 26 Jun 2014 20:43:46 +0000
Message-ID: <9aa07d3dad7c448da7ee7a3e007e0140@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1403816968-15419-1-git-send-email-yuezha@microsoft.com>
In-Reply-To: <1403816968-15419-1-git-send-email-yuezha@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.147.182]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(51704005)(377454003)(199002)(189002)(74316001)(81342001)(50986999)(95666004)(76176999)(106356001)(107046002)(66066001)(85852003)(81542001)(80022001)(83072002)(105586002)(33646001)(77982001)(54356999)(99286002)(76482001)(76576001)(46102001)(101416001)(19580395003)(31966008)(19580405001)(83322001)(21056001)(86612001)(87936001)(99396002)(64706001)(85306003)(86362001)(74502001)(1511001)(106116001)(20776003)(2201001)(4396001)(74662001)(92566001)(2656002)(79102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Yue Zhang [mailto:yuezha@microsoft.com]
> Sent: Thursday, June 26, 2014 2:09 PM
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
> Signed-off-by: Yue Zhang <yuezha@microsoft.com>
> ---
>  tools/hv/hv_fcopy_daemon.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
> index fba1c75..01eee6b 100644
> --- a/tools/hv/hv_fcopy_daemon.c
> +++ b/tools/hv/hv_fcopy_daemon.c
> @@ -88,7 +88,8 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
>  		}
>  	}
> 
> -	target_fd = open(target_fname, O_RDWR | O_CREAT | O_CLOEXEC,
> 0744);
> +	target_fd = open(target_fname,
> +				O_RDWR | O_CREAT | O_TRUNC |
Please align O_RDWR to align with the first argument (target_fname). 

K. Y

