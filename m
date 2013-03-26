Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab3CZSo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:44:58 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:1909
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760142Ab3CZSo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:44:57 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 4
X-BigFish: PS4(zz9371I542I1432I78fbmzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] tools: hv: use FIFREEZE/FITHAW in hv_vss_daemon
Thread-Topic: [PATCH 1/2] tools: hv: use FIFREEZE/FITHAW in hv_vss_daemon
Thread-Index: AQHOKkG2Va+xn/5100m9cn3fzM394Zi4Ta2w
Date: Tue, 26 Mar 2013 18:43:15 +0000
Message-ID: <d5b20c7b60cd48a6a78e541f42493b87@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1364316430-29655-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1364316430-29655-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(377454001)(51704002)(13464002)(5343655001)(80022001)(44976002)(23726001)(5343635001)(6806001)(51856001)(79102001)(31966008)(74662001)(46102001)(46406002)(54356001)(47446002)(74502001)(56816002)(53806001)(66066001)(4396001)(33646001)(16676001)(65816001)(69226001)(50466001)(63696002)(47776003)(47976001)(77982001)(76482001)(47736001)(54316002)(50986001)(56776001)(59766001)(49866001)(20776003)(309714001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB022;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 079756C6B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, March 26, 2013 12:47 PM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH 1/2] tools: hv: use FIFREEZE/FITHAW in hv_vss_daemon
> 
> As suggested by Paolo Bonzini, use ioctl instead of calling fsfreeze.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

Thanks Olaf for taking care of this.

Acked by: K. Y. Srinivasan <kys@microsoft.com>

> ---
> 
> NOT runtime tested!!
> 
>  tools/hv/hv_vss_daemon.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index e37d86c..830d606 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -21,7 +21,9 @@
>  #include <sys/types.h>
>  #include <sys/socket.h>
>  #include <sys/poll.h>
> +#include <sys/ioctl.h>
>  #include <linux/types.h>
> +#include <fcntl.h>
>  #include <stdio.h>
>  #include <mntent.h>
>  #include <stdlib.h>
> @@ -30,6 +32,7 @@
>  #include <ctype.h>
>  #include <errno.h>
>  #include <arpa/inet.h>
> +#include <linux/fs.h>
>  #include <linux/connector.h>
>  #include <linux/hyperv.h>
>  #include <linux/netlink.h>
> @@ -44,21 +47,35 @@ static struct sockaddr_nl addr;
>  #endif
> 
> 
> +static int vss_do_freeze(char *dir, unsigned int cmd, char *fs_op)
> +{
> +	int ret, fd = open(dir, O_RDONLY);
> +
> +	if (fd < 0)
> +		return 1;
> +	ret = ioctl(fd, cmd, 0);
> +	syslog(LOG_INFO, "VSS: %s of %s: %s\n", fs_op, dir, strerror(errno));
> +	close(fd);
> +	return !!ret;
> +}
> +
>  static int vss_operate(int operation)
>  {
>  	char *fs_op;
> -	char cmd[512];
>  	char match[] = "/dev/";
>  	FILE *mounts;
>  	struct mntent *ent;
> +	unsigned int cmd;
>  	int error = 0, root_seen = 0;
> 
>  	switch (operation) {
>  	case VSS_OP_FREEZE:
> -		fs_op = "-f ";
> +		cmd = FIFREEZE;
> +		fs_op = "freeze";
>  		break;
>  	case VSS_OP_THAW:
> -		fs_op = "-u ";
> +		cmd = FITHAW;
> +		fs_op = "thaw";
>  		break;
>  	default:
>  		return -1;
> @@ -75,16 +92,12 @@ static int vss_operate(int operation)
>  			root_seen = 1;
>  			continue;
>  		}
> -		snprintf(cmd, sizeof(cmd), "fsfreeze %s '%s'", fs_op, ent-
> >mnt_dir);
> -		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> -		error |= system(cmd);
> +		error |= vss_do_freeze(ent->mnt_dir, cmd, fs_op);
>  	}
>  	endmntent(mounts);
> 
>  	if (root_seen) {
> -		sprintf(cmd, "fsfreeze %s /", fs_op);
> -		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> -		error |= system(cmd);
> +		error |= vss_do_freeze("/", cmd, fs_op);
>  	}
> 
>  	return error;
> 


