Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab3AYRli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:41:38 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.30]:27785
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab3AYRlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:41:32 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Topic: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Index: AQHN+wFSTQzC7+pzaUi0ZNGfsVWqjphaPkYAgAAFEACAAACuUIAABjaAgAACDmA=
Date: Fri, 25 Jan 2013 17:39:22 +0000
Message-ID: <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125165443.GA15833@aepfle.de>
 <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de>
In-Reply-To: <20130125171923.GA19306@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(199002)(377454001)(24454001)(189002)(51704002)(16676001)(49866001)(47736001)(51856001)(56776001)(50466001)(50986001)(79102001)(47976001)(33646001)(54356001)(54316002)(63696002)(56816002)(74502001)(76482001)(53806001)(23676001)(6806001)(20776003)(77982001)(46102001)(44976002)(59766001)(47446002)(4396001)(31966008)(47776003)(74662001)(57646002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB028;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0737B96801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0PHfoCP022102



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, January 25, 2013 12:19 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; Greg KH; Jan Beulich (JBeulich@suse.com)
> Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> 
> On Fri, Jan 25, KY Srinivasan wrote:
> 
> > My fear is that there is no guarantee that Xen would not emulate this
> > feature in the spirit of making Hyper-V emulation "more" complete.
> > Since all this problem is because Xen thinks it is running a viridian
> > domain (when in fact it is running Linux), I felt we should explore
> > why the viridian tag got set for a Linux VM. If we can fix that we
> > would have a solution that does not depend upon assuming that Xen
> > would not emulate a particular Hyper-V feature.
> 
> In my opinion this logic is backwards. A host provides a set of
> functionality/features to a given guest, no matter what runs inside the
> guest. And the guest can query the feature list and configure itself
> accordingly. In this specific case the guest finds feature A (the cpuid
> result) and expects that feature B (a clock source) is present as well,
> even if feature B has its very own availability flag.

I would agree with you in the abstract but not in this specific case. First,
the current Hyper-V code in Linux verifies that the underlying hypervisor is
Hyper-V and proceeds to setup state that is needed to run Linux on Hyper-V.
If Xen were not emulating Hyper-V, we would not have any issue here. However,
Xen does emulate Hyper-V and it is emulating Hyper-V not to run Linux, but to run
enlightened Windows (making Windows think it is running on Hyper-V). We have a 
mechanism in place for controlling this Hyper-V emulation in Xen - the viridian flag.
In my view, ensuring that this flag is not set for a non -Windows guest is the only safe
approach to dealing with this issue. Your current approach of using the "Partition Reference
Counter" feature bit is very fragile. Let us assume that future Windows guests depend on this
feature; Xen would certainly emulate this to have a "good" emulation of Hyper-V and we are
back to square one.

Regards,

K. Y
> 
> Maybe I miss your point.
> 
> Olaf
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
