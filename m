Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3GNCDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 22:03:34 -0400
Received: from mail-bn1lp0156.outbound.protection.outlook.com ([207.46.163.156]:28009
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752041Ab3GNCDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 22:03:32 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I542I1432I4015Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(13464003)(377454003)(199002)(164054003)(189002)(24454002)(51704005)(76576001)(79102001)(69226001)(51856001)(54356001)(65816001)(47446002)(74316001)(76482001)(49866001)(74876001)(59766001)(83072001)(46102001)(63696002)(4396001)(76786001)(74662001)(66066001)(80022001)(74366001)(16406001)(76796001)(81342001)(74502001)(77096001)(33646001)(74706001)(81542001)(47976001)(47736001)(50986001)(56816003)(77982001)(31966008)(56776001)(54316002)(53806001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:66.235.54.97;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Stable <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
Thread-Topic: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
Thread-Index: AQHOfwXMySuJZjEOX0aRTZWPqcisBplhe3+AgAANHNCAAAKBAIAB41nw
Date: Sun, 14 Jul 2013 02:03:19 +0000
Message-ID: <70ab1b4d20a74217b3c4f1ba3da21ef9@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1373637292-25855-1-git-send-email-kys@microsoft.com>
 <1373637375-25936-1-git-send-email-kys@microsoft.com>
 <20130712201703.GB7729@decadent.org.uk>
 <a53af503f3934a6bb8442e97de0d5ddc@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130712211256.GC7729@decadent.org.uk>
In-Reply-To: <20130712211256.GC7729@decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.54.97]
x-forefront-prvs: 0907F58A24
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454002)(377454003)(199002)(189002)(51704005)(164054003)(13464003)(23726002)(77096001)(63696002)(47736001)(4396001)(47776003)(66066001)(65816001)(47976001)(49866001)(50986001)(56816003)(76796001)(20776003)(80022001)(76576001)(74316001)(76786001)(69226001)(50466002)(59766001)(79102001)(54356001)(16676001)(46406003)(77982001)(6806004)(31966008)(74876001)(74366001)(51856001)(81342001)(74502001)(47446002)(33646001)(74662001)(76482001)(81542001)(46102001)(74706001)(53806001)(56776001)(44976005)(83072001)(54316002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB017;H:TK5EX14HUBC106.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0907F58A24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Friday, July 12, 2013 5:13 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; Stable
> Subject: Re: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
> 
> On Fri, Jul 12, 2013 at 09:07:19PM +0000, KY Srinivasan wrote:
> [...]
> > > Well now it might look like a bug that you don't test the result
> > > of wait_for_completion_timeout().  Maybe update the comment to
> > > explain why it's OK to continue anyway?
> >
> > I put in the comment in the patch explaining why it is ok to continue.
> [...]
> 
> But that is not nearly as easy to see as the comment that is
> already *in the code* which your patch isn't updating.

Agreed; I will resend the patch with comments added.

Thanks,

K. Y
> 
> Ben.
> 
> --
> Ben Hutchings
> We get into the habit of living before acquiring the habit of thinking.
>                                                               - Albert Camus
> 


