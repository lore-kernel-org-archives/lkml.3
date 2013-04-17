Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3DQQbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:31:13 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:23458
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752314Ab3DQQbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:31:11 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jan Beulich <JBeulich@suse.com>, "Michael S. Tsirkin" <mst@redhat.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Topic: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Index: AQHOAnJoFJQhzmD3TUKsF9dq+4jlRZjabzYAgABndUD///hDAIAAE9LQ///2YoCAABF4gP//9RUAAANR4jAAAPGWAAAA7LQA
Date: Wed, 17 Apr 2013 16:28:36 +0000
Message-ID: <76ae3b714d064ae392332615bfd872d5@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417124852.GD6801@redhat.com>
 <3b76ebfdb240419aa601309465a4c154@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417132523.GB26157@redhat.com>
 <9ffd83acf6ac4a7bb5d51c95c96e6f50@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417134850.GB26335@redhat.com>
 <0cd5cde572734ea786664accc1a40bea@SN2PR03MB061.namprd03.prod.outlook.com>
 <516EE0FE02000078000CE422@nat28.tlf.novell.com>
In-Reply-To: <516EE0FE02000078000CE422@nat28.tlf.novell.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(51704004)(377454001)(199002)(189002)(24454001)(76482001)(81542001)(65816001)(53806001)(56816002)(54356001)(54316002)(63696002)(77982001)(56776001)(46102001)(16676001)(51856001)(59766001)(4396001)(50986001)(50466001)(49866001)(47976001)(47776003)(5343635001)(79102001)(20776003)(31966008)(69226001)(74502001)(66066001)(80022001)(47446002)(81342001)(47736001)(74662001)(23726002)(33646001)(46406003)(6806003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB010;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 081904387B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Wednesday, April 17, 2013 11:51 AM
> To: KY Srinivasan; Michael S. Tsirkin
> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> 
> >>> On 17.04.13 at 17:31, KY Srinivasan <kys@microsoft.com> wrote:
> > If Xen were to change where it would not unconditionally emulate Hyper-V, I
> > would not be opposed to taking
> > this check out.
> 
> But it doesn't do this unconditionally, only upon admin request.

>From the discussion we had a couple of months ago, the default setting was to enable
Hyper-V emulation for all guests. If this is not the case, we ought to be able to drop this.
However, I think it is not reasonable to add additional checks (in addition to hypervisor check)
to customize the run-time in the guest for the specific Hypervisor.

Regards,

K. Y
> 
> Jan
> 
> 


