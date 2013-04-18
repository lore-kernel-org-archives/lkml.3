Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3DRNdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:33:53 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:34335
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755103Ab3DRNdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:33:52 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahz97hz17326ah8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>, Jan Beulich <JBeulich@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Topic: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Index: AQHOAnJoFJQhzmD3TUKsF9dq+4jlRZjabzYAgABndUD///hDAIAAE9LQ///2YoCAABF4gP//9RUAAANR4jAAAPGWAAAA7LQAACCB7gAAB4pZEAAEZRWg
Date: Thu, 18 Apr 2013 13:30:56 +0000
Message-ID: <beb28777dcbe4bfb9cc5cc77baba6ec0@SN2PR03MB061.namprd03.prod.outlook.com>
References: <20130417070616.GA4487@redhat.com>
 <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417124852.GD6801@redhat.com>
 <3b76ebfdb240419aa601309465a4c154@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417132523.GB26157@redhat.com>
 <9ffd83acf6ac4a7bb5d51c95c96e6f50@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417134850.GB26335@redhat.com>
 <0cd5cde572734ea786664accc1a40bea@SN2PR03MB061.namprd03.prod.outlook.com>
 <516EE0FE02000078000CE422@nat28.tlf.novell.com>
 <76ae3b714d064ae392332615bfd872d5@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130418074810.GI13787@redhat.com>
 <cf53931949684c509dc30588ad77a7a9@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <cf53931949684c509dc30588ad77a7a9@SN2PR03MB061.namprd03.prod.outlook.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(51704004)(13464002)(24454001)(377454001)(79102001)(6806003)(81542001)(4396001)(33646001)(23726002)(47736001)(47776003)(54316002)(46406003)(65816001)(54356001)(50466001)(51856001)(77982001)(56776001)(76482001)(50986001)(74502001)(53806001)(49866001)(31966008)(63696002)(46102001)(47446002)(66066001)(44976003)(69226001)(1511001)(80022001)(56816002)(15202345002)(81342001)(16676001)(20776003)(74662001)(47976001)(59766001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB031;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 08200063E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:devel-bounces@linuxdriverproject.org] On Behalf Of KY
> Srinivasan
> Sent: Thursday, April 18, 2013 9:23 AM
> To: Michael S. Tsirkin
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; jasowang@redhat.com;
> x86@kernel.org; linux-kernel@vger.kernel.org; bp@alien8.de; Jan Beulich;
> hpa@zytor.com; apw@canonical.com; devel@linuxdriverproject.org;
> tglx@linutronix.de
> Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> 
> 
> 
> > -----Original Message-----
> > From: Michael S. Tsirkin [mailto:mst@redhat.com]
> > Sent: Thursday, April 18, 2013 3:48 AM
> > To: KY Srinivasan
> > Cc: Jan Beulich; olaf@aepfle.de; bp@alien8.de; apw@canonical.com;
> > x86@kernel.org; tglx@linutronix.de; devel@linuxdriverproject.org;
> > gregkh@linuxfoundation.org; jasowang@redhat.com; linux-
> > kernel@vger.kernel.org; hpa@zytor.com
> > Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> >
> > On Wed, Apr 17, 2013 at 04:28:36PM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jan Beulich [mailto:JBeulich@suse.com]
> > > > Sent: Wednesday, April 17, 2013 11:51 AM
> > > > To: KY Srinivasan; Michael S. Tsirkin
> > > > Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> > > > tglx@linutronix.de; devel@linuxdriverproject.org;
> > gregkh@linuxfoundation.org;
> > > > jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> > > > Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-
> V
> > > >
> > > > >>> On 17.04.13 at 17:31, KY Srinivasan <kys@microsoft.com> wrote:
> > > > > If Xen were to change where it would not unconditionally emulate Hyper-
> V,
> > I
> > > > > would not be opposed to taking
> > > > > this check out.
> > > >
> > > > But it doesn't do this unconditionally, only upon admin request.
> > >
> > > >From the discussion we had a couple of months ago, the default setting was
> to
> > enable
> > > Hyper-V emulation for all guests. If this is not the case, we ought to be able to
> > drop this.
> > > However, I think it is not reasonable to add additional checks (in addition to
> > hypervisor check)
> > > to customize the run-time in the guest for the specific Hypervisor.
> > >
> > > Regards,
> > >
> > > K. Y
> >
> > Parse error. What are you trying to say? I'm just saying it's best to do
> > things in the way that make it possible for Xen to implement hyperv in a
> > more complete way in the future and have things just work
> > and in a way that does not change guest/hypervisor interface.
> 
> There is no error to parse here. I need to setup the vmbus interrupt before I
> can contact the host. As I said I am fine with dropping this check if Xen behavior is
> changed appropriately. We have a mechanism for hypervisor detection and a
> mechanism for discovering features within a hypervisor. Once we confirm the
> existence of a specific hypervisor, we ought to be able to do what is needed for
> that hypervisor (unless the hypervisor feature flag precludes it) without having to
> go through hoops to discover if we are in a hypervisor emulation mode where
> the emulation
> may not be complete. In this particular case, the need for VMBUS related
> infrastructure cannot be
> currently determined via the feature detection mechanism.
> 
> For features that cannot be detected via CPUID feature bits, we can use some
> other CPUID based
> mechanism to discriminate. For instance in the case under discussion, I could
> install
> hyperv_callback_vector only if we are on an environment that supports the
> vmbus infrastructure.
> Unfortunately there is no positive test for this. The best we can do is a negative
> test. I could move the
> Xen check and conditionally install the hyperv_callback vector.

Michael,

I think I can address the problem you have raised. I will send a patch out soon.

Regards,

K. Y
> 
> Regards,
> 
> K. Y
> 
> 
> >
> > > >
> > > > Jan
> > > >
> > > >
> > >
> >
> 
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
> 


