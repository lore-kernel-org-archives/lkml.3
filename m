Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677Ab3BIOKD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:10:03 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.32]:12049
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab3BIOKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:10:00 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Thread-Index: AQHOBHqGdmZWmCfA3EOMQRE9yVbBN5htMw+AgARdQ6A=
Date: Sat, 9 Feb 2013 14:09:45 +0000
Message-ID: <a94ffddd99f54864b9d548b31c5c39df@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1360164359-12273-1-git-send-email-kys@microsoft.com>
 <20130206191313.GA1470@kroah.com>
In-Reply-To: <20130206191313.GA1470@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(199002)(189002)(51704002)(13464002)(24454001)(47736001)(16676001)(23726001)(74502001)(59766001)(80022001)(51856001)(44976002)(63696002)(49866001)(54316002)(50986001)(74662001)(46102001)(56816002)(65816001)(47776003)(31966008)(66066001)(33646001)(5343655001)(20776003)(53806001)(77982001)(47976001)(76482001)(79102001)(50466001)(4396001)(54356001)(56776001)(46406002)(47446002)(6806001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB040;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07521929C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, February 06, 2013 2:13 PM
> To: KY Srinivasan
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com;
> tglx@linutronix.de; hpa@zytor.com; JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> delivering VMBUS interrupts
> 
> On Wed, Feb 06, 2013 at 07:25:59AM -0800, K. Y. Srinivasan wrote:
> > Use the infrastructure for delivering VMBUS interrupts using a
> > special vector. With this patch, we can now properly handle
> > the VMBUS interrupts that can be delivered on any CPU. Also,
> > turn on interrupt load balancing as well.
> >
> > This patch requires the infrastructure that was implemented in the patch:
> > X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
> >
> 
> Because of the dependancy, this should go through the x86 tree as well:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 

Peter,

Let me know if I need to make any adjustments to these patches. These set of
patches are key for Linux scalability on Hyper-V.

Regards,

K. Y

