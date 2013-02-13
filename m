Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab3BMMtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:49:05 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.31]:20169
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab3BMMtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:49:03 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Topic: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Index: AQHOCZW/ATaUhT0+bEODP3cDxaZ/B5h3IYSggAAEpQCAAACw4IAAAaWAgAAAiyCAAAz8AIAAhsAw
Date: Wed, 13 Feb 2013 12:47:14 +0000
Message-ID: <e637e3e4bb724e32a64b13ba746d65a6@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359940959-32168-3-git-send-email-kys@microsoft.com>
	<tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
	<CAE9FiQXZRj84-fBwV4Hb0NQxcMxD1JTdsFXfyHMzaK-59TXjAg@mail.gmail.com>
	<7d06776025df4b788474c9710ed692ca@SN2PR03MB061.namprd03.prod.outlook.com>
	<511B0C84.5040806@zytor.com>
	<f6d62df8f3cb4076a2d3fe8a4f054a99@SN2PR03MB061.namprd03.prod.outlook.com>
	<511B0E79.6030007@zytor.com>
	<53da10fbf2904c6597568abdf10fe8f0@SN2PR03MB061.namprd03.prod.outlook.com>
 <CAE9FiQVBXyF2ry==pnS3N+FrUObGW1HO3fCnKW1BxE7JpmzGcA@mail.gmail.com>
In-Reply-To: <CAE9FiQVBXyF2ry==pnS3N+FrUObGW1HO3fCnKW1BxE7JpmzGcA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX.INTEL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC101.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC101.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(479174001)(13464002)(199002)(189002)(24454001)(377454001)(51704002)(49866001)(46406002)(5343655001)(50466001)(5343635001)(4396001)(77982001)(23726001)(80022001)(20776003)(56816002)(56776001)(63696002)(76482001)(54356001)(16676001)(51856001)(6806001)(53806001)(79102001)(47736001)(47976001)(66066001)(47776003)(74502001)(74662001)(47446002)(50986001)(31966008)(33646001)(46102001)(44976002)(59766001)(65816001)(54316002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB008;H:TK5EX14HUBC101.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07562C22DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Tuesday, February 12, 2013 11:43 PM
> To: KY Srinivasan
> Cc: H. Peter Anvin; mingo@kernel.org; linux-kernel@vger.kernel.org;
> tglx@linutronix.de; hpa@linux.intel.com; linux-tip-commits@vger.kernel.org
> Subject: Re: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as special
> hypervisor interrupts
> 
> On Tue, Feb 12, 2013 at 7:58 PM, KY Srinivasan <kys@microsoft.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: H. Peter Anvin [mailto:hpa@zytor.com]
> >> Sent: Tuesday, February 12, 2013 10:55 PM
> >> To: KY Srinivasan
> >> Cc: Yinghai Lu; mingo@kernel.org; linux-kernel@vger.kernel.org;
> >> tglx@linutronix.de; hpa@linux.intel.com; linux-tip-commits@vger.kernel.org
> >> Subject: Re: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as special
> >> hypervisor interrupts
> >>
> >> On 02/12/2013 07:49 PM, KY Srinivasan wrote:
> >> >>>
> >> >>> The issue was that you could turn on CONFIG_HYPERV without enabling
> >> >>> CONFIG_X86_LOCAL_APIC. Peter fixed it.
> >> >>>
> >> >>
> >> >> He is asking why you are using IS_ENABLED() instead of #ifdef.  The
> >> >> difference is that IS_ENABLED() works even for modules.
> >> >
> >> > My mistake!
> >> >
> >>
> >> Well, which one do you need?
> >
> > I chose the IS_ENABLED() because I wanted to cover the case where HYPERV is
> configured as a module as well.
> >
> 
> ok, so when HYPERV is built as module, actually it is partially module
> as it put some code built-in already?
> if user never load hyperv, those code will never not be used.
> 
> Can those code not be put in module _init function?

Some code in mshyperv.c is built into the kernel. Registering an IDT entry is dependent on HYPERV drivers being configured - either as modules or built-in.

K. Y
> 
> Thanks
> 
> Yinghai
> 


