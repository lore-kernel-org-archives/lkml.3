Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3AXQKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:10:52 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.31]:21008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab3AXQKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:10:49 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(z551biz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
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
Subject: RE: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Topic: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Index: AQHN+c0MrCoyWgAlfk2jp/FeLEmABphYK3yAgAB21tA=
Date: Thu, 24 Jan 2013 16:07:40 +0000
Message-ID: <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
 <5101035D02000078000B8FFD@nat28.tlf.novell.com>
In-Reply-To: <5101035D02000078000B8FFD@nat28.tlf.novell.com>
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
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704002)(13464002)(24454001)(74502001)(44976002)(49866001)(74662001)(47446002)(31966008)(33646001)(51856001)(53806001)(56776001)(46406002)(79102001)(23726001)(4396001)(46102001)(59766001)(77982001)(5343635001)(56816002)(63696002)(76482001)(54356001)(6806001)(16676001)(47976001)(47736001)(50466001)(50986001)(54316002)(47776003)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB014;H:TK5EX14HUBC105.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 073631BD3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Thursday, January 24, 2013 3:48 AM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
> special hypervisor interrupts
> 
> >>> On 24.01.13 at 02:17, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> > @@ -69,6 +74,11 @@ static void __init ms_hyperv_init_platform(void)
> >  	       ms_hyperv.features, ms_hyperv.hints);
> >
> >  	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> > +
> > +	/*
> > +	 * Setup the IDT for hypervisor callback.
> > +	 */
> > +	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
> hyperv_callback_vector);
> 
> Isn't doing this unconditionally here as problematic as the call to
> clocksource_register_hz() turned out to be when Xen's Hyper-V
> shim reacts to the CPUID inquiry above?

I was not sure what to make this conditional on at run-time. To the extent
that Xen emulation of Hyper-V is complete, this will be a problem. Does Xen
return all the "feature bits" of Hyper-V. I could discriminate on a feature that
Xen does not plan to emulate.

> 
> > @@ -77,3 +87,32 @@ const __refconst struct hypervisor_x86
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
> > +#ifdef CONFIG_X86
> > +	exit_idle();
> > +#endif
> 
> This being in a file underneath arch/x86 - why the conditional?

Good point, I will fix that.
> 
> Jan
> 
> 


