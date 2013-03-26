Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab3CZSqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:46:24 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:50909
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932376Ab3CZSqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:46:21 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz9371I148cI542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] tools: hv: use getmntent in hv_vss_daemon
Thread-Topic: [PATCH 3/3] tools: hv: use getmntent in hv_vss_daemon
Thread-Index: AQHOKjbC4kZjGME6K0GQ8C91lyW64Ji4T7BQ
Date: Tue, 26 Mar 2013 18:45:33 +0000
Message-ID: <50c2f431d75c4727a1ac5da0f3dec05c@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
 <1364311709-18228-3-git-send-email-olaf@aepfle.de>
In-Reply-To: <1364311709-18228-3-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(52604002)(51704002)(377454001)(199002)(189002)(13464002)(49866001)(23726001)(50466001)(20776003)(77982001)(50986001)(54356001)(4396001)(5343635001)(47976001)(53806001)(59766001)(54316002)(56776001)(69226001)(66066001)(16676001)(80022001)(5343655001)(56816002)(47736001)(65816001)(76482001)(6806001)(46406002)(33646001)(74662001)(79102001)(31966008)(51856001)(47776003)(47446002)(46102001)(44976002)(74502001)(63696002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB037;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 079756C6B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, March 26, 2013 11:28 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH 3/3] tools: hv: use getmntent in hv_vss_daemon
> 
> As suggested by Paolo Bonzini, use getmntent instead of parsing output
> of mount(1).
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

Thanks for addressing this.

Acked by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_vss_daemon.c | 39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index dc3eb1e..e37d86c 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -23,6 +23,7 @@
>  #include <sys/poll.h>
>  #include <linux/types.h>
>  #include <stdio.h>
> +#include <mntent.h>
>  #include <stdlib.h>
>  #include <unistd.h>
>  #include <string.h>
> @@ -47,11 +48,10 @@ static int vss_operate(int operation)
>  {
>  	char *fs_op;
>  	char cmd[512];
> -	char buf[512];
> -	FILE *file;
> -	char *p;
> -	char *x;
> -	int error = 0;
> +	char match[] = "/dev/";
> +	FILE *mounts;
> +	struct mntent *ent;
> +	int error = 0, root_seen = 0;
> 
>  	switch (operation) {
>  	case VSS_OP_FREEZE:
> @@ -64,25 +64,28 @@ static int vss_operate(int operation)
>  		return -1;
>  	}
> 
> -	file = popen("mount | awk '/^\\/dev\\// { print $3}'", "r");
> -	if (file == NULL)
> +	mounts = setmntent("/proc/mounts", "r");
> +	if (mounts == NULL)
>  		return -1;
> 
> -	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
> -		x = strchr(p, '\n');
> -		*x = '\0';
> -		if (!strncmp(p, "/", sizeof("/")))
> +	while((ent = getmntent(mounts))) {
> +		if (strncmp(ent->mnt_fsname, match, strlen(match)))
>  			continue;
> -
> -		sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, p);
> +		if (strcmp(ent->mnt_dir, "/") == 0) {
> +			root_seen = 1;
> +			continue;
> +		}
> +		snprintf(cmd, sizeof(cmd), "fsfreeze %s '%s'", fs_op, ent-
> >mnt_dir);
>  		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> -		error = system(cmd);
> +		error |= system(cmd);
>  	}
> -	pclose(file);
> +	endmntent(mounts);
> 
> -	sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, "/");
> -	syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> -	error = system(cmd);
> +	if (root_seen) {
> +		sprintf(cmd, "fsfreeze %s /", fs_op);
> +		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> +		error |= system(cmd);
> +	}
> 
>  	return error;
>  }
> 


