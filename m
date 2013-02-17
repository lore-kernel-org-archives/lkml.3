Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab3BQSv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:51:59 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.26]:54811
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab3BQSv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:51:57 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Thread-Index: AQHOBHqGdmZWmCfA3EOMQRE9yVbBN5htMw+AgAnGt4CAADNcoIAA1naAgAAC4FCAAB3VgIAAAUaAgAADhwCAAASIgIAGPgNAgAADrYCAAAdNoA==
Date: Sun, 17 Feb 2013 18:51:46 +0000
Message-ID: <663c5ef1750e4aa3922c38e897c4903a@SN2PR03MB061.namprd03.prod.outlook.com>
References: <20130206191313.GA1470@kroah.com> <511ADEB7.6080909@zytor.com>
 <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130213162211.GA21253@kroah.com>
 <c31482583b394bfcaa16b76a63c413fe@SN2PR03MB061.namprd03.prod.outlook.com>
 <511BD923.7000500@zytor.com> <20130213182349.GA4959@kroah.com>
 <511BDD2A.8020002@zytor.com> <20130213185239.GB16645@kroah.com>
 <bc26219c6d0e4a498912a8411c11f81c@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130217182519.GB8687@kroah.com>
In-Reply-To: <20130217182519.GB8687@kroah.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(479174001)(377454001)(13464002)(199002)(189002)(51704002)(24454001)(65816001)(76482001)(74662001)(74502001)(31966008)(47446002)(23726001)(46406002)(44976002)(6806001)(33646001)(16676001)(79102001)(46102001)(63696002)(56816002)(80022001)(56776001)(47776003)(20776003)(66066001)(59766001)(54356001)(77982001)(53806001)(47976001)(47736001)(54316002)(51856001)(50466001)(4396001)(50986001)(49866001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB009;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07607ED19A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Sunday, February 17, 2013 1:25 PM
> To: KY Srinivasan
> Cc: H. Peter Anvin; x86@kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> delivering VMBUS interrupts
> 
> On Sun, Feb 17, 2013 at 06:13:49PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Wednesday, February 13, 2013 1:53 PM
> > > To: H. Peter Anvin
> > > Cc: KY Srinivasan; x86@kernel.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com;
> bp@alien8.de
> > > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> > > delivering VMBUS interrupts
> > >
> > > On Wed, Feb 13, 2013 at 10:36:26AM -0800, H. Peter Anvin wrote:
> > > > On 02/13/2013 10:23 AM, Greg KH wrote:
> > > > > On Wed, Feb 13, 2013 at 10:19:15AM -0800, H. Peter Anvin wrote:
> > > > >> Sounds like we have the joy of a cross-tree dependency...
> > > > >
> > > > > Yeah, a mess.
> > > > >
> > > > > KY, how about I just wait until all of this gets merged with Linus for
> > > > > 3.9-rc1, and then you resend me the patches you have to take advantage
> > > > > of these new bits?  That makes it easy for everyone involved.
> > > > >
> > > >
> > > > The other option is you can pull tip:x86/hyperv from me... it has *only*
> > > > these changes.  I can then let you push them to Linus or I can push them
> > > > to Linus before you push your tree.
> > >
> > > Nah, I'll just wait, it's not that big of a deal here, it will all make
> > > it into 3.9-final eventually.
> >
> > Peter's check-ins are now in Linux-next. Should I send you the vmbus
> > patch that uses this infrastructure.
> 
> No one can base their tree on linux-next, so no.  Please wait for them
> to get into Linus's tree.
> 
> Or send them to me now, with the instructions to apply them after
> 3.9-rc1, and I will save them for that point in time.

Thanks Greg. Will do.

K. Y
> 
> thanks,
> 
> greg k-h
> 


