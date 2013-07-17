Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3GQLlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:41:20 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:41922
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753055Ab3GQLlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:41:18 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz97hz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(13464003)(377454003)(199002)(189002)(51704005)(74316001)(76576001)(47446002)(65816001)(51856001)(54356001)(49866001)(69226001)(79102001)(76482001)(1511001)(16406001)(74876001)(80022001)(46102001)(76786001)(81342001)(63696002)(66066001)(59766001)(4396001)(54316002)(74662001)(74366001)(53806001)(77096001)(76796001)(74502001)(33646001)(74706001)(77982001)(47736001)(81542001)(47976001)(50986001)(56776001)(83072001)(31966008)(56816003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:24.56.202.201;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net] hyperv: Fix the NETIF_F_SG flag setting in netvsc
Thread-Topic: [PATCH net] hyperv: Fix the NETIF_F_SG flag setting in netvsc
Thread-Index: AQHOgq3/g80VvJUxGk2RPzGZpz22UJlovy4Q
Date: Wed, 17 Jul 2013 11:40:41 +0000
Message-ID: <8906250c5dfc4f7ab0d84019bf7b9a44@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1374040880-20468-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1374040880-20468-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.56.202.201]
x-forefront-prvs: 0910AAF391
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DAVEMLOFT.NET$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(13464003)(51704005)(189002)(377454003)(6806004)(83072001)(47736001)(33646001)(81542001)(49866001)(59766001)(50986001)(47976001)(44976005)(46102001)(76482001)(31966008)(4396001)(56776001)(74366001)(16676001)(66066001)(79102001)(81342001)(54356001)(76576001)(47446002)(54316002)(50466002)(51856001)(74706001)(53806001)(74502001)(23726002)(74662001)(74876001)(46406003)(20776003)(74316001)(69226001)(63696002)(77096001)(76796001)(76786001)(65816001)(80022001)(77982001)(56816003)(47776003)(1511001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB001;H:TK5EX14HUBC101.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0910AAF391
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
> Sent: Wednesday, July 17, 2013 2:01 AM
> To: davem@davemloft.net; netdev@vger.kernel.org
> Cc: Haiyang Zhang; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: [PATCH net] hyperv: Fix the NETIF_F_SG flag setting in netvsc
> 
> SG mode is not currently supported by netvsc, so remove this flag for now.
> Otherwise, it will be unconditionally enabled by commit ec5f0615642
>     "Kill link between CSUM and SG features"
> Previously, the SG feature is disabled because CSUM is not set here.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

We would need to apply this patch to 3.9 and 3.10 as well that are currently broken.

K. Y
> ---
>  drivers/net/hyperv/netvsc_drv.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 4dccead..23a0fff 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -431,8 +431,8 @@ static int netvsc_probe(struct hv_device *dev,
>  	net->netdev_ops = &device_ops;
> 
>  	/* TODO: Add GSO and Checksum offload */
> -	net->hw_features = NETIF_F_SG;
> -	net->features = NETIF_F_SG | NETIF_F_HW_VLAN_CTAG_TX;
> +	net->hw_features = 0;
> +	net->features = NETIF_F_HW_VLAN_CTAG_TX;
> 
>  	SET_ETHTOOL_OPS(net, &ethtool_ops);
>  	SET_NETDEV_DEV(net, &dev->device);
> --
> 1.7.4.1
> 
> 


