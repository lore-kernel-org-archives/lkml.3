Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3GXOEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:04:33 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:40014
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909Ab3GXOEb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:04:31 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(24454002)(479174003)(377454003)(199002)(189002)(13464003)(51704005)(46102001)(76576001)(76786001)(74502001)(4396001)(81542001)(81342001)(79102001)(47446002)(47736001)(33646001)(16406001)(56816003)(49866001)(76796001)(74662001)(83072001)(74366001)(19580395003)(74316001)(51856001)(83322001)(19580405001)(77982001)(59766001)(54356001)(63696002)(53806001)(56776001)(77096001)(31966008)(65816001)(54316002)(66066001)(80022001)(74876001)(74706001)(69226001)(76482001)(47976001)(50986001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB051;H:BLUPR03MB050.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jason Wang <jasowang@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
Thread-Topic: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
Thread-Index: AQHOh4p69lea0RwjhkGxDF3F2cFBJJlySJ9AgAAPr4CAAOeOgIAAAyIAgAAjPACAAANbgIAAc2WQ
Date: Wed, 24 Jul 2013 14:01:26 +0000
Message-ID: <ddd4ff1d4b124faeb18e6a0ba8ae2128@BLUPR03MB050.namprd03.prod.outlook.com>
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com>
 <1374572465-15278-4-git-send-email-jasowang@redhat.com>
 <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EE97BD.4050402@zytor.com> <51EF59FB.8040207@redhat.com>
 <51EF5C9C.6070403@zytor.com> <51EF7A2A.6040003@redhat.com>
 <51EF7CFB.8030104@redhat.com>
In-Reply-To: <51EF7CFB.8030104@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0917DFAC67
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BLUPR03MB051.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of Paolo
> Bonzini
> Sent: Wednesday, July 24, 2013 3:07 AM
> To: Jason Wang
> Cc: H. Peter Anvin; KY Srinivasan; tglx@linutronix.de; mingo@redhat.com;
> x86@kernel.org; gleb@redhat.com; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
> 
> Il 24/07/2013 08:54, Jason Wang ha scritto:
> > On 07/24/2013 12:48 PM, H. Peter Anvin wrote:
> >> On 07/23/2013 09:37 PM, Jason Wang wrote:
> >>> On 07/23/2013 10:48 PM, H. Peter Anvin wrote:
> >>>> On 07/23/2013 06:55 AM, KY Srinivasan wrote:
> >>>>> This strategy of hypervisor detection based on some detection order
> IMHO is not
> >>>>> a robust detection strategy. The current scheme works since the only
> hypervisor emulated
> >>>>> (by other hypervisors happens to be Hyper-V). What if this were to
> change.
> >>>>>
> >>>> One strategy would be to pick the *last* one in the CPUID list, since
> >>>> the ones before it are logically the one(s) being emulated...
> >>>>
> >>>> 	-hpa
> >>>>
> >>> How about simply does a reverse loop from 0x40010000 to 0x40010000?
> >>>
> >> Not all systems like being poked too far into hyperspace.  Just remember
> >> the last match and walk the list.
> >>
> >> 	-hpa
> >>
> >
> > Ok, but it raises a question - how to know it was the 'last' match
> > without knowing all signatures of other hyper-visor?
> 
> You can return a "priority" value from the .detect function.  The
> priority value can simply be the CPUID leaf where the signature was
> found (or a low value such as 1 if detection was done with DMI).
> 
> Then you can pick the hypervisor with the highest priority instead of
> hard-coding the order.

I like this idea; this allows some guest level control that is what we want
when we have hypervisors emulating each other.


Regards,

K. Y 
> 
> Paolo
> 
> 



