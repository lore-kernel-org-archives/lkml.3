Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3AZQuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 11:50:39 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.31]:4236
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab3AZQug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 11:50:36 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [tip:x86/asm] x86/xor: Make virtualization friendly
Thread-Topic: [tip:x86/asm] x86/xor: Make virtualization friendly
Thread-Index: AQHN+2FruynsyNHbgU+vxzcA8VVBs5hb0zzg
Date: Sat, 26 Jan 2013 16:49:56 +0000
Message-ID: <a725c7f649e142c7a4063abaaaa6f1d2@SN2PR03MB061.namprd03.prod.outlook.com>
References: <5093E4F302000078000A6162@nat28.tlf.novell.com>
 <tip-05fbf4d6fc6a3c0c3e63b77979c9311596716d10@git.kernel.org>
 <510302FD.3090009@zytor.com> <510303F8.1080105@zytor.com>
 <51032BCB.5070506@zytor.com>
In-Reply-To: <51032BCB.5070506@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(13464002)(24454001)(479174001)(189002)(51704002)(377454001)(63696002)(74502001)(47446002)(4396001)(50466001)(47776003)(74662001)(5343635001)(49866001)(31966008)(5343655001)(23676001)(50986001)(56816002)(51856001)(54356001)(47976001)(16676001)(54316002)(79102001)(44976002)(77982001)(47736001)(33646001)(15202345001)(76482001)(53806001)(56776001)(6806001)(59766001)(46102001)(20776003)(57646009)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB001;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0738AF4208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0QGoqV0026432



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Friday, January 25, 2013 8:05 PM
> To: H. Peter Anvin
> Cc: mingo@kernel.org; linux-kernel@vger.kernel.org; konrad.wilk@oracle.com;
> torvalds@linux-foundation.org; JBeulich@suse.com; tglx@linutronix.de; linux-
> tip-commits@vger.kernel.org; Marcelo Tosatti; KY Srinivasan; Haiyang Zhang
> Subject: Re: [tip:x86/asm] x86/xor: Make virtualization friendly
> 
> On 01/25/2013 02:15 PM, H. Peter Anvin wrote:
> > On 01/25/2013 02:11 PM, H. Peter Anvin wrote:
> >> On 01/25/2013 02:43 AM, tip-bot for Jan Beulich wrote:
> >>> Commit-ID:  05fbf4d6fc6a3c0c3e63b77979c9311596716d10
> >>> Gitweb:
> http://git.kernel.org/tip/05fbf4d6fc6a3c0c3e63b77979c9311596716d10
> >>> Author:     Jan Beulich <JBeulich@suse.com>
> >>> AuthorDate: Fri, 2 Nov 2012 14:21:23 +0000
> >>> Committer:  Ingo Molnar <mingo@kernel.org>
> >>> CommitDate: Fri, 25 Jan 2013 09:23:51 +0100
> >>>
> >>> x86/xor: Make virtualization friendly
> >>>
> >>> In virtualized environments, the CR0.TS management needed here
> >>> can be a lot slower than anticipated by the original authors of
> >>> this code, which particularly means that in such cases forcing
> >>> the use of SSE- (or MMX-) based implementations is not desirable
> >>> - actual measurements should always be done in that case.
> >>>
> >>> For consistency, pull into the shared (32- and 64-bit) header
> >>> not only the inclusion of the generic code, but also that of the
> >>> AVX variants.
> >>>
> >>
> >> This patch is wrong and should be dropped.  I verified it with the KVM
> >> people that they do NOT want this change.  It is a Xen-specific problem.
> >>
> >
> > FWIW: I have dropped this patch from tip:x86/asm.
> >
> 
> The bottom line, I guess, is that we need something like
> cpu_has_slow_kernel_fpu or something like that, and set it for
> specifically affected hypervisors?
> 
> Do we know if Hyper-V has performance issues with CR0.TS?

Checking with the Hyper-V developers, Hyper-V does not have performance issues
With CR0.TS

Regards,

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
