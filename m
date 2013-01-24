Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3AXTGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:06:08 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.23]:18572
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab3AXTGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:06:06 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(z551biz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: Jan Beulich <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>,
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
Thread-Index: AQHN+c0MrCoyWgAlfk2jp/FeLEmABphYK3yAgAB21tCAAAYiAIAAKTrAgAAEqICAAACTQA==
Date: Thu, 24 Jan 2013 19:03:42 +0000
Message-ID: <462e0bc4257744428139d5dbc91192be@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
 <5101035D02000078000B8FFD@nat28.tlf.novell.com>
 <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
 <51016C3202000078000B943E@nat28.tlf.novell.com>
 <f6cbfec9c014433fa54af61d8f436ebb@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130124185943.GA19194@aepfle.de>
In-Reply-To: <20130124185943.GA19194@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464002)(24454001)(377454001)(50466001)(54356001)(33646001)(53806001)(6806001)(74662001)(74502001)(47976001)(16676001)(47736001)(50986001)(76482001)(54316002)(49866001)(79102001)(47446002)(63696002)(44976002)(4396001)(51856001)(31966008)(59766001)(77982001)(56776001)(56816002)(5343635001)(46102001)(23676001)(47776003)(24736002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB023;H:TK5EX14HUBC103.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 073631BD3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0OJ68g7013758



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, January 24, 2013 2:00 PM
> To: KY Srinivasan
> Cc: Jan Beulich; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
> special hypervisor interrupts
> 
> On Thu, Jan 24, KY Srinivasan wrote:
> 
> 
> > > Question is - considering you stated that this is supported
> > > starting in Win8, doesn't Hyper-V itself announce that
> > > capability in some explicit way?
> >
> > Thanks Jan. Unfortunately I don't think tis interrupt delivery model
> > is specified via a "feature" bit (I will check with the Windows guys).
> > Perhaps, we can have a Hyper-V specific compilation switch to address
> > the Xen emulation issue.
> 
> Would that really help if both pvops XEN_PVHVM and HYPERV are enabled in
> the config? I assume at this point the access to the DMI data is not yet
> possible.

I was under the impression that only Dom0 Xen would emulate Hyper-V.


K. Y
> 
> Olaf
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
