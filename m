Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3A2PPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:15:18 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.27]:7286
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab3A2PPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:15:14 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I542I1432I1418Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>, Jan Beulich <JBeulich@suse.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Topic: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Index: AQHN+wFSTQzC7+pzaUi0ZNGfsVWqjphaPkYAgAAFEACAAACuUIAABjaAgAACDmCABLvrAIAA+RcAgAAOPgCAAE8GoA==
Date: Tue, 29 Jan 2013 14:32:18 +0000
Message-ID: <a23c7fab41444058845badb015b7dc0a@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125165443.GA15833@aepfle.de>
 <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de>
 <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
 <alpine.DEB.2.02.1301281737210.10432@kaball.uk.xensource.com>
 <510797FA02000078000BA4B8@nat28.tlf.novell.com>
 <20130129092652.GA9020@aepfle.de>
In-Reply-To: <20130129092652.GA9020@aepfle.de>
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
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%EU.CITRIX.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(199002)(377454001)(24454001)(51704002)(189002)(51444002)(56776001)(56816002)(5343655001)(63696002)(50986001)(20776003)(53806001)(16676001)(50466001)(51856001)(54356001)(76482001)(47976001)(4396001)(74662001)(47776003)(31966008)(54316002)(49866001)(44976002)(74502001)(5343635001)(77982001)(59766001)(33646001)(47736001)(6806001)(46102001)(23676001)(79102001)(47446002)(57646009)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB019;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0741C77572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0TFFIQo008727



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, January 29, 2013 4:27 AM
> To: Jan Beulich
> Cc: Stefano Stabellini; KY Srinivasan; Greg KH; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> 
> On Tue, Jan 29, Jan Beulich wrote:
> 
> > >>> On 28.01.13 at 18:44, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> wrote:
> > > I think that Olaf made his point very clear: a feature A should only be
> > > enabled if the corresponding flag A is set.
> > > In fact it seems to me that this patch is correct on its own merits,
> > > regardless of Xen does or does not.
> > >
> > > The Xen tools might or might not know whether a guest is going to be
> > > Linux, Windows, FreeBSD or whatever else people use nowadays.  Setting
> > > viridian=1 is the safe choice, given that it shouldn't create any
> > > issues: after all guests are supposed to check for feature flags before
> > > using them.
> > >
> > > If Xen is going to implement "Partition Reference Counter", it is also
> > > going to set the corresponding flag, so the guest OS (Windows, Linux,
> > > my pet OS) can check whether the feature is available and decide whether
> > > it wants to use it.
> >
> > While I agree in general, the specific case of the callback vector
> > seems a little more difficult: As KY says, there's no feature flag
> > for this (or perhaps more precisely for it being deliverable across
> > all CPUs), and hence there's both the problem of detection and
> > the problem of disambiguation (as otherwise both the Hyper-V
> > code and the Xen code in Linux could be trying to use the same
> > vector).
> 
> This is true, but belongs to that other thread about the interrupt
> vector. I agree that the detection in ms_hyperv_platform() should be
> extended, with a DMI check for example.
I want to explore extending ms_hyperv_platform() to detect if Hyper-V is being
emulated. Since Hyper-V is never going to emulate Xen, in my view this would be a
better option. 

 
> 
> The patch which started this thread is still valid because it enables
> feature B only if the featurebit for B is enabled.

Why would we need this if we have some other way of detecting that Hyper-V is being
emulated. Furthermore, I am not sure I understand the logic here. The fact that the hypervisor
supports PARTITION_REFERENCE_COUNTER does not necessarily mean that we should register
a clocksource based on that reference counter. It is true that that is the case on Hyper-V today.
However, on other hypervisors emulating Hyper-V, other standard clocksources maybe more
appropriate.

I agree with you that your patch is valid for making the Hyper-V code more robust but not for dealing
with general issue of Xen emulating Hyper-V. I will Ack your patch. 

Regards,

K. Y 
> 
> Olaf
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
