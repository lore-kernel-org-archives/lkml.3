Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3A3SQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:16:06 -0500
Received: from [207.46.100.31] ([207.46.100.31]:1138 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756440Ab3A3SQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:16:04 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
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
Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Topic: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Index: AQHN/oBZKjWVFkcFI0COSVsKHXB045hhkYiAgACaZkA=
Date: Wed, 30 Jan 2013 18:12:17 +0000
Message-ID: <1db4d98aa3434d4eab7b36bbeb89cd47@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359507077-26050-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-2-git-send-email-kys@microsoft.com>
 <5108ED9702000078000BAA08@nat28.tlf.novell.com>
In-Reply-To: <5108ED9702000078000BAA08@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.93.4]
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
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(377454001)(199002)(51704002)(13464002)(24454001)(33646001)(47736001)(46102001)(53806001)(59766001)(20776003)(31966008)(56776001)(50986001)(77982001)(23726001)(74662001)(4396001)(74502001)(79102001)(54316002)(44976002)(54356001)(47776003)(47976001)(5343635001)(56816002)(76482001)(63696002)(47446002)(49866001)(6806001)(46406002)(16676001)(51856001)(50466001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB030;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0742443479
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Wednesday, January 30, 2013 3:53 AM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> 
> >>> On 30.01.13 at 01:51, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> > Xen emulates Hyper-V to host enlightened Windows. Looks like this
> > emulation may be turned on by default even for Linux guests. Check and
> > fail Hyper-V detection if we are on Xen.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
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
> 
> I'm not convinced that's the right approach - any hypervisor
> could do similar emulation, and hence you either want to make
> sure you run on Hyper-V (by excluding all others), or you
> tolerate using the emulation (which may require syncing up with
> the other guest implementations so that shared resources don't
> get used by two parties).
> 
> I also wonder whether using the Hyper-V emulation (where
> useful, there might not be anything right now, but this may
> change going forward) when no Xen support is configured
> wouldn't be better than not using anything...

Jan,

Presumably, Hyper-V emulation is only to run enlightened Windows. The issue with
Xen is not that it emulates Hyper-V, but this emulation is turned on while running Linux.
That is the reason I chose to check for Xen. Would you prefer a DMI check for the Hyper-V
platform. 

Regards,

K. Y


