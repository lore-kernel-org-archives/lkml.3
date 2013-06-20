Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab3FTR1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:27:21 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:26709
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758006Ab3FTR1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:27:20 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] drivers: hv: check interrupt mask before read_index
Thread-Topic: [PATCH] drivers: hv: check interrupt mask before read_index
Thread-Index: AQHObXR0dwcHKgYqJ0un5Tv8CsHte5k+2dhg
Date: Thu, 20 Jun 2013 17:25:13 +0000
Message-ID: <76e017c2579443f39c5fe5f2bdd169b7@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1371704337-46108-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1371704337-46108-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464003)(189002)(51704005)(199002)(377454003)(77982001)(6806003)(66066001)(49866001)(4396001)(81342001)(56776001)(47976001)(54316002)(46102001)(56816003)(76796001)(59766001)(76482001)(76786001)(54356001)(47446002)(50466002)(77096001)(47736001)(74316001)(16676001)(74502001)(74662001)(33646001)(31966008)(69226001)(63696002)(46406003)(81542001)(50986001)(53806001)(20776003)(74366001)(47776003)(65816001)(74876001)(76576001)(79102001)(80022001)(51856001)(74706001)(23726002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB005;H:TK5EX14MLTC103.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 08831F51DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Thursday, June 20, 2013 12:59 AM
> To: KY Srinivasan; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> gregkh@linuxfoundation.org
> Cc: Haiyang Zhang; Jason Wang
> Subject: [PATCH] drivers: hv: check interrupt mask before read_index
> 
> This patches add a read barriers to force the driver to check the interrupt mask
> before read_index. Otherwise we may lost a kick to host.
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by:  K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/ring_buffer.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 791f45d..26c93cf 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -75,6 +75,8 @@ static bool hv_need_to_signal(u32 old_write, struct
> hv_ring_buffer_info *rbi)
>  	if (rbi->ring_buffer->interrupt_mask)
>  		return false;
> 
> +	/* check interrupt_mask before read_index */
> +	rmb();
>  	/*
>  	 * This is the only case we need to signal when the
>  	 * ring transitions from being empty to non-empty.
> --
> 1.7.1
> 
> 


