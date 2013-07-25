Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3GYK5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:57:07 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:8855
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755148Ab3GYK5D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:57:03 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(13464003)(377454003)(189002)(199002)(51704005)(49866001)(47976001)(74316001)(74662001)(19580405001)(74502001)(31966008)(66066001)(47736001)(50986001)(65816001)(83322001)(59766001)(4396001)(79102001)(51856001)(77982001)(63696002)(56816003)(76786001)(74706001)(76482001)(77096001)(33646001)(56776001)(81542001)(80022001)(53806001)(76796001)(46102001)(69226001)(83072001)(47446002)(74876001)(74366001)(19580395003)(76576001)(81342001)(54316002)(54356001)(16406001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Doug Covelli <dcovelli@vmware.com>, Borislav Petkov <bp@suse.de>,
        Dan Hecht <dhecht@vmware.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH V2 4/4] x86: correctly detect hypervisor
Thread-Topic: [PATCH V2 4/4] x86: correctly detect hypervisor
Thread-Index: AQHOiRZBs7iRiJk7XUucfvAIpxXjdZl1N/Qg
Date: Thu, 25 Jul 2013 10:56:10 +0000
Message-ID: <1f47d60c59a842a1bab5f5d7377cea53@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1374742475-2485-1-git-send-email-jasowang@redhat.com>
 <1374742475-2485-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1374742475-2485-4-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0918748D70
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%WINDRIVER.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VMWARE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.XENSOURCE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LISTS.LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOP.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Thursday, July 25, 2013 4:55 AM
> To: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> linux-kernel@vger.kernel.org; pbonzini@redhat.com
> Cc: kvm@vger.kernel.org; Jason Wang; KY Srinivasan; Haiyang Zhang; Konrad
> Rzeszutek Wilk; Jeremy Fitzhardinge; Doug Covelli; Borislav Petkov; Dan Hecht;
> Paul Gortmaker; Marcelo Tosatti; Gleb Natapov; Frederic Weisbecker;
> devel@linuxdriverproject.org; xen-devel@lists.xensource.com;
> virtualization@lists.linux-foundation.org
> Subject: [PATCH V2 4/4] x86: correctly detect hypervisor
> 
> We try to handle the hypervisor compatibility mode by detecting hypervisor
> through a specific order. This is not robust, since hypervisors may implement
> each others features.
> 
> This patch tries to handle this situation by always choosing the last one in the
> CPUID leaves. This is done by letting .detect() returns a priority instead of
> true/false and just re-using the CPUID leaf where the signature were found as
> the priority (or 1 if it was found by DMI). Then we can just pick hypervisor who
> has the highest priority. Other sophisticated detection method could also be
> implemented on top.
> 
> Suggested by H. Peter Anvin and Paolo Bonzini.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Doug Covelli <dcovelli@vmware.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Dan Hecht <dhecht@vmware.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: devel@linuxdriverproject.org
> Cc: kvm@vger.kernel.org
> Cc: xen-devel@lists.xensource.com
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>

