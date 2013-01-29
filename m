Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3A2QGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:06:21 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.23]:46567
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab3A2QGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:06:18 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Olaf Hering <olaf@aepfle.de>, Jan Beulich <JBeulich@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Topic: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Index: AQHN+wFSTQzC7+pzaUi0ZNGfsVWqjphaPkYAgAAFEACAAACuUIAABjaAgAACDmCABLvrAIAA+RcAgAAOPgCAAE8GoIAAFqyAgAAF/MA=
Date: Tue, 29 Jan 2013 15:58:08 +0000
Message-ID: <f4315e27ffc14047b5e2ef61eeeba036@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125165443.GA15833@aepfle.de>
 <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de>
 <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
 <alpine.DEB.2.02.1301281737210.10432@kaball.uk.xensource.com>
 <510797FA02000078000BA4B8@nat28.tlf.novell.com>
 <20130129092652.GA9020@aepfle.de>
 <a23c7fab41444058845badb015b7dc0a@SN2PR03MB061.namprd03.prod.outlook.com>
 <alpine.DEB.2.02.1301291522460.10432@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1301291522460.10432@kaball.uk.xensource.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%EU.CITRIX.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(377454001)(51704002)(13464002)(24454001)(4396001)(77982001)(59766001)(50986001)(47446002)(54316002)(51856001)(76482001)(20776003)(50466001)(79102001)(23726001)(33646001)(31966008)(46406002)(74662001)(46102001)(56776001)(54356001)(53806001)(56816002)(47776003)(63696002)(74502001)(44976002)(6806001)(47736001)(5343655001)(49866001)(16676001)(47976001)(57646009)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB034;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:;MX:3;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0741C77572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stefano Stabellini [mailto:stefano.stabellini@eu.citrix.com]
> Sent: Tuesday, January 29, 2013 10:31 AM
> To: KY Srinivasan
> Cc: Olaf Hering; Jan Beulich; Stefano Stabellini; Greg KH; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> 
> On Tue, 29 Jan 2013, KY Srinivasan wrote:
> > > The patch which started this thread is still valid because it enables
> > > feature B only if the featurebit for B is enabled.
> >
> > Why would we need this if we have some other way of detecting that Hyper-V
> is being
> > emulated.
> 
> I don't think that Hyper-V being emulated or not matters here.
> What matters is whether the feature is available: only if it is then it
> should be used.
> 
> 
> > Furthermore, I am not sure I understand the logic here. The fact that the
> hypervisor
> > supports PARTITION_REFERENCE_COUNTER does not necessarily mean that we
> should register
> > a clocksource based on that reference counter. It is true that that is the case on
> Hyper-V today.
> > However, on other hypervisors emulating Hyper-V, other standard
> clocksources maybe more
> > appropriate.
> 
> The point is that if a feature is NOT supported, then it should NOT be
> used. Only if it is supported, then Linux might consider using it. And
> of course can decide not to use it.
> 
> 
> > I agree with you that your patch is valid for making the Hyper-V code more
> robust but not for dealing
> > with general issue of Xen emulating Hyper-V.
> 
> What "general issue" would that be?

Not all Hyper-V specific features are advertised via a feature bit. For instance, we need to reserve
an IDT entry to have VMBUS interrupts delivered on a per-CPU basis and this reservation is done
after confirming that we are running on Hyper-V. With Xen emulating Hyper-V, we have an issue.
Since Hyper-V will never emulate Xen, I am going to add a check in the Hyper-V detection code to
deal with this issue.

Regards,

K. Y
 


