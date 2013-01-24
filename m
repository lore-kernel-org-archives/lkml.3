Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3AXRqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:46:02 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.31]:45548
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab3AXRqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:46:00 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(z551biz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Borislav Petkov <bp@alien8.de>
CC: "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: RE: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Topic: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Index: AQHN+dJXAd6E57fVREKQXb6aL+OAVJhYNqiAgACAUKA=
Date: Thu, 24 Jan 2013 17:42:40 +0000
Message-ID: <3f75c2349f8348668639c04f6590fa8b@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358992569-22826-1-git-send-email-kys@microsoft.com>
 <20130124092821.GA13463@pd.tnic>
In-Reply-To: <20130124092821.GA13463@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704002)(13464002)(24454001)(47736001)(59766001)(5343635001)(50466001)(53806001)(33646001)(31966008)(4396001)(16676001)(54356001)(46102001)(54316002)(74502001)(74662001)(44976002)(23676001)(77982001)(47446002)(63696002)(56776001)(49866001)(76482001)(47976001)(50986001)(79102001)(51856001)(6806001)(56816002)(47776003)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB040;H:TK5EX14HUBC106.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 073631BD3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0OHk2aY013173



> -----Original Message-----
> From: Borislav Petkov [mailto:bp@alien8.de]
> Sent: Thursday, January 24, 2013 4:28 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com; JBeulich@suse.com
> Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
> special hypervisor interrupts
> 
> On Wed, Jan 23, 2013 at 05:56:09PM -0800, K. Y. Srinivasan wrote:
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index 1975122..803ca69 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1446,11 +1446,16 @@ ENTRY(xen_failsafe_callback)
> >  	CFI_ENDPROC
> >  END(xen_failsafe_callback)
> >
> > -apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
> > +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> >  	xen_hvm_callback_vector xen_evtchn_do_upcall
> >
> >  #endif /* CONFIG_XEN */
> >
> > +#if IS_ENABLED(CONFIG_HYPERV)
> > +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> > +	hyperv_callback_vector hyperv_vector_handler
> > +#endif /* CONFIG_HYPERV */
> 
> arch/x86/built-in.o: In function `_set_gate':
> /w/kernel/linux-2.6/arch/x86/include/asm/desc.h:328: undefined reference to
> `hyperv_callback_vector'
> make: *** [vmlinux] Error 1
> 
> because, of course:
> 
> # CONFIG_HYPERV is not set

My mistake. I should have properly guarded code that needs to be conditional. This also would address
the issue that Jan raised. I will resend this patch soon.

Regards,

K. Y 

> 
> But, I have a more serious pet-peeve with the whole hypervisors
> detection stuff: we're building arch/x86/kernel/cpu/hypervisor.c
> unconditionally and yet, we have CONFIG_PARAVIRT_GUEST to ask the user
> whether she wants to enable some options for running linux as a guest.
> 
> And actually, it would be better to put all that virt-related stuff
> under a config option called HYPERVISOR or whatever, under "Processor
> type and features" which opens a menu with all virt stuff for people and
> distros to select.
> 
> This way, init_hypervisor_platform and the rest of hypervisors stuff
> won't run needlessly on baremetal and setups who don't want that.
> 
> Any non-starter reasons for not doing that?


> 
> --
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
