Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3ARRbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:31:42 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.30]:23641
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab3ARRbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:31:41 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH 1/1] Drivers: hv: Bind all vmbbus interrupts to the boot
 CPU
Thread-Topic: [PATCH 1/1] Drivers: hv: Bind all vmbbus interrupts to the
 boot CPU
Thread-Index: AQHN9TUkm+scpn/SoEOWeidLYzPcqJhPVKJw
Date: Fri, 18 Jan 2013 17:27:09 +0000
Message-ID: <cf0b89ceb5d34a598c500b6bbbcd5e8e@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358485251-13801-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1358485251-13801-1-git-send-email-kys@microsoft.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(51704002)(377454001)(1511001)(47736001)(47776002)(16676001)(51856001)(74662001)(31966008)(44976002)(49866001)(50466001)(4396001)(47976001)(50986001)(6806001)(77982001)(59766001)(56816002)(56776001)(5343635001)(46406002)(74502001)(33646001)(76482001)(23726001)(46102001)(54316002)(79102001)(54356001)(53806001)(47446002)(24736002)(550254004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB019;H:TK5EX14MLTC102.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0730093765
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Friday, January 18, 2013 12:01 AM
> To: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de
> Cc: KY Srinivasan
> Subject: [PATCH 1/1] Drivers: hv: Bind all vmbbus interrupts to the boot CPU
> 
> The default interrupt delivery model in Linux does not support the Hyper-V
> vmbus delivery model when the guest is configured with multiple VCPUs. I have
> sent a patch to address this - delivering the vmbus interrupt on a separate
> IDT vector. Until this patch is applied, bind all vmbus interrupts to the boot
> CPU.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/channel_mgmt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index c80fe62..7478ef9 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -337,7 +337,7 @@ static u32 get_vp_index(uuid_le *type_guid)
>  		return 0;
>  	}
>  	cur_cpu = (++next_vp % max_cpus);
> -	return hv_context.vp_index[cur_cpu];
> +	return 0;
>  }

Greg,

Please apply this patch. This temporary restriction will be removed once the Hyper-V IDT
Patch (or some variant of that) is applied. 

Regards,

K. Y
> 
>  /*
> --
> 1.7.4.1
> 
> 


