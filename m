Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3CZSqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:46:15 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:36344
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754340Ab3CZSqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:46:13 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz9371I148cI542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] tools: hv: skip iso9660 mounts in hv_vss_daemon
Thread-Topic: [PATCH 2/2] tools: hv: skip iso9660 mounts in hv_vss_daemon
Thread-Index: AQHOKkGzZwvB+mpAAECIgBx4A3VDxZi4TyIw
Date: Tue, 26 Mar 2013 18:44:02 +0000
Message-ID: <99c5a18f9c454e7aa16511cdf2767fd2@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1364316430-29655-1-git-send-email-olaf@aepfle.de>
 <1364316430-29655-2-git-send-email-olaf@aepfle.de>
In-Reply-To: <1364316430-29655-2-git-send-email-olaf@aepfle.de>
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
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(377454001)(13464002)(189002)(199002)(52604002)(65816001)(31966008)(79102001)(54356001)(5343655001)(33646001)(53806001)(6806001)(5343635001)(80022001)(54316002)(46406002)(16676001)(59766001)(47446002)(44976002)(56816002)(77982001)(51856001)(74502001)(74662001)(56776001)(23726001)(66066001)(4396001)(47976001)(47736001)(69226001)(50986001)(46102001)(47776003)(76482001)(50466001)(20776003)(49866001)(63696002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB032;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
> Subject: [PATCH 2/2] tools: hv: skip iso9660 mounts in hv_vss_daemon
> 
> freeze does not work for iso9660 filesystems. A ENOSUPP may be catched
> in the freeze case, but the subsequent thaw call would fail and leads to
> a false error.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>

Olaf, thanks for fixing this.

Acked by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_vss_daemon.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index 830d606..f06cd8c 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -88,6 +88,8 @@ static int vss_operate(int operation)
>  	while((ent = getmntent(mounts))) {
>  		if (strncmp(ent->mnt_fsname, match, strlen(match)))
>  			continue;
> +		if (strcmp(ent->mnt_type, "iso9660") == 0)
> +			continue;
>  		if (strcmp(ent->mnt_dir, "/") == 0) {
>  			root_seen = 1;
>  			continue;
> 


