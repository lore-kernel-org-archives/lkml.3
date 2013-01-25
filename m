Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab3AYRFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:05:23 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.32]:33881
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab3AYRFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:05:19 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BLUPR03MB049;H:BLUPR03MB050.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Topic: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Index: AQHN+wFSTQzC7+pzaUi0ZNGfsVWqjphaPkYAgAAFEACAAACuUA==
Date: Fri, 25 Jan 2013 17:04:09 +0000
Message-ID: <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125165443.GA15833@aepfle.de>
In-Reply-To: <20130125165443.GA15833@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BLUPR03MB049.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(199002)(377454001)(24454001)(189002)(51704002)(16676001)(5343655001)(49866001)(47736001)(51856001)(50466001)(50986001)(56776001)(47976001)(79102001)(54356001)(54316002)(63696002)(56816002)(74502001)(76482001)(53806001)(23676001)(33646001)(6806001)(20776003)(77982001)(46102001)(44976002)(59766001)(47446002)(4396001)(31966008)(47776003)(74662001)(57646002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB020;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0737B96801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0PH5Onn021925



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, January 25, 2013 11:55 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; Greg KH
> Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> 
> On Fri, Jan 25, KY Srinivasan wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: Olaf Hering [mailto:olaf@aepfle.de]
> > > Sent: Friday, January 25, 2013 8:37 AM
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Olaf Hering; stable@kernel.org; KY Srinivasan; Greg KH
> > > Subject: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> > >
> > > Enable hyperv_clocksource only if its advertised as a feature.
> > > XenServer 6 returns the signature which is checked in
> > > ms_hyperv_platform(), but it does not offer all features. Currently the
> > > clocksource is enabled unconditionally in ms_hyperv_init_platform(), and
> > > the result is a hanging guest.
> > >
> > > Hyper-V spec Bit 1 indicates the availability of Partition Reference
> > > Counter.  Register the clocksource only if this bit is set.
> > >
> > > The guest in question prints this in dmesg:
> > >  [    0.000000] Hypervisor detected: Microsoft HyperV
> > >  [    0.000000] HyperV: features 0x70, hints 0x0
> > >
> > > This bug can be reproduced easily be setting 'viridian=1' in a HVM domU
> > > .cfg file. A workaround without this patch is to boot the HVM guest with
> > > 'clocksource=jiffies'.
> >
> > I am curious why you are setting viridian=1 for a Linux HVM guest. Initially when
> > I did the Hyper-V emulation work on Xen, this configuration flag would be set
> only
> > for Windows guests since the idea was to run the "enlightened" Windows on
> Xen.
> > While the current Xen emulation code does not emulate "Partition Reference
> Counter"
> > there is no guarantee that Xen would not do this in the future. Perhaps dealing
> with this issue
> > by identifying the guest (via the viridian domain or not) may be a safer
> approach?
> 
> I'm not sure if XenServer does that per default, but I used the
> viridian= flag to reproduce the report.
> If Xen starts to emulate the "Partition Reference Counter" it should
> also advertise this emulation with the feature flag. Are you saying that
> checking for features is not the right approach?

My fear is that there is no guarantee that Xen would not emulate this feature
in the spirit of making Hyper-V emulation "more" complete. Since all this problem is
because Xen thinks it is running a viridian domain (when in fact it is running Linux), I felt we
should explore why the viridian tag got set for a Linux VM. If we can fix that we would have
a solution that does not depend upon assuming that Xen would not emulate a particular Hyper-V
feature.

K. Y 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
