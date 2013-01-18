Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab3ARQjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:39:06 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.26]:59641
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3ARQjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:39:04 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hashir Abdi <habdi@microsoft.com>
Subject: RE: [PATCH] tools: hv: Use CLOEXEC when opening kvp_pool files
Thread-Topic: [PATCH] tools: hv: Use CLOEXEC when opening kvp_pool files
Thread-Index: AQHN9YeXg2bcyj2BD0K37v0PEW7I4ZhPSKGw
Date: Fri, 18 Jan 2013 16:36:19 +0000
Message-ID: <3314650df3bb455e8e9e1c08119a818d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <20130117194816.GA11884@kroah.com>
 <1358519021-11995-1-git-send-email-thozza@redhat.com>
In-Reply-To: <1358519021-11995-1-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.156.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464002)(377454001)(47776002)(47736001)(77982001)(53806001)(44976002)(74502001)(31966008)(6806001)(51856001)(56816002)(47446002)(79102001)(23726001)(56776001)(54356001)(74662001)(5343655001)(50466001)(16676001)(4396001)(49866001)(50986001)(47976001)(5343635001)(59766001)(54316002)(46102001)(46406002)(76482001)(33646001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB013;H:TK5EX14MLTC104.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0730093765
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Friday, January 18, 2013 9:24 AM
> To: gregkh@linuxfoundation.org
> Cc: KY Srinivasan; jasowang@redhat.com; Haiyang Zhang; linux-
> kernel@vger.kernel.org; Hashir Abdi; Tomas Hozza
> Subject: [PATCH] tools: hv: Use CLOEXEC when opening kvp_pool files
> 
> Use CLOEXEC flag when opening kvp_pool_x files to prevent file
> descriptor leakage. Not using it was causing a problem when
> SELinux was enabled.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_kvp_daemon.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 3840517..c800ea4 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -151,7 +151,7 @@ static void kvp_update_file(int pool)
>  	 */
>  	kvp_acquire_lock(pool);
> 
> -	filep = fopen(kvp_file_info[pool].fname, "w");
> +	filep = fopen(kvp_file_info[pool].fname, "we");
>  	if (!filep) {
>  		kvp_release_lock(pool);
>  		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
> @@ -182,7 +182,7 @@ static void kvp_update_mem_state(int pool)
> 
>  	kvp_acquire_lock(pool);
> 
> -	filep = fopen(kvp_file_info[pool].fname, "r");
> +	filep = fopen(kvp_file_info[pool].fname, "re");
>  	if (!filep) {
>  		kvp_release_lock(pool);
>  		syslog(LOG_ERR, "Failed to open file, pool: %d", pool);
> @@ -246,13 +246,13 @@ static int kvp_file_init(void)
>  		records_read = 0;
>  		num_blocks = 1;
>  		sprintf(fname, "%s/.kvp_pool_%d", KVP_CONFIG_LOC, i);
> -		fd = open(fname, O_RDWR | O_CREAT, 0644 /* rw-r--r-- */);
> +		fd = open(fname, O_RDWR | O_CREAT | O_CLOEXEC, 0644 /* rw-
> r--r-- */);
> 
>  		if (fd == -1)
>  			return 1;
> 
> 
> -		filep = fopen(fname, "r");
> +		filep = fopen(fname, "re");
>  		if (!filep)
>  			return 1;
> 
> --
> 1.7.11.7
> 
> 


