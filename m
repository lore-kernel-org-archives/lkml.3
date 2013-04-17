Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966287Ab3DQN0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:26:50 -0400
Received: from [207.46.163.244] ([207.46.163.244]:39248 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966044Ab3DQN0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:26:48 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
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
Thread-Index: AQHOAnJoFJQhzmD3TUKsF9dq+4jlRZjabzYAgABndUA=
Date: Wed, 17 Apr 2013 13:20:58 +0000
Message-ID: <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
In-Reply-To: <20130417070616.GA4487@redhat.com>
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
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(51704004)(13464002)(24454001)(377454001)(189002)(47776003)(20776003)(53806001)(56776001)(51856001)(80022001)(47446002)(50986001)(33646001)(15202345002)(69226001)(59766001)(54316002)(63696002)(31966008)(5343655001)(47736001)(77982001)(81342001)(76482001)(65816001)(46406003)(46102001)(74662001)(50466001)(49866001)(47976001)(16676001)(54356001)(44976003)(74502001)(23726002)(66066001)(5343635001)(56816002)(4396001)(79102001)(6806003)(81542001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB004;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 081904387B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michael S. Tsirkin [mailto:mst@redhat.com]
> Sent: Wednesday, April 17, 2013 3:06 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> 
> On Sun, Feb 03, 2013 at 05:22:38PM -0800, K. Y. Srinivasan wrote:
> > Xen emulates Hyper-V to host enlightened Windows. Looks like this
> > emulation may be turned on by default even for Linux guests. Check and
> > fail Hyper-V detection if we are on Xen.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> I'm very curious what's the specific bug that is fixed here?
> I went over the original discussion in
> https://patchwork.kernel.org/patch/2064331/
> and that's still not clear to me. Is there a configuration
> that is broken without this patch but starts working with
> this patch?
> 
> It seems that one might want to use hyper-v emulation e.g. to test
> hyper-v code without using windows, so the functionality
> that this patch disables is not completely useless,
> so there should be a good reason for disabling it.
> 
> Could you enlighten me please? :)

Michael,

If I recall correctly, the issue here was that Xen was enabling Hyper-V emulation un-conditionally even for Linux guests. Clearly, this was not the intention to begin with. This check was added to ensure that while hosting Linux we would not un-intentionally enable Hyper-V emulation in Xen. Not all Hyper-V features are tagged with a CPUID feature bit and so it was agreed that it would be better to disable Hyper-V emulation when hosting Linux on Xen.

Regards,

K. Y
> 
> > ---
> >  arch/x86/kernel/cpu/mshyperv.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/mshyperv.c
> b/arch/x86/kernel/cpu/mshyperv.c
> > index 646d192..4dab317 100644
> > --- a/arch/x86/kernel/cpu/mshyperv.c
> > +++ b/arch/x86/kernel/cpu/mshyperv.c
> > @@ -30,6 +30,13 @@ static bool __init ms_hyperv_platform(void)
> >  	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
> >  		return false;
> >
> > +	/*
> > +	 * Xen emulates Hyper-V to support enlightened Windows.
> > +	 * Check to see first if we are on a Xen Hypervisor.
> > +	 */
> > +	if (xen_cpuid_base())
> > +		return false;
> > +
> >  	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
> >  	      &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
> >
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 


