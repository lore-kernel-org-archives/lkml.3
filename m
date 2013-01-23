Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3AWQNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:13:52 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.29]:46178
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224Ab3AWQNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:13:50 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: RE: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Thread-Topic: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Thread-Index: AQHN9RC9go3bU96kuUWjPmeK6MjrpZhPEF4AgAAlFpCABr3pAIAAEGWAgAERMoCAAAUnYA==
Date: Wed, 23 Jan 2013 16:10:02 +0000
Message-ID: <707dcbb81d4b4693a4cce3cf8b3400e0@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com>
 <20130118131056.GA14550@pd.tnic>
 <794a590acf1a47408a87e95f095e6b1b@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130122222056.GC14503@phenom.dumpdata.com>
 <2bd8c994-3e70-413b-85de-caec46428b1e@email.android.com>
 <20130123153725.GJ3067@phenom.dumpdata.com>
In-Reply-To: <20130123153725.GJ3067@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.124.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOP.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ORACLE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704002)(13464002)(24454001)(74502001)(47776002)(44976002)(31966008)(51856001)(47446002)(74662001)(4396001)(46406002)(79102001)(46102001)(23726001)(77982001)(59766001)(56816002)(56776001)(53806001)(49866001)(33646001)(6806001)(54356001)(76482001)(50986001)(47976001)(54316002)(16676001)(47736001)(50466001)(6816006)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB013;H:TK5EX14HUBC102.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 073515755F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Wednesday, January 23, 2013 10:37 AM
> To: H. Peter Anvin
> Cc: KY Srinivasan; Borislav Petkov; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de; Ingo Molnar;
> jeremy@goop.org; Jan Beulich (JBeulich@suse.com)
> Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
> hypervisor interrupts
> 
> On Tue, Jan 22, 2013 at 05:19:37PM -0600, H. Peter Anvin wrote:
> > Yes, how about we rename this the hypervisor vector...
> 
> HYPERVISOR_CALLBACK_VECTOR ?

Thanks Konrad. I will update the patch and send it out shortly.

Regards,

K. Y
> 


