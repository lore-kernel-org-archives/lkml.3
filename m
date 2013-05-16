Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab3EPKQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:16:43 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:24586
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750713Ab3EPKQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:16:41 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 0/6] Drivers: hv/scsi: Implement multi-channel support
Thread-Topic: [PATCH 0/6] Drivers: hv/scsi: Implement multi-channel support
Thread-Index: AQHOUbNEL1Jm1Ed7PUiGCltR9iXn55kHMFCAgABoyCA=
Date: Thu, 16 May 2013 10:15:57 +0000
Message-ID: <31aae5e3bf764ae7a4458d18452aab9c@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <20130516040009.GA16728@kroah.com>
In-Reply-To: <20130516040009.GA16728@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454002)(51704005)(189002)(13464003)(199002)(377454002)(53806001)(6806003)(74366001)(31966008)(47446002)(51856001)(56816002)(54356001)(50466002)(74876001)(44976003)(47736001)(66066001)(81542001)(49866001)(4396001)(65816001)(74502001)(74316001)(74706001)(80022001)(46102001)(47976001)(79102001)(56776001)(74662001)(16676001)(23726002)(54316002)(47776003)(50986001)(20776003)(81342001)(69226001)(59766001)(76482001)(33646001)(77982001)(46406003)(63696002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB023;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0848C1A6AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, May 16, 2013 12:00 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 0/6] Drivers: hv/scsi: Implement multi-channel support
> 
> On Wed, May 15, 2013 at 03:02:00PM -0700, K. Y. Srinivasan wrote:
> > This patch-set implements multi-channel support for Hyper-V devices. Also
> > support for synthetic Fiber Channel device is included. The first two
> > patches in the series are the foundational pieces for the remaining patches.
> >
> > James, once Greg accepts the first two patches, you can consider the scsi
> > patches.
> 
> I have no objection for these first two patches to go through James's
> tree, I'll go add my ack to them.  That should make it easier for
> everyone involved.

Thanks Greg.

Regards,

K. Y
 


