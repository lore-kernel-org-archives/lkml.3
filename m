Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3DUWdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 18:33:20 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:19309
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752543Ab3DUWdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 18:33:18 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>, Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
Thread-Topic: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
Thread-Index: AQHOKja3d+L5xLojvEOFQMScGCXgxJjeVZqAgAMSewA=
Date: Sun, 21 Apr 2013 22:32:45 +0000
Message-ID: <d4d63db63a53466bb568363bb4c30054@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
 <20130419232419.GA8900@kroah.com>
In-Reply-To: <20130419232419.GA8900@kroah.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(51704004)(13464002)(24454001)(199002)(377454001)(77982001)(80022001)(81542001)(46102001)(74662001)(69226001)(31966008)(33646001)(51856001)(56816002)(74502001)(81342001)(47976001)(16676001)(53806001)(54316002)(63696002)(54356001)(59766001)(20776003)(49866001)(46406003)(47736001)(79102001)(47776003)(65816001)(76482001)(4396001)(66066001)(50986001)(50466001)(47446002)(23726002)(56776001)(6806003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB001;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0823A5777B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, April 19, 2013 7:24 PM
> To: Olaf Hering
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/3] Tools: hv: fix warnings in hv_vss_daemon
> 
> On Tue, Mar 26, 2013 at 04:28:27PM +0100, Olaf Hering wrote:
> > This change fixes a few compile errors:
> >
> > hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> > hv_vss_daemon.c:64:15: warning: unknown escape sequence '\/'
> > hv_vss_daemon.c: In function 'vss_operate':
> > hv_vss_daemon.c:66: warning: 'return' with no value, in function returning
> non-void
> > hv_vss_daemon.c: In function 'main':
> > hv_vss_daemon.c:130: warning: ignoring return value of 'daemon', declared
> with attribute warn_unused_result
> > hv_vss_daemon.c: In function 'vss_operate':
> > hv_vss_daemon.c:47: warning: 'fs_op' may be used uninitialized in this function
> >
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> For some reason, all of your hv tools patches ended up in my spam
> filter.  KY, can you resend me any that I didn't apply, and you have
> tested?

Greg,

I forwarded some patches from Olaf (I think Olaf is on vacation) that have not been applied. I had acked all these patches when Olaf sent them out initially.

Regards,

K. Y
> 
> thanks,
> 
> greg k-h
> 


