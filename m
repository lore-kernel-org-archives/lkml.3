Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab3AJU0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:26:05 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.31]:38311
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3AJU0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:26:03 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Tomas Hozza <thozza@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hashir Abdi <habdi@microsoft.com>
Subject: RE: [PATCH 2/2] tools: hv: Use CLOEXEC when opening kvp_pool files
Thread-Topic: [PATCH 2/2] tools: hv: Use CLOEXEC when opening kvp_pool files
Thread-Index: AQHN7ZM03nrGs9xRR0qS3QXnXcdOT5hDBKyg
Date: Thu, 10 Jan 2013 20:20:41 +0000
Message-ID: <47732095346849909afa68e98cb91d51@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1357644403-11140-1-git-send-email-thozza@redhat.com>
 <1357644403-11140-2-git-send-email-thozza@redhat.com>
In-Reply-To: <1357644403-11140-2-git-send-email-thozza@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.156.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BL2PRD0310HT005.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(377454001)(51704002)(47446002)(56776001)(23726001)(46102001)(79102001)(33646001)(4396001)(74502001)(31966008)(54356001)(50466001)(76482001)(59766001)(77982001)(6806001)(5343635001)(47776002)(53806001)(74662001)(49866001)(47736001)(54316002)(56816002)(16676001)(44976002)(50986001)(5343655001)(46406002)(51856001)(47976001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB019;H:TK5EX14MLTC101.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0722981D2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Hozza [mailto:thozza@redhat.com]
> Sent: Tuesday, January 08, 2013 6:27 AM
> To: gregkh@linuxfoundation.org
> Cc: KY Srinivasan; jasowang@redhat.com; Haiyang Zhang; linux-
> kernel@vger.kernel.org; Hashir Abdi; Tomas Hozza
> Subject: [PATCH 2/2] tools: hv: Use CLOEXEC when opening kvp_pool files
> 
> Use CLOEXEC flag when opening kvp_pool_x files to prevent file
> descriptor leakage. Not using it was causing a problem when
> SELinux was enabled.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
Acked-by: K. Y. Srinivasan <kys@microsoft.com

> ---
>  tools/hv/hv_kvp_daemon.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 6b56b75..31f839cc 100644
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
>  		sprintf(fname, "/var/opt/hyperv/.kvp_pool_%d", i);
> -		fd = open(fname, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR |
> S_IROTH);
> +		fd = open(fname, O_RDWR | O_CREAT | O_CLOEXEC, S_IRUSR |
> S_IWUSR | S_IROTH);
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


