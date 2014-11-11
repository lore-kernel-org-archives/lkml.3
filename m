Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaKKDXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:23:37 -0500
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:65412
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751758AbaKKDXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:23:36 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] Tools: hv: vssdaemon: skip all filesystems
 mounted readonly
Thread-Topic: [PATCH v2 2/2] Tools: hv: vssdaemon: skip all filesystems
 mounted readonly
Thread-Index: AQHP/QSlqAF5PmcQJ0+JZ74mBTgmqJxav1BA
Date: Tue, 11 Nov 2014 03:08:35 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C6105DFD2A@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
 <1415637422-27880-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415637422-27880-3-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(13464003)(199003)(51704005)(377454003)(86612001)(50466002)(86146001)(46102003)(84676001)(2421001)(1511001)(4396001)(92726001)(92566001)(66066001)(97756001)(64706001)(55846006)(47776003)(20776003)(54356999)(76176999)(50986999)(575784001)(86362001)(87936001)(2656002)(97736003)(33656002)(26826002)(99396003)(21056001)(120916001)(107046002)(77096003)(62966003)(77156002)(46406003)(19580395003)(19580405001)(16796002)(6806004)(31966008)(68736004)(69596002)(44976005)(2561002)(95666004)(106466001)(23726002)(81156004)(106116001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1203;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1203;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1203;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1203;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1171;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov
> Sent: Tuesday, November 11, 2014 0:37 AM
> To: KY Srinivasan; Haiyang Zhang; Greg Kroah-Hartman
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH v2 2/2] Tools: hv: vssdaemon: skip all filesystems mounted
> readonly
> 
> Instead of making a list of exceptions for readonly filesystems
> in addition to iso9660 we already have it is better to skip freeze
> operation for all readonly-mounted filesystems.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/hv/hv_vss_daemon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index ee44f0d..5e63f70 100644
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

Acked-by: Dexuan Cui <decui@microsoft.com>
