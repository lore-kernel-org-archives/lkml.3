Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793Ab3GWWou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:44:50 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:21149
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934651Ab3GWWor convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:44:47 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371Ic89bh542I1432I1447Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2fh2a8h683h839h947hd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(377454003)(479174003)(199002)(189002)(51704005)(24454002)(51914003)(13464003)(74876001)(46102001)(69226001)(54356001)(16406001)(76786001)(76796001)(33646001)(81542001)(56776001)(54316002)(81342001)(56816003)(53806001)(76576001)(47446002)(83072001)(19580395003)(80022001)(74366001)(63696002)(83322001)(19580405001)(74662001)(74316001)(66066001)(31966008)(74502001)(65816001)(50986001)(47736001)(74706001)(49866001)(47976001)(77096001)(4396001)(76482001)(77982001)(59766001)(51856001)(79102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Wang <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@redhat.com" <gleb@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
Thread-Topic: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
Thread-Index: AQHOh4p69lea0RwjhkGxDF3F2cFBJJlySJ9AgAAPr4CAACulsIAAFq2AgAA6QWA=
Date: Tue, 23 Jul 2013 22:42:18 +0000
Message-ID: <c7e8bcb7eb25448497107b1a94463f27@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
 <1374572465-15278-4-git-send-email-jasowang@redhat.com>
 <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EE97BD.4050402@zytor.com>
 <e31a95e22bbc4c8dbbf76f88b8c90581@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EECF5F.8000901@zytor.com>
In-Reply-To: <51EECF5F.8000901@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0916FC3A18
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Tuesday, July 23, 2013 2:46 PM
> To: KY Srinivasan
> Cc: Jason Wang; tglx@linutronix.de; mingo@redhat.com; x86@kernel.org;
> gleb@redhat.com; pbonzini@redhat.com; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
> 
> On 07/23/2013 10:45 AM, KY Srinivasan wrote:
> >>
> >> One strategy would be to pick the *last* one in the CPUID list, since
> >> the ones before it are logically the one(s) being emulated...
> >
> > Is it always possible to guarantee this ordering. As a hypothetical, what if
> hypervisor A
> > emulates Hypervisor B and Hypervisor B emulates Hypervisor A. In this case we
> cannot
> > have any "order" based detection that can yield "correct" detection. I define
> "correctness"
> > as follows:
> >
> > If a guest can run on both the hypervisors, the guest should detect the true
> native
> > Hypervisor.at	 
> >
> 
> My point was that most hypervisors tend to put the native signature at
> the end of the list starting at 0x40000000, just to deal with naïve
> guests which only look at 0x40000000 and not beyond.  So a natural
> convention would be to "use the last entry in the list you know how to
> handle."

Ok; thanks for the clarification.

Regards,

K. Y


