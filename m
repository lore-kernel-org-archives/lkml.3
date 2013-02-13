Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab3BMDts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:49:48 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.31]:25290
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3BMDtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:49:46 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Topic: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Thread-Index: AQHOCZW/ATaUhT0+bEODP3cDxaZ/B5h3IYSggAAEpQCAAACw4A==
Date: Wed, 13 Feb 2013 03:49:18 +0000
Message-ID: <f6d62df8f3cb4076a2d3fe8a4f054a99@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359940959-32168-3-git-send-email-kys@microsoft.com>
 <tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
 <CAE9FiQXZRj84-fBwV4Hb0NQxcMxD1JTdsFXfyHMzaK-59TXjAg@mail.gmail.com>
 <7d06776025df4b788474c9710ed692ca@SN2PR03MB061.namprd03.prod.outlook.com>
 <511B0C84.5040806@zytor.com>
In-Reply-To: <511B0C84.5040806@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX.INTEL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(377454001)(479174001)(24454001)(199002)(189002)(51704002)(5343655001)(66066001)(16676001)(23676001)(65816001)(80022001)(56816002)(4396001)(50466001)(47736001)(53806001)(54356001)(77982001)(59766001)(50986001)(47776003)(47976001)(51856001)(49866001)(20776003)(63696002)(54316002)(76482001)(56776001)(79102001)(74662001)(74502001)(33646001)(47446002)(44976002)(31966008)(46102001)(6806001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB017;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07562C22DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1D3noet027670



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Tuesday, February 12, 2013 10:46 PM
> To: KY Srinivasan
> Cc: Yinghai Lu; mingo@kernel.org; linux-kernel@vger.kernel.org;
> tglx@linutronix.de; hpa@linux.intel.com; linux-tip-commits@vger.kernel.org
> Subject: Re: [tip:x86/hyperv] X86: Handle Hyper-V vmbus interrupts as special
> hypervisor interrupts
> 
> On 02/12/2013 07:32 PM, KY Srinivasan wrote:
> >>>
> >>> +#if IS_ENABLED(CONFIG_HYPERV)
> >>> +apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> >>> +       hyperv_callback_vector hyperv_vector_handler
> >>> +#endif /* CONFIG_HYPERV */
> >>> +
> >>
> >> so #ifdef CONFIG_HYPERV does not work here?
> >
> > The issue was that you could turn on CONFIG_HYPERV without enabling
> > CONFIG_X86_LOCAL_APIC. Peter fixed it.
> >
> 
> He is asking why you are using IS_ENABLED() instead of #ifdef.  The
> difference is that IS_ENABLED() works even for modules.

My mistake!

K. Y
> 
> 	-hpa
> 
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
