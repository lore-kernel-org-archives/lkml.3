Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3EQN4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:56:16 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:37548
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753197Ab3EQN4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:56:15 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Stable <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] Staging: hv: Fix a bug in get_vp_index()
Thread-Topic: [PATCH 1/1] Staging: hv: Fix a bug in get_vp_index()
Thread-Index: AQHOTZEdDXk7JTC0sEilCx0gh5DBUJkIdviAgAD54DA=
Date: Fri, 17 May 2013 13:54:45 +0000
Message-ID: <2942f0a12f204ef1ba29395b23ddd2db@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1368200821-20964-1-git-send-email-kys@microsoft.com>
 <20130516225943.GA12820@kroah.com>
In-Reply-To: <20130516225943.GA12820@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704005)(377454002)(24454002)(13464003)(199002)(189002)(81542001)(47776003)(79102001)(63696002)(74876001)(20776003)(23726002)(74366001)(65816001)(80022001)(74706001)(69226001)(50466002)(56816002)(76482001)(33646001)(54316002)(77982001)(59766001)(6806003)(54356001)(74662001)(66066001)(74316001)(74502001)(47446002)(56776001)(50986001)(16676001)(4396001)(31966008)(47976001)(53806001)(49866001)(46102001)(51856001)(81342001)(44976003)(47736001)(46406003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB014;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 08497C3D99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, May 16, 2013 7:00 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; Stable
> Subject: Re: [PATCH 1/1] Staging: hv: Fix a bug in get_vp_index()
> 
> On Fri, May 10, 2013 at 08:47:01AM -0700, K. Y. Srinivasan wrote:
> > Linux' notion of cpuid is different from the Host's notion of CPUID. In the
> > call to bind the channel interrupts, we should use the host's notion of
> > CPU Ids. Fix this bug.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Cc: Stable <stable@vger.kernel.org> (V3.9)
> > ---
> >  drivers/hv/channel_mgmt.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Why do you have "Staging" in the Subject:?  This isn't a staging driver
> anymore, right?

Sorry, my mistake; do you want me to resend this.

Regards,

K. Y
> 
> greg k-h
> 


