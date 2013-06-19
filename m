Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3FSNGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:06:13 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:15068
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933869Ab3FSNGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:06:11 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hz97hz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH] drivers: hv: allocate synic structures before
 hv_synic_init()
Thread-Topic: [PATCH] drivers: hv: allocate synic structures before
 hv_synic_init()
Thread-Index: AQHObJ6lk0OIBHq55kCluOhup+Ttp5k9AcMA
Date: Wed, 19 Jun 2013 13:05:12 +0000
Message-ID: <3ac66c37a2514eebad75aa406cba49a9@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1371612490-28748-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1371612490-28748-1-git-send-email-jasowang@redhat.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704005)(199002)(189002)(13464003)(377454003)(46406003)(56816003)(65816001)(54356001)(74662001)(46102001)(81342001)(16676001)(66066001)(74366001)(74502001)(74316001)(79102001)(23726002)(50466002)(51856001)(77982001)(54316002)(53806001)(31966008)(76482001)(6806003)(77096001)(59766001)(44976003)(74876001)(47776003)(33646001)(20776003)(74706001)(69226001)(4396001)(80022001)(81542001)(49866001)(47976001)(76796001)(76576001)(56776001)(1511001)(76786001)(63696002)(47736001)(47446002)(50986001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB028;H:TK5EX14MLTC103.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 08828D20BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Tuesday, June 18, 2013 11:28 PM
> To: KY Srinivasan; Haiyang Zhang; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; gregkh@linuxfoundation.org
> Cc: Jason Wang
> Subject: [PATCH] drivers: hv: allocate synic structures before hv_synic_init()
> 
> We currently allocate synic structures in hv_sync_init(), but there's no way for
> the driver to know about the allocation failure and it may continue to use the
> uninitialized pointers. Solve this by introducing helpers for allocating and
> freeing and doing the allocation before the on_each_cpu() call in
> vmbus_bus_init().
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/hv/hv.c           |   85 ++++++++++++++++++++++++++++-----------------
>  drivers/hv/hyperv_vmbus.h |    4 ++
>  drivers/hv/vmbus_drv.c    |    8 +++-
>  3 files changed, 63 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index 3f88681..0039373 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -265,6 +265,59 @@ u16 hv_signal_event(void *con_id)
>  	return status;
>  }
> 
> +
> +int hv_synic_alloc(void)
> +{
> +	size_t size = sizeof(struct tasklet_struct);
> +	int cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		hv_context.event_dpc[cpu] = kmalloc(size, GFP_ATOMIC);
> +		if (hv_context.event_dpc[cpu] == NULL) {
> +			pr_err("Unable to allocate event dpc\n");
> +			goto err;
> +		}
> +		tasklet_init(hv_context.event_dpc[cpu], vmbus_on_event, cpu);
> +
> +		hv_context.synic_message_page[cpu] =
> +			(void *)get_zeroed_page(GFP_ATOMIC);
> +
> +		if (hv_context.synic_message_page[cpu] == NULL) {
> +			pr_err("Unable to allocate SYNIC message page\n");
> +			goto err;
> +		}
> +
> +		hv_context.synic_event_page[cpu] =
> +			(void *)get_zeroed_page(GFP_ATOMIC);
> +
> +		if (hv_context.synic_event_page[cpu] == NULL) {
> +			pr_err("Unable to allocate SYNIC event page\n");
> +			goto err;
> +		}
> +	}
> +
> +	return 0;
> +err:
> +	return -ENOMEM;
> +}
> +
> +void hv_synic_free_cpu(int cpu)
> +{
> +	kfree(hv_context.event_dpc[cpu]);
> +	if (hv_context.synic_message_page[cpu])
> +		free_page((unsigned long)hv_context.synic_event_page[cpu]);
> +	if (hv_context.synic_message_page[cpu])
> +		free_page((unsigned
> long)hv_context.synic_message_page[cpu]);
> +}
> +
> +void hv_synic_free(void)
> +{
> +	int cpu;
> +
> +	for_each_online_cpu(cpu)
> +		hv_synic_free_cpu(cpu);
> +}
> +
>  /*
>   * hv_synic_init - Initialize the Synthethic Interrupt Controller.
>   *
> @@ -289,30 +342,6 @@ void hv_synic_init(void *arg)
>  	/* Check the version */
>  	rdmsrl(HV_X64_MSR_SVERSION, version);
> 
> -	hv_context.event_dpc[cpu] = kmalloc(sizeof(struct tasklet_struct),
> -					    GFP_ATOMIC);
> -	if (hv_context.event_dpc[cpu] == NULL) {
> -		pr_err("Unable to allocate event dpc\n");
> -		goto cleanup;
> -	}
> -	tasklet_init(hv_context.event_dpc[cpu], vmbus_on_event, cpu);
> -
> -	hv_context.synic_message_page[cpu] =
> -		(void *)get_zeroed_page(GFP_ATOMIC);
> -
> -	if (hv_context.synic_message_page[cpu] == NULL) {
> -		pr_err("Unable to allocate SYNIC message page\n");
> -		goto cleanup;
> -	}
> -
> -	hv_context.synic_event_page[cpu] =
> -		(void *)get_zeroed_page(GFP_ATOMIC);
> -
> -	if (hv_context.synic_event_page[cpu] == NULL) {
> -		pr_err("Unable to allocate SYNIC event page\n");
> -		goto cleanup;
> -	}
> -
>  	/* Setup the Synic's message page */
>  	rdmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
>  	simp.simp_enabled = 1;
> @@ -355,14 +384,6 @@ void hv_synic_init(void *arg)
>  	rdmsrl(HV_X64_MSR_VP_INDEX, vp_index);
>  	hv_context.vp_index[cpu] = (u32)vp_index;
>  	return;
> -
> -cleanup:
> -	if (hv_context.synic_event_page[cpu])
> -		free_page((unsigned long)hv_context.synic_event_page[cpu]);
> -
> -	if (hv_context.synic_message_page[cpu])
> -		free_page((unsigned
> long)hv_context.synic_message_page[cpu]);
> -	return;
>  }
> 
>  /*
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 12f2f9e..d84918f 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -527,6 +527,10 @@ extern int hv_post_message(union hv_connection_id
> connection_id,
> 
>  extern u16 hv_signal_event(void *con_id);
> 
> +extern int hv_synic_alloc(void);
> +
> +extern void hv_synic_free(void);
> +
>  extern void hv_synic_init(void *irqarg);
> 
>  extern void hv_synic_cleanup(void *arg);
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 4004e54..a2464bf 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -563,6 +563,9 @@ static int vmbus_bus_init(int irq)
>  	 */
>  	hv_register_vmbus_handler(irq, vmbus_isr);
> 
> +	ret = hv_synic_alloc();
> +	if (ret)
> +		goto err_alloc;
>  	/*
>  	 * Initialize the per-cpu interrupt state and
>  	 * connect to the host.
> @@ -570,13 +573,14 @@ static int vmbus_bus_init(int irq)
>  	on_each_cpu(hv_synic_init, NULL, 1);
>  	ret = vmbus_connect();
>  	if (ret)
> -		goto err_irq;
> +		goto err_alloc;
> 
>  	vmbus_request_offers();
> 
>  	return 0;
> 
> -err_irq:
> +err_alloc:
> +	hv_synic_free();
>  	free_irq(irq, hv_acpi_dev);
> 
>  err_unregister:
> --
> 1.7.1
> 
> 


