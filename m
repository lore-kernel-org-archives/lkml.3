Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3AaPzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:55:07 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.29]:35898
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3AaPzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:55:03 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz17326ah8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Jan Beulich <JBeulich@suse.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Topic: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Index: AQHN/oBZKjWVFkcFI0COSVsKHXB045hhkYiAgACaZkCAAOLIAIAAd2MwgAASsfA=
Date: Thu, 31 Jan 2013 15:53:57 +0000
Message-ID: <fe91cec766464b4fbfeea56d7e5de0a0@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359507077-26050-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-2-git-send-email-kys@microsoft.com>
 <5108ED9702000078000BAA08@nat28.tlf.novell.com>
 <1db4d98aa3434d4eab7b36bbeb89cd47@SN2PR03MB061.namprd03.prod.outlook.com>
 <510A2D5802000078000BAEAA@nat28.tlf.novell.com>
 <32e50a43db8849f2944db256989bebb8@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <32e50a43db8849f2944db256989bebb8@SN2PR03MB061.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(377454001)(13464002)(24454001)(199002)(189002)(47976001)(5343635001)(46406002)(56776001)(63696002)(50466001)(23726001)(31966008)(33646001)(5343655001)(47776003)(53806001)(51856001)(6806001)(74662001)(50986001)(20776003)(1511001)(44976002)(49866001)(15202345001)(4396001)(54316002)(76482001)(46102001)(79102001)(47446002)(47736001)(77982001)(74502001)(16676001)(56816002)(59766001)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB008;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0743E8D0A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:devel-bounces@linuxdriverproject.org] On Behalf Of KY
> Srinivasan
> Sent: Thursday, January 31, 2013 9:46 AM
> To: Jan Beulich
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; jasowang@redhat.com;
> x86@kernel.org; linux-kernel@vger.kernel.org; bp@alien8.de; hpa@zytor.com;
> apw@canonical.com; devel@linuxdriverproject.org; tglx@linutronix.de
> Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> 
> 
> 
> > -----Original Message-----
> > From: Jan Beulich [mailto:JBeulich@suse.com]
> > Sent: Thursday, January 31, 2013 2:38 AM
> > To: KY Srinivasan
> > Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> > tglx@linutronix.de; devel@linuxdriverproject.org;
> gregkh@linuxfoundation.org;
> > jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> > Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> >
> > >>> On 30.01.13 at 19:12, KY Srinivasan <kys@microsoft.com> wrote:
> > > Presumably, Hyper-V emulation is only to run enlightened Windows. The
> issue
> > > with
> > > Xen is not that it emulates Hyper-V, but this emulation is turned on while
> > > running Linux.
> > > That is the reason I chose to check for Xen. Would you prefer a DMI check
> > > for the Hyper-V
> > > platform.
> >
> > I consider DMI checks to be too fragile here - in particular with
> > the eventual passing through of host DMI attributes to guests,
> > this sets you up for mistakes. Instead, I would envision you
> > scanning the whole CPUID range "reserved" for virtualization
> > (starting at 0x40000000) and see whether you get back
> > anything other than the Hyper-V identification (much like the
> > way xen_cpuid_base() scans for the Xen range). Of course
> > that's under the premise that you're right in assuming Hyper-V
> > would never emulate any other hypervisor's interface.
> 
> Agreed; I will make the appropriate changes as you have recommended.

Jan,

Are there any published standards in terms of how the CPUID space should be populated in the range from 0x40000000 to 0x40010000. Specifically, unless the standard mandates that all ranges unused by a given hypervisor would return a known value, how can this code be used to detect the presence of an unknown hypervisor. Hyper-V is going to return the Hyper-V string at 0x40000000. So, I was planning to scan starting at 0x40000100. Clearly, I can check for a specific hypervisor that I know causes a problem for Hyper-V (as I have currently done by checking for Xen). How can I check for the presence of yet to be created Hypervisors that may emulate Hyper-V by scanning the CPUID space. I am almost tempted to say that Xen is the special case and the patch I have submitted addresses that. If a new (or existing hypervisor) plans to do what Xen is doing, perhaps we can dissuade them from doing that or we can fix that within the general framework we have here.

Regards,

K. Y
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
> 


