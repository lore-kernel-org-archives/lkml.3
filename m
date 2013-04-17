Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966540Ab3DQOMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:12:44 -0400
Received: from mail-bn1lp0151.outbound.protection.outlook.com ([207.46.163.151]:4343
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966321Ab3DQOMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:12:42 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Topic: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Index: AQHOAnJoFJQhzmD3TUKsF9dq+4jlRZjabzYAgABndUD///hDAIAAE9LQ
Date: Wed, 17 Apr 2013 14:12:12 +0000
Message-ID: <3b76ebfdb240419aa601309465a4c154@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417124852.GD6801@redhat.com>
In-Reply-To: <20130417124852.GD6801@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(199002)(189002)(377454001)(51704004)(13464002)(65816001)(80022001)(66066001)(5343655001)(59766001)(77982001)(79102001)(81542001)(51856001)(81342001)(76482001)(5343635001)(44976003)(69226001)(56816002)(16676001)(53806001)(15202345002)(23726002)(54356001)(33646001)(56776001)(54316002)(46406003)(47446002)(31966008)(49866001)(74662001)(46102001)(47736001)(47776003)(50466001)(63696002)(4396001)(47976001)(20776003)(6806003)(74502001)(50986001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB016;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 081904387B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michael S. Tsirkin [mailto:mst@redhat.com]
> Sent: Wednesday, April 17, 2013 8:49 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> 
> On Wed, Apr 17, 2013 at 01:20:58PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Michael S. Tsirkin [mailto:mst@redhat.com]
> > > Sent: Wednesday, April 17, 2013 3:06 AM
> > > To: KY Srinivasan
> > > Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> > > JBeulich@suse.com; bp@alien8.de
> > > Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> > >
> > > On Sun, Feb 03, 2013 at 05:22:38PM -0800, K. Y. Srinivasan wrote:
> > > > Xen emulates Hyper-V to host enlightened Windows. Looks like this
> > > > emulation may be turned on by default even for Linux guests. Check and
> > > > fail Hyper-V detection if we are on Xen.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > >
> > > I'm very curious what's the specific bug that is fixed here?
> > > I went over the original discussion in
> > > https://patchwork.kernel.org/patch/2064331/
> > > and that's still not clear to me. Is there a configuration
> > > that is broken without this patch but starts working with
> > > this patch?
> > >
> > > It seems that one might want to use hyper-v emulation e.g. to test
> > > hyper-v code without using windows, so the functionality
> > > that this patch disables is not completely useless,
> > > so there should be a good reason for disabling it.
> > >
> > > Could you enlighten me please? :)
> >
> > Michael,
> >
> > If I recall correctly, the issue here was that Xen was enabling
> > Hyper-V emulation un-conditionally even for Linux guests.
> 
> Okay so basically some Xen specific strangeness.
> 
> > Clearly,
> > this was not the intention to begin with. This check was added to
> > ensure that while hosting Linux we would not un-intentionally enable
> > Hyper-V emulation in Xen.
> 
> What if you want to intentionally enable Hyper-V emulation in Xen?
> There's no way to do this now, right?
> 
> > Not all Hyper-V features are tagged with a
> > CPUID feature bit and so it was agreed that it would be better to
> > disable Hyper-V emulation when hosting Linux on Xen.
> >
> > Regards,
> >
> > K. Y
> 
> I was just asking whether there are any specific examples of a bug
> or is this change done just in case?

Ideally, if Hyper-V could be emulated in a plug compatible way, in that the guest would not know
the difference as to whether Hyper-V was being emulated or indeed it was Hyper-V underneath, I would agree with you.
Even in this case, I would argue that we would somehow give preference to the native implementation rather
than the emulated environment. Having done the initial emulation of Hyper-V on Xen, I know the current emulation of 
Hyper-V is restricted to emulating a few features advertised via the CPUID bits. If I recall correctly, Xen did not implement
the enlightened TLB flush scheme. Furthermore, none of the Hyper-V emulations implement the I/O related infrastructure.
For Linux to run efficiently on Hyper-V, the I/O paths are significantly more important than what Hyper-V emulation there is
in Xen and I suspect in KVM. So, I don't think we want to run Linux on Xen/KVM that is emulating Hyper-V (cpuids).
The specific case I ran into that required this patch was when I moved the VMBUS interrupts to be delivered via a special
hypervisor vector (to support full interrupt distribution amongst all VCPUs in the guest). This feature is not tagged in the CPUID
feature bits and without this check, I would install an interrupt handler for the hypervisor vector that clearly did not make
any sense in anything other than Hyper-V. I suspect there will be more such situations as we go forward.

Regards,

K. Y 
> 
> > >
> > > > ---
> > > >  arch/x86/kernel/cpu/mshyperv.c |    7 +++++++
> > > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kernel/cpu/mshyperv.c
> > > b/arch/x86/kernel/cpu/mshyperv.c
> > > > index 646d192..4dab317 100644
> > > > --- a/arch/x86/kernel/cpu/mshyperv.c
> > > > +++ b/arch/x86/kernel/cpu/mshyperv.c
> > > > @@ -30,6 +30,13 @@ static bool __init ms_hyperv_platform(void)
> > > >  	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
> > > >  		return false;
> > > >
> > > > +	/*
> > > > +	 * Xen emulates Hyper-V to support enlightened Windows.
> > > > +	 * Check to see first if we are on a Xen Hypervisor.
> > > > +	 */
> > > > +	if (xen_cpuid_base())
> > > > +		return false;
> > > > +
> > > >  	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
> > > >  	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
> > > >
> > > > --
> > > > 1.7.4.1
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> >
> 


