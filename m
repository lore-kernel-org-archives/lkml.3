Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3AXSvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:51:23 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.29]:37459
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3AXSvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:51:18 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
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
Thread-Index: AQHN+c0MrCoyWgAlfk2jp/FeLEmABphYK3yAgAB21tCAAAYiAIAAKTrA
Date: Thu, 24 Jan 2013 18:48:31 +0000
Message-ID: <f6cbfec9c014433fa54af61d8f436ebb@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
 <5101035D02000078000B8FFD@nat28.tlf.novell.com>
 <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
 <51016C3202000078000B943E@nat28.tlf.novell.com>
In-Reply-To: <51016C3202000078000B943E@nat28.tlf.novell.com>
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
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(189002)(199002)(24454001)(13464002)(51704002)(56776001)(76482001)(31966008)(44976002)(56816002)(23726001)(59766001)(63696002)(74502001)(33646001)(47776003)(54356001)(74662001)(46406002)(47446002)(53806001)(5343635001)(49866001)(50466001)(6806001)(54316002)(4396001)(47736001)(47976001)(51856001)(50986001)(79102001)(77982001)(46102001)(16676001)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB039;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 073631BD3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Thursday, January 24, 2013 11:16 AM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> Subject: RE: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
> special hypervisor interrupts
> 
> >>> On 24.01.13 at 17:07, KY Srinivasan <kys@microsoft.com> wrote:
> 
> >
> >> -----Original Message-----
> >> From: Jan Beulich [mailto:JBeulich@suse.com]
> >> Sent: Thursday, January 24, 2013 3:48 AM
> >> To: KY Srinivasan
> >> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> >> tglx@linutronix.de; devel@linuxdriverproject.org;
> > gregkh@linuxfoundation.org;
> >> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> >> Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
> >> special hypervisor interrupts
> >>
> >> >>> On 24.01.13 at 02:17, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> >> > @@ -69,6 +74,11 @@ static void __init ms_hyperv_init_platform(void)
> >> >  	       ms_hyperv.features, ms_hyperv.hints);
> >> >
> >> >  	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> >> > +
> >> > +	/*
> >> > +	 * Setup the IDT for hypervisor callback.
> >> > +	 */
> >> > +	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
> >> hyperv_callback_vector);
> >>
> >> Isn't doing this unconditionally here as problematic as the call to
> >> clocksource_register_hz() turned out to be when Xen's Hyper-V
> >> shim reacts to the CPUID inquiry above?
> >
> > I was not sure what to make this conditional on at run-time. To the extent
> > that Xen emulation of Hyper-V is complete, this will be a problem. Does Xen
> > return all the "feature bits" of Hyper-V. I could discriminate on a feature
> > that
> > Xen does not plan to emulate.
> 
> I've no idea what plans there might be, but that's the code
> there is currently:
> 
> int cpuid_viridian_leaves(unsigned int leaf, unsigned int *eax,
>                           unsigned int *ebx, unsigned int *ecx,
>                           unsigned int *edx)
> {
>     struct domain *d = current->domain;
> 
>     if ( !is_viridian_domain(d) )
>         return 0;
> 
>     leaf -= 0x40000000;
>     if ( leaf > 6 )
>         return 0;
> 
>     *eax = *ebx = *ecx = *edx = 0;
>     switch ( leaf )
>     {
>     case 0:
>         *eax = 0x40000006; /* Maximum leaf */
>         *ebx = 0x7263694d; /* Magic numbers  */
>         *ecx = 0x666F736F;
>         *edx = 0x76482074;
>         break;
>     case 1:
>         *eax = 0x31237648; /* Version number */
>         break;
>     case 2:
>         /* Hypervisor information, but only if the guest has set its
>            own version number. */
>         if ( d->arch.hvm_domain.viridian.guest_os_id.raw == 0 )
>             break;
>         *eax = 1; /* Build number */
>         *ebx = (xen_major_version() << 16) | xen_minor_version();
>         *ecx = 0; /* SP */
>         *edx = 0; /* Service branch and number */
>         break;
>     case 3:
>         /* Which hypervisor MSRs are available to the guest */
>         *eax = (CPUID3A_MSR_APIC_ACCESS |
>                 CPUID3A_MSR_HYPERCALL   |
>                 CPUID3A_MSR_VP_INDEX);
>         break;
>     case 4:
>         /* Recommended hypercall usage. */
>         if ( (d->arch.hvm_domain.viridian.guest_os_id.raw == 0) ||
>              (d->arch.hvm_domain.viridian.guest_os_id.fields.os < 4) )
>             break;
>         *eax = (CPUID4A_MSR_BASED_APIC |
>                 CPUID4A_RELAX_TIMER_INT);
>         *ebx = 2047; /* long spin count */
>         break;
>     }
> 
>     return 1;
> }
> 
> Question is - considering you stated that this is supported
> starting in Win8, doesn't Hyper-V itself announce that
> capability in some explicit way?

Thanks Jan. Unfortunately I don't think tis interrupt delivery model is
specified via a "feature" bit (I will check with the Windows guys). Perhaps, we
can have a Hyper-V specific compilation switch to address the Xen emulation issue.

Regards,

K. Y  
> 
> Jan
> 
> 


