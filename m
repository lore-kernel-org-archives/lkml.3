Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab3B0Op5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:45:57 -0500
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:42278
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759935Ab3B0Opz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:45:55 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2013 09:45:55 EST
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Thread-Index: AQHODUFilyhg5qpI3EeOObCjmt3MppiN1YNw
Date: Wed, 27 Feb 2013 14:39:33 +0000
Message-ID: <9bc4a949b57342f284e55a5f3b44738b@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1361129444-30568-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1361129444-30568-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.29.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(13464002)(51704002)(189002)(199002)(1511001)(47446002)(54356001)(16676001)(74662001)(76482001)(51856001)(23726001)(31966008)(59766001)(77982001)(65816001)(53806001)(80022001)(5343635001)(74502001)(79102001)(54316002)(20776003)(33646001)(44976002)(50986001)(56816002)(47976001)(47736001)(47776003)(46102001)(46406002)(56776001)(63696002)(4396001)(49866001)(50466001)(6806001)(66066001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB022;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0770F75EA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Can this patch go in now. I checked Linus' tree and it looks like all the needed patches are all checked in.

Regards,

K. Y

> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Sunday, February 17, 2013 2:31 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; hpa@zytor.com
> Cc: KY Srinivasan
> Subject: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> delivering VMBUS interrupts
> 
> Use the infrastructure for delivering VMBUS interrupts using a
> special vector. With this patch, we can now properly handle
> the VMBUS interrupts that can be delivered on any CPU. Also,
> turn on interrupt load balancing as well.
> 
> This patch requires the infrastructure that was implemented in the patch:
> X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
> 
> Greg, Please apply this patch after 3.9-rc1.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/channel_mgmt.c |    2 +-
>  drivers/hv/hv.c           |    5 ++---
>  drivers/hv/vmbus_drv.c    |   11 +++++++----
>  3 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 53a8600..ff1be16 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -318,7 +318,7 @@ static u32 get_vp_index(uuid_le *type_guid)
>  		return 0;
>  	}
>  	cur_cpu = (++next_vp % max_cpus);
> -	return 0;
> +	return cur_cpu;
>  }
> 
>  /*
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index 1c5481d..7311589 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -272,7 +272,7 @@ u16 hv_signal_event(void *con_id)
>   * retrieve the initialized message and event pages.  Otherwise, we create and
>   * initialize the message and event pages.
>   */
> -void hv_synic_init(void *irqarg)
> +void hv_synic_init(void *arg)
>  {
>  	u64 version;
>  	union hv_synic_simp simp;
> @@ -281,7 +281,6 @@ void hv_synic_init(void *irqarg)
>  	union hv_synic_scontrol sctrl;
>  	u64 vp_index;
> 
> -	u32 irq_vector = *((u32 *)(irqarg));
>  	int cpu = smp_processor_id();
> 
>  	if (!hv_context.hypercall_page)
> @@ -335,7 +334,7 @@ void hv_synic_init(void *irqarg)
>  	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT,
> shared_sint.as_uint64);
> 
>  	shared_sint.as_uint64 = 0;
> -	shared_sint.vector = irq_vector; /* HV_SHARED_SINT_IDT_VECTOR +
> 0x20; */
> +	shared_sint.vector = HYPERVISOR_CALLBACK_VECTOR;
>  	shared_sint.masked = false;
>  	shared_sint.auto_eoi = true;
> 
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index cf19dfa..bf421e0 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -36,6 +36,7 @@
>  #include <linux/kernel_stat.h>
>  #include <asm/hyperv.h>
>  #include <asm/hypervisor.h>
> +#include <asm/mshyperv.h>
>  #include "hyperv_vmbus.h"
> 
> 
> @@ -528,7 +529,6 @@ static void vmbus_flow_handler(unsigned int irq, struct
> irq_desc *desc)
>  static int vmbus_bus_init(int irq)
>  {
>  	int ret;
> -	unsigned int vector;
> 
>  	/* Hypervisor initialization...setup hypercall page..etc */
>  	ret = hv_init();
> @@ -558,13 +558,16 @@ static int vmbus_bus_init(int irq)
>  	 */
>  	irq_set_handler(irq, vmbus_flow_handler);
> 
> -	vector = IRQ0_VECTOR + irq;
> +	/*
> +	 * Register our interrupt handler.
> +	 */
> +	hv_register_vmbus_handler(irq, vmbus_isr);
> 
>  	/*
> -	 * Notify the hypervisor of our irq and
> +	 * Initialize the per-cpu interrupt state and
>  	 * connect to the host.
>  	 */
> -	on_each_cpu(hv_synic_init, (void *)&vector, 1);
> +	on_each_cpu(hv_synic_init, NULL, 1);
>  	ret = vmbus_connect();
>  	if (ret)
>  		goto err_irq;
> --
> 1.7.4.1
> 
> 


