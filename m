Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab3CLQPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:15:40 -0400
Received: from mail-bn1op0152.outbound.protection.outlook.com ([207.46.163.152]:46422
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932235Ab3CLQPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:15:38 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add
 functionality
Thread-Topic: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add
 functionality
Thread-Index: AQHOHEbCmE27OfNng0mCdOHOBfNQ/ZihYA1AgADewQCAAAIBIA==
Date: Tue, 12 Mar 2013 16:14:57 +0000
Message-ID: <875032eae91a4f26a50bf4cf30a6e558@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1362780945-9796-1-git-send-email-kys@microsoft.com>
 <1362780973-9837-1-git-send-email-kys@microsoft.com>
 <1362780973-9837-5-git-send-email-kys@microsoft.com>
 <924741bf41f14975af2f8f52b3251730@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130312160722.GA21109@kroah.com>
In-Reply-To: <20130312160722.GA21109@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.116]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(377454001)(189002)(24454001)(13464002)(51704002)(49866001)(50466001)(80022001)(59766001)(76482001)(51856001)(4396001)(16676001)(46102001)(74662001)(44976002)(54316002)(23726001)(65816001)(63696002)(66066001)(5343635001)(5343655001)(56776001)(31966008)(6806001)(46406002)(56816002)(74502001)(77982001)(69226001)(20776003)(50986001)(47446002)(33646001)(79102001)(47776003)(53806001)(47976001)(54356001)(47736001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB013;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 078310077C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, March 12, 2013 12:07 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add functionality
> 
> On Tue, Mar 12, 2013 at 02:54:23AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > > Sent: Friday, March 08, 2013 5:16 PM
> > > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com
> > > Cc: KY Srinivasan
> > > Subject: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add functionality
> > >
> > > Implement the memory hot-add functionality. With this, Linux guests can fully
> > > participate in the Dynamic Memory protocol implemented in the Windows
> hosts.
> >
> > Greg,
> >
> > I forgot to modify the Kconfig file to include the new dependency of the
> balloon driver on
> > MEMORY_HOTPLUG. Should I send a separate patch for  Kconfig, or resend this
> one patch
> > with the Kconfig changes folded in. Or, do you want me to resend the whole
> series.
> 
> Just resend the whole series, I'll drop this one.

Will do.

K. Y
> 
> greg k-h
> 


