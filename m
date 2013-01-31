Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3AaO52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:57:28 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.30]:4983
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab3AaO5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:57:25 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 3/3] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Thread-Topic: [PATCH 3/3] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Thread-Index: AQHN/oBhwK+3Xei++U2sGjyctk2bTZhhkw2AgAHzpqA=
Date: Thu, 31 Jan 2013 14:55:54 +0000
Message-ID: <4b1cb126e6f94d26be741b7b98b58a75@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359507077-26050-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-3-git-send-email-kys@microsoft.com>
 <5108EEDD02000078000BAA22@nat28.tlf.novell.com>
In-Reply-To: <5108EEDD02000078000BAA22@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(189002)(24454001)(13464002)(51704002)(377454001)(49866001)(50466001)(44976002)(4396001)(53806001)(51856001)(63696002)(56776001)(5343635001)(74662001)(47776003)(23726001)(16676001)(47446002)(54316002)(74502001)(47976001)(46102001)(33646001)(31966008)(50986001)(20776003)(59766001)(46406002)(47736001)(56816002)(79102001)(54356001)(76482001)(6806001)(77982001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB014;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0743E8D0A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Wednesday, January 30, 2013 3:59 AM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> Subject: Re: [PATCH 3/3] X86: Handle Hyper-V vmbus interrupts as special
> hypervisor interrupts
> 
> >>> On 30.01.13 at 01:51, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> > --- a/arch/x86/kernel/cpu/mshyperv.c
> > +++ b/arch/x86/kernel/cpu/mshyperv.c
> > @@ -14,10 +14,15 @@
> >  #include <linux/time.h>
> >  #include <linux/clocksource.h>
> >  #include <linux/module.h>
> > +#include <linux/hardirq.h>
> > +#include <linux/interrupt.h>
> >  #include <asm/processor.h>
> >  #include <asm/hypervisor.h>
> >  #include <asm/hyperv.h>
> >  #include <asm/mshyperv.h>
> > +#include <asm/desc.h>
> > +#include <asm/idle.h>
> > +#include <asm/irq_regs.h>
> >
> >  struct ms_hyperv_info ms_hyperv;
> >  EXPORT_SYMBOL_GPL(ms_hyperv);
> > @@ -77,6 +82,12 @@ static void __init ms_hyperv_init_platform(void)
> >
> >  	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
> >  		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> > +#if IS_ENABLED(CONFIG_HYPERV)
> > +	/*
> > +	 * Setup the IDT for hypervisor callback.
> > +	 */
> > +	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
> hyperv_callback_vector);
> > +#endif
> >  }
> >
> >  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
> > @@ -85,3 +96,30 @@ const __refconst struct hypervisor_x86
> x86_hyper_ms_hyperv = {
> >  	.init_platform		= ms_hyperv_init_platform,
> >  };
> >  EXPORT_SYMBOL(x86_hyper_ms_hyperv);
> > +
> > +static int vmbus_irq = -1;
> > +static irq_handler_t vmbus_isr;
> > +
> > +void hv_register_vmbus_handler(int irq, irq_handler_t handler)
> > +{
> > +	vmbus_irq = irq;
> > +	vmbus_isr = handler;
> > +}
> > +EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
> > +
> > +void hyperv_vector_handler(struct pt_regs *regs)
> > +{
> > +	struct pt_regs *old_regs = set_irq_regs(regs);
> > +	struct irq_desc *desc;
> > +
> > +	irq_enter();
> > +	exit_idle();
> > +
> > +	desc = irq_to_desc(vmbus_irq);
> > +
> > +	if (desc)
> > +		generic_handle_irq_desc(vmbus_irq, desc);
> > +
> > +	irq_exit();
> > +	set_irq_regs(old_regs);
> > +}
> 
> This function appears to be dead code when !CONFIG_HYPERV,
> because ...

I will make the necessary adjustments to deal with this.

> 
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -1046,11 +1046,18 @@ ENTRY(xen_failsafe_callback)
> >  	_ASM_EXTABLE(4b,9b)
> >  ENDPROC(xen_failsafe_callback)
> >
> > -BUILD_INTERRUPT3(xen_hvm_callback_vector,
> XEN_HVM_EVTCHN_CALLBACK,
> > +BUILD_INTERRUPT3(xen_hvm_callback_vector,
> HYPERVISOR_CALLBACK_VECTOR,
> >  		xen_evtchn_do_upcall)
> >
> >  #endif	/* CONFIG_XEN */
> >
> > +#if IS_ENABLED(CONFIG_HYPERV)
> > +
> > +BUILD_INTERRUPT3(hyperv_callback_vector,
> HYPERVISOR_CALLBACK_VECTOR,
> > +	hyperv_vector_handler)
> > +
> > +#endif /* CONFIG_HYPERV */
> > +
> >  #ifdef CONFIG_FUNCTION_TRACER
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> >
> 
> ... the consumers here and below are conditional.
> 
> I also wonder why arch/x86/kernel/cpu/mshyperv.c is being built
> at all when !CONFIG_HYPERV (which would eliminate the need
> for the conditional the patch adds to ms_hyperv_init_platform()).

Linux is usable on Hyper-V in full emulation mode with the Hyper-V specific
clocksource plugged in. The current code permits that.

K. Y 

