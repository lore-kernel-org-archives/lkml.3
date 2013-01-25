Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab3AYUFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:05:51 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.23]:43249
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3AYUFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:05:48 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Topic: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
Thread-Index: AQHN+wFSTQzC7+pzaUi0ZNGfsVWqjphaPkYAgAAFEACAAACuUIAABjaAgAACDmCAACrSAIAAAGhw
Date: Fri, 25 Jan 2013 20:03:46 +0000
Message-ID: <2f4f2b37780440a99bb75a33efc3f3c6@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125165443.GA15833@aepfle.de>
 <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de>
 <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130125200000.GA9712@aepfle.de>
In-Reply-To: <20130125200000.GA9712@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.166]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(51704002)(189002)(199002)(24454001)(377454001)(4396001)(50986001)(51856001)(53806001)(6806001)(54316002)(49866001)(16676001)(47736001)(47976001)(44976002)(79102001)(46102001)(76482001)(56816002)(77982001)(59766001)(31966008)(63696002)(56776001)(23676001)(50466001)(20776003)(74502001)(54356001)(74662001)(33646001)(47776003)(47446002)(57646002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB014;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:;MX:3;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0737B96801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0PK5qAc022836



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, January 25, 2013 3:00 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; Greg KH; Jan Beulich (JBeulich@suse.com)
> Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
> 
> On Fri, Jan 25, KY Srinivasan wrote:
> 
> > Your current approach of using the "Partition Reference Counter"
> > feature bit is very fragile. Let us assume that future Windows guests
> > depend on this feature; Xen would certainly emulate this to have a
> > "good" emulation of Hyper-V and we are back to square one.
> 
> If Xen starts to emulate the "Partition Reference Counter" feature,
> wouldnt it also advertise this feature?

Yes; it has to - if it expects the Windows guests to use it. This would be
no different than the other features that Xen emulates and advertises.

K. Y
 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
