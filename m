Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbaKSXBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:01:37 -0500
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:36704
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756666AbaKSXBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:01:36 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH v2 2/2] Tools: hv: vssdaemon: skip all filesystems mounted
 readonly
Thread-Topic: [PATCH v2 2/2] Tools: hv: vssdaemon: skip all filesystems
 mounted readonly
Thread-Index: AQHP/QSX+IorxTsbC0GR3F3ejpHwb5xon3hA
Date: Wed, 19 Nov 2014 23:01:30 +0000
Message-ID: <BN1PR0301MB0707B091F2A7185F3E7E616DA0890@BN1PR0301MB0707.namprd03.prod.outlook.com>
References: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
 <1415637422-27880-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415637422-27880-3-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0706;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0706;
x-forefront-prvs: 04004D94E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377454003)(13464003)(199003)(189002)(86362001)(19580395003)(575784001)(19580405001)(97736003)(92566001)(92726001)(1511001)(21056001)(20776003)(86612001)(64706001)(122556002)(120916001)(2561002)(99396003)(101416001)(87936001)(33656002)(2656002)(95666004)(99286002)(105586002)(106116001)(76576001)(107046002)(106356001)(77156002)(77096003)(62966003)(40100003)(31966008)(2421001)(4396001)(76176999)(54206007)(74316001)(50986999)(54606007)(54356999)(46102003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0706;H:BN1PR0301MB0707.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0644;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Monday, November 10, 2014 8:37 AM
> To: KY Srinivasan; Haiyang Zhang; Greg Kroah-Hartman
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH v2 2/2] Tools: hv: vssdaemon: skip all filesystems mounted
> readonly
> 
> Instead of making a list of exceptions for readonly filesystems in addition to
> iso9660 we already have it is better to skip freeze operation for all readonly-
> mounted filesystems.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_vss_daemon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c index
> ee44f0d..5e63f70 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -102,7 +102,7 @@ static int vss_operate(int operation)
>  	while ((ent = getmntent(mounts))) {
>  		if (strncmp(ent->mnt_fsname, match, strlen(match)))
>  			continue;
> -		if (strcmp(ent->mnt_type, "iso9660") == 0)
> +		if (hasmntopt(ent, MNTOPT_RO) != NULL)
>  			continue;
>  		if (strcmp(ent->mnt_type, "vfat") == 0)
>  			continue;
> --
> 1.9.3

