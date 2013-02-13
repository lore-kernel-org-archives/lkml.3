Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673Ab3BMDdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:33:24 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.25]:31425
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3BMDdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:33:23 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Yinghai Lu <yinghai@kernel.org>, "mingo@kernel.org" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Topic: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Index: AQHOCZW/ATaUhT0+bEODP3cDxaZ/B5h3IYSg
Date: Wed, 13 Feb 2013 03:32:48 +0000
Message-ID: <7d06776025df4b788474c9710ed692ca@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359940959-32168-3-git-send-email-kys@microsoft.com>
	<tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
 <CAE9FiQXZRj84-fBwV4Hb0NQxcMxD1JTdsFXfyHMzaK-59TXjAg@mail.gmail.com>
In-Reply-To: <CAE9FiQXZRj84-fBwV4Hb0NQxcMxD1JTdsFXfyHMzaK-59TXjAg@mail.gmail.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX.INTEL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(24454001)(13464002)(189002)(199002)(51704002)(66066001)(15202345001)(53806001)(74502001)(23726001)(54316002)(33646001)(80022001)(47446002)(76482001)(46102001)(31966008)(46406002)(44976002)(65816001)(56776001)(54356001)(74662001)(51856001)(47736001)(49866001)(47976001)(50466001)(50986001)(59766001)(6806001)(77982001)(47776003)(56816002)(63696002)(5343655001)(16676001)(5343635001)(79102001)(4396001)(20776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB020;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07562C22DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Tuesday, February 12, 2013 9:56 PM
> To: mingo@kernel.org; hpa@zytor.com; linux-kernel@vger.kernel.org; KY
> Srinivasan; tglx@linutronix.de; hpa@linux.intel.com
> Cc: linux-tip-commits@vger.kernel.org
> Subject: Re: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as special
> hypervisor interrupts
> 
> On Tue, Feb 12, 2013 at 4:58 PM, tip-bot for K. Y. Srinivasan
> <kys@microsoft.com> wrote:
> > Commit-ID:  bc2b0331e077f576369a2b6c75d15ed4de4ef91f
> > Gitweb:
> http://git.kernel.org/tip/bc2b0331e077f576369a2b6c75d15ed4de4ef91f
> > Author:     K. Y. Srinivasan <kys@microsoft.com>
> > AuthorDate: Sun, 3 Feb 2013 17:22:39 -0800
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Tue, 12 Feb 2013 16:27:15 -0800
> >
> > X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
> >
> > Starting with win8, vmbus interrupts can be delivered on any VCPU in the guest
> > and furthermore can be concurrently active on multiple VCPUs. Support this
> > interrupt delivery model by setting up a separate IDT entry for Hyper-V vmbus.
> > interrupts. I would like to thank Jan Beulich <JBeulich@suse.com> and
> > Thomas Gleixner <tglx@linutronix.de>, for their help.
> >
> > In this version of the patch, based on the feedback, I have merged the IDT
> > vector for Xen and Hyper-V and made the necessary adjustments. Furhermore,
> > based on Jan's feedback I have added the necessary compilation switches.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Link: http://lkml.kernel.org/r/1359940959-32168-3-git-send-email-
> kys@microsoft.com
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > ---
> >  arch/x86/include/asm/irq_vectors.h |  4 ++--
> >  arch/x86/include/asm/mshyperv.h    |  4 ++++
> >  arch/x86/kernel/cpu/mshyperv.c     | 44
> ++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/entry_32.S         |  9 +++++++-
> >  arch/x86/kernel/entry_64.S         |  7 +++++-
> >  drivers/xen/events.c               |  7 +++---
> >  6 files changed, 68 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/irq_vectors.h
> b/arch/x86/include/asm/irq_vectors.h
> > index 1508e51..aac5fa6 100644
> > --- a/arch/x86/include/asm/irq_vectors.h
> > +++ b/arch/x86/include/asm/irq_vectors.h
> > @@ -109,8 +109,8 @@
> >
> >  #define UV_BAU_MESSAGE                 0xf5
> >
> > -/* Xen vector callback to receive events in a HVM domain */
> > -#define XEN_HVM_EVTCHN_CALLBACK                0xf3
> > +/* Vector on which hypervisor callbacks will be delivered */
> > +#define HYPERVISOR_CALLBACK_VECTOR     0xf3
> >
> >  /*
> >   * Local APIC timer IRQ vector is on a different priority level,
> > diff --git a/arch/x86/include/asm/mshyperv.h
> b/arch/x86/include/asm/mshyperv.h
> > index 79ce568..c2934be 100644
> > --- a/arch/x86/include/asm/mshyperv.h
> > +++ b/arch/x86/include/asm/mshyperv.h
> > @@ -11,4 +11,8 @@ struct ms_hyperv_info {
> >
> >  extern struct ms_hyperv_info ms_hyperv;
> >
> > +void hyperv_callback_vector(void);
> > +void hyperv_vector_handler(struct pt_regs *regs);
> > +void hv_register_vmbus_handler(int irq, irq_handler_t handler);
> > +
> >  #endif
> > diff --git a/arch/x86/kernel/cpu/mshyperv.c
> b/arch/x86/kernel/cpu/mshyperv.c
> > index 4dab317..a7d26d8 100644
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
> >         if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
> >                 clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> > +#if IS_ENABLED(CONFIG_HYPERV)
> > +       /*
> > +        * Setup the IDT for hypervisor callback.
> > +        */
> > +       alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
> hyperv_callback_vector);
> > +#endif
> >  }
> >
> >  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
> > @@ -85,3 +96,36 @@ const __refconst struct hypervisor_x86
> x86_hyper_ms_hyperv = {
> >         .init_platform          = ms_hyperv_init_platform,
> >  };
> >  EXPORT_SYMBOL(x86_hyper_ms_hyperv);
> > +
> > +#if IS_ENABLED(CONFIG_HYPERV)
> > +static int vmbus_irq = -1;
> > +static irq_handler_t vmbus_isr;
> > +
> > +void hv_register_vmbus_handler(int irq, irq_handler_t handler)
> > +{
> > +       vmbus_irq = irq;
> > +       vmbus_isr = handler;
> > +}
> > +
> > +void hyperv_vector_handler(struct pt_regs *regs)
> > +{
> > +       struct pt_regs *old_regs = set_irq_regs(regs);
> > +       struct irq_desc *desc;
> > +
> > +       irq_enter();
> > +       exit_idle();
> > +
> > +       desc = irq_to_desc(vmbus_irq);
> > +
> > +       if (desc)
> > +               generic_handle_irq_desc(vmbus_irq, desc);
> > +
> > +       irq_exit();
> > +       set_irq_regs(old_regs);
> > +}
> > +#else
> > +void hv_register_vmbus_handler(int irq, irq_handler_t handler)
> > +{
> > +}
> > +#endif
> > +EXPORT_SYMBOL_GPL(hv_register_vmbus_handler);
> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > index 6ed91d9..8831176 100644
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -1091,11 +1091,18 @@ ENTRY(xen_failsafe_callback)
> >         _ASM_EXTABLE(4b,9b)
> >  ENDPROC(xen_failsafe_callback)
> >
> > -BUILD_INTERRUPT3(xen_hvm_callback_vector,
> XEN_HVM_EVTCHN_CALLBACK,
> > +BUILD_INTERRUPT3(xen_hvm_callback_vector,
> HYPERVISOR_CALLBACK_VECTOR,
> >                 xen_evtchn_do_upcall)
> >
> >  #endif /* CONFIG_XEN */
> >
> > +#if IS_ENABLED(CONFIG_HYPERV)
> > +
> > +BUILD_INTERRUPT3(hyperv_callback_vector,
> HYPERVISOR_CALLBACK_VECTOR,
> > +       hyperv_vector_handler)
> > +
> > +#endif /* CONFIG_HYPERV */
> > +
> >  #ifdef CONFIG_FUNCTION_TRACER
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> >
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index cb3c591..048f224 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1454,11 +1454,16 @@ ENTRY(xen_failsafe_callback)
> >         CFI_ENDPROC
> >  END(xen_failsafe_callback)
> >
> > -apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
> > +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> >         xen_hvm_callback_vector xen_evtchn_do_upcall
> >
> >  #endif /* CONFIG_XEN */
> >
> > +#if IS_ENABLED(CONFIG_HYPERV)
> > +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> > +       hyperv_callback_vector hyperv_vector_handler
> > +#endif /* CONFIG_HYPERV */
> > +
> 
> so #ifdef CONFIG_HYPERV does not work here?

The issue was that you could turn on CONFIG_HYPERV without enabling 
CONFIG_X86_LOCAL_APIC. Peter fixed it.

Regards,

K. Y
> 
> Yinghai
> 


