Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab3BMAw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:52:57 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.31]:14411
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab3BMAwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:52:55 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Greg KH <gregkh@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>,
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
Thread-Index: AQHOBHqGdmZWmCfA3EOMQRE9yVbBN5htMw+AgAnGt4CAAAMOQIAAAUCAgAAAxGA=
Date: Wed, 13 Feb 2013 00:50:39 +0000
Message-ID: <508f13bedcb4478486c751a91ef8154b@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1360164359-12273-1-git-send-email-kys@microsoft.com>
 <20130206191313.GA1470@kroah.com> <511ADEB7.6080909@zytor.com>
 <23a161dbb5ce4a2b889a837a3cacfdca@SN2PR03MB061.namprd03.prod.outlook.com>
 <511AE253.7070209@zytor.com>
In-Reply-To: <511AE253.7070209@zytor.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(479174001)(377454001)(199002)(189002)(13464002)(24454001)(76482001)(79102001)(66066001)(54316002)(80022001)(65816001)(6806001)(46102001)(56776001)(50466001)(44976002)(4396001)(74662001)(77982001)(59766001)(49866001)(47736001)(47976001)(50986001)(31966008)(47446002)(51856001)(23726001)(46406002)(56816002)(63696002)(47776003)(33646001)(20776003)(54356001)(53806001)(16676001)(74502001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB019;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07562C22DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Tuesday, February 12, 2013 7:46 PM
> To: KY Srinivasan
> Cc: Greg KH; x86@kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> delivering VMBUS interrupts
> 
> On 02/12/2013 04:43 PM, KY Srinivasan wrote:
> >>
> >> This does not apply to v3.8-rc7 + the set of three vmbus patches for
> >> x86.  I take it there are additional dependencies -- K.Y., what do I
> >> need here?
> >
> > Do none of the earlier patches apply or just this patch. If none of them
> > apply, I could rebase all of them and resend them. Please let me know.
> >
> 
> The earlier (set of 3) patches apply just fine.

Apply them and I will rebase this patch and send it out.

Regards,

K. Y 
> 
> 	-hpa
> 
> 
> 


