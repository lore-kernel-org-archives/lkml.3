Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3GQRTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:19:37 -0400
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:58619
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755159Ab3GQRTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:19:35 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 0
X-BigFish: PS0(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh17ej9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(13464003)(377454003)(199002)(189002)(24454002)(51704005)(76576001)(74316001)(49866001)(51856001)(54356001)(47446002)(65816001)(69226001)(76482001)(76786001)(79102001)(16406001)(80022001)(74876001)(59766001)(46102001)(81342001)(63696002)(4396001)(54316002)(74366001)(53806001)(74662001)(77096001)(76796001)(74502001)(33646001)(77982001)(74706001)(47736001)(81542001)(56816003)(50986001)(83072001)(56776001)(31966008)(47976001)(24736002)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::13;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation
 code for util services
Thread-Topic: [PATCH 1/1] Drivers: hv: util: Fix a bug in version
 negotiation code for util services
Thread-Index: AQHOd0UKrHFKHj6YF0aFkGvHNZstGZlo5XpAgABNuQCAAAEKEA==
Date: Wed, 17 Jul 2013 17:18:35 +0000
Message-ID: <468e59c446934055840d657144da3b11@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1372786290-12641-1-git-send-email-kys@microsoft.com>
 <39fe1ebc4d4d45488f30612bd942f3e1@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130717171252.GA15698@kroah.com>
In-Reply-To: <20130717171252.GA15698@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::13]
x-forefront-prvs: 0910AAF391
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(51704005)(13464003)(377454003)(24454002)(46406003)(76576001)(83072001)(47736001)(81342001)(33646001)(44976005)(54316002)(54356001)(50986001)(56776001)(74316001)(16676001)(6806004)(56816003)(77096001)(81542001)(59766001)(65816001)(53806001)(4396001)(47976001)(49866001)(23726002)(80022001)(76786001)(74706001)(74366001)(76482001)(63696002)(74502001)(76796001)(74876001)(47776003)(77982001)(74662001)(31966008)(69226001)(20776003)(50466002)(47446002)(79102001)(51856001)(46102001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB012;H:TK5EX14HUBC106.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0910AAF391
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, July 17, 2013 1:13 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation code for
> util services
> 
> On Wed, Jul 17, 2013 at 12:35:42PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > > Sent: Tuesday, July 02, 2013 1:32 PM
> > > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com
> > > Cc: KY Srinivasan
> > > Subject: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation code for
> util
> > > services
> > >
> > > The current code picked the highest version advertised by the host. WS2012
> R2
> > > has implemented a protocol version for KVP that is not compatible with prior
> > > protocol versions of KVP. Fix the bug in the current code by explicitly
> specifying
> > > the protocol version that the guest can support.
> >
> > Greg,
> >
> > Do you want me to resubmit this patch.
> 
> No, it's not lost, I'm just working on 3.11 patches at the moment, I'll
> push this one to 3.12 later.

Thanks Greg. Since you checked in other patches that I had sent after I had sent this one, I was thinking perhaps this got lost.

Regards,

K. Y 


