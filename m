Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3AWP7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:59:50 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.29]:33208
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872Ab3AWP7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:59:48 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@alien8.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: RE: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Thread-Topic: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Thread-Index: AQHN9RC9go3bU96kuUWjPmeK6MjrpZhPEF4AgAAlFpCABr3pAIAAEGWAgAEWrLA=
Date: Wed, 23 Jan 2013 15:57:32 +0000
Message-ID: <ed79f9e06117454aa6b01f425bb3f6cd@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com>
 <20130118131056.GA14550@pd.tnic>
 <794a590acf1a47408a87e95f095e6b1b@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130122222056.GC14503@phenom.dumpdata.com>
 <2bd8c994-3e70-413b-85de-caec46428b1e@email.android.com>
In-Reply-To: <2bd8c994-3e70-413b-85de-caec46428b1e@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.124.4]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOP.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704002)(24454001)(13464002)(44976002)(74662001)(31966008)(4396001)(47776002)(47446002)(51856001)(74502001)(23676001)(59766001)(56816002)(79102001)(77982001)(46102001)(5343635001)(56776001)(6806001)(33646001)(47976001)(54356001)(53806001)(50466001)(50986001)(76482001)(54316002)(16676001)(49866001)(47736001)(6816006)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB023;H:TK5EX14HUBC104.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 073515755F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0NFxq78004834



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Tuesday, January 22, 2013 6:20 PM
> To: Konrad Rzeszutek Wilk; KY Srinivasan
> Cc: Borislav Petkov; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; Ingo Molnar; jeremy@goop.org; Jan
> Beulich (JBeulich@suse.com)
> Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
> hypervisor interrupts
> 
> Yes, how about we rename this the hypervisor vector...

Will do.

K. Y
> 
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> >On Fri, Jan 18, 2013 at 03:27:33PM +0000, KY Srinivasan wrote:
> >>
> >>
> >> > -----Original Message-----
> >> > From: Borislav Petkov [mailto:bp@alien8.de]
> >> > Sent: Friday, January 18, 2013 8:11 AM
> >> > To: KY Srinivasan
> >> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> >> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> >> > jasowang@redhat.com; tglx@linutronix.de; H. Peter Anvin; Ingo
> >Molnar
> >> > Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as
> >special
> >> > hypervisor interrupts
> >> >
> >> > On Thu, Jan 17, 2013 at 04:39:37PM -0800, K. Y. Srinivasan wrote:
> >> > >
> >> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >> > > ---
> >> > >  arch/x86/include/asm/irq_vectors.h |    2 +
> >> > >  arch/x86/include/asm/mshyperv.h    |    4 +++
> >> > >  arch/x86/kernel/cpu/mshyperv.c     |   39
> >> > ++++++++++++++++++++++++++++++++++++
> >> > >  arch/x86/kernel/entry_32.S         |    7 ++++++
> >> > >  arch/x86/kernel/entry_64.S         |    5 ++++
> >> > >  5 files changed, 57 insertions(+), 0 deletions(-)
> >> > >
> >> > > diff --git a/arch/x86/include/asm/irq_vectors.h
> >> > b/arch/x86/include/asm/irq_vectors.h
> >> > > index 1508e51..c2ff239 100644
> >> > > --- a/arch/x86/include/asm/irq_vectors.h
> >> > > +++ b/arch/x86/include/asm/irq_vectors.h
> >> > > @@ -112,6 +112,8 @@
> >> > >  /* Xen vector callback to receive events in a HVM domain */
> >> > >  #define XEN_HVM_EVTCHN_CALLBACK		0xf3
> >> > >
> >> > > +/* Hyper-V vector callback to receive vmbus interrupts*/
> >> > > +#define HYPER_V_CALLBACK_VECTOR		0xf2
> >> >
> >> > Btw, could those hypervisor vectors be merged into one
> >VIRT_INTR_VECTOR
> >> > and be shared between the hypervisors? I mean, you can't have a xen
> >and
> >> > hyperv hypervisor running next to each other and fihgting over that
> >> > vector, right?
> >>
> >> You are right; we could just have one vector for this. Let me wait
> >for other comments and
> >> input from Xen maintainers before I make this change.
> >>
> >> Regards,
> >>
> >
> >Looks OK to me.
> >
> >> K. Y
> >> >
> >> > --
> >> > Regards/Gruss,
> >> >     Boris.
> >> >
> >> > Sent from a fat crate under my desk. Formatting is fine.
> >> > --
> >> >
> >>
> 
> --
> Sent from my Android phone with K-9 Mail. Please excuse my brevity.
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