> ---
>  arch/x86/include/asm/hypervisor.h |    2 +-
>  arch/x86/kernel/cpu/hypervisor.c  |   15 +++++++--------
>  arch/x86/kernel/cpu/mshyperv.c    |   13 ++++++++-----
>  arch/x86/kernel/cpu/vmware.c      |    8 ++++----
>  arch/x86/kernel/kvm.c             |    6 ++----
>  arch/x86/xen/enlighten.c          |    9 +++------
>  6 files changed, 25 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/include/asm/hypervisor.h
> b/arch/x86/include/asm/hypervisor.h
> index 2d4b5e6..e42f758 100644
> --- a/arch/x86/include/asm/hypervisor.h
> +++ b/arch/x86/include/asm/hypervisor.h
> @@ -33,7 +33,7 @@ struct hypervisor_x86 {
>  	const char	*name;
> 
>  	/* Detection routine */
> -	bool		(*detect)(void);
> +	uint32_t	(*detect)(void);
> 
>  	/* Adjust CPU feature bits (run once per CPU) */
>  	void		(*set_cpu_features)(struct cpuinfo_x86 *);
> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> index 8727921..36ce402 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -25,11 +25,6 @@
>  #include <asm/processor.h>
>  #include <asm/hypervisor.h>
> 
> -/*
> - * Hypervisor detect order.  This is specified explicitly here because
> - * some hypervisors might implement compatibility modes for other
> - * hypervisors and therefore need to be detected in specific sequence.
> - */
>  static const __initconst struct hypervisor_x86 * const hypervisors[] =
>  {
>  #ifdef CONFIG_XEN_PVHVM
> @@ -49,15 +44,19 @@ static inline void __init
>  detect_hypervisor_vendor(void)
>  {
>  	const struct hypervisor_x86 *h, * const *p;
> +	uint32_t pri, max_pri = 0;
> 
>  	for (p = hypervisors; p < hypervisors + ARRAY_SIZE(hypervisors); p++) {
>  		h = *p;
> -		if (h->detect()) {
> +		pri = h->detect();
> +		if (pri != 0 && pri > max_pri) {
> +			max_pri = pri;
>  			x86_hyper = h;
> -			printk(KERN_INFO "Hypervisor detected: %s\n", h-
> >name);
> -			break;
>  		}
>  	}
> +
> +	if (max_pri)
> +		printk(KERN_INFO "Hypervisor detected: %s\n", x86_hyper-
> >name);
>  }
> 
>  void init_hypervisor(struct cpuinfo_x86 *c)
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 8f4be53..71a39f3 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -27,20 +27,23 @@
>  struct ms_hyperv_info ms_hyperv;
>  EXPORT_SYMBOL_GPL(ms_hyperv);
> 
> -static bool __init ms_hyperv_platform(void)
> +static uint32_t  __init ms_hyperv_platform(void)
>  {
>  	u32 eax;
>  	u32 hyp_signature[3];
> 
>  	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
> -		return false;
> +		return 0;
> 
>  	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
>  	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
> 
> -	return eax >= HYPERV_CPUID_MIN &&
> -		eax <= HYPERV_CPUID_MAX &&
> -		!memcmp("Microsoft Hv", hyp_signature, 12);
> +	if (eax >= HYPERV_CPUID_MIN &&
> +	    eax <= HYPERV_CPUID_MAX &&
> +	    !memcmp("Microsoft Hv", hyp_signature, 12))
> +		return HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS;
> +
> +	return 0;
>  }
> 
>  static cycle_t read_hv_clock(struct clocksource *arg)
> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> index 7076878..628a059 100644
> --- a/arch/x86/kernel/cpu/vmware.c
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -93,7 +93,7 @@ static void __init vmware_platform_setup(void)
>   * serial key should be enough, as this will always have a VMware
>   * specific string when running under VMware hypervisor.
>   */
> -static bool __init vmware_platform(void)
> +static uint32_t __init vmware_platform(void)
>  {
>  	if (cpu_has_hypervisor) {
>  		unsigned int eax;
> @@ -102,12 +102,12 @@ static bool __init vmware_platform(void)
>  		cpuid(CPUID_VMWARE_INFO_LEAF, &eax,
> &hyper_vendor_id[0],
>  		      &hyper_vendor_id[1], &hyper_vendor_id[2]);
>  		if (!memcmp(hyper_vendor_id, "VMwareVMware", 12))
> -			return true;
> +			return CPUID_VMWARE_INFO_LEAF;
>  	} else if (dmi_available && dmi_name_in_serial("VMware") &&
>  		   __vmware_platform())
> -		return true;
> +		return 1;
> 
> -	return false;
> +	return 0;
>  }
> 
>  /*
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a96d32c..7817afd 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -498,11 +498,9 @@ void __init kvm_guest_init(void)
>  #endif
>  }
> 
> -static bool __init kvm_detect(void)
> +static uint32_t __init kvm_detect(void)
>  {
> -	if (!kvm_para_available())
> -		return false;
> -	return true;
> +	return kvm_cpuid_base();
>  }
> 
>  const struct hypervisor_x86 x86_hyper_kvm __refconst = {
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 193097e..2fcaedc 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1720,15 +1720,12 @@ static void __init xen_hvm_guest_init(void)
>  	xen_hvm_init_mmu_ops();
>  }
> 
> -static bool __init xen_hvm_platform(void)
> +static uint32_t __init xen_hvm_platform(void)
>  {
>  	if (xen_pv_domain())
> -		return false;
> -
> -	if (!xen_cpuid_base())
> -		return false;
> +		return 0;
> 
> -	return true;
> +	return xen_cpuid_base();
>  }
> 
>  bool xen_hvm_need_lapic(void)
> --
> 1.7.1
> 
> 
> 



