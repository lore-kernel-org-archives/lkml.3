Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab3ARBPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:15:47 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.23]:43304
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872Ab3ARBPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:15:46 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 20:15:46 EST
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I154dI542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Thread-Topic: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Thread-Index: AQHN9RC9go3bU96kuUWjPmeK6MjrpZhOOgiAgAALYdA=
Date: Fri, 18 Jan 2013 01:07:42 +0000
Message-ID: <7bde61b74da845149c4fd1f65d802693@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com>
 <20130118002347.GB3959@kroah.com>
In-Reply-To: <20130118002347.GB3959@kroah.com>
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
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(24454001)(51704002)(54534002)(13464002)(76482001)(59766001)(54356001)(56776001)(33646001)(53806001)(4396001)(54316002)(50466001)(74662001)(31966008)(44976002)(47776002)(74502001)(47446002)(47976001)(46406002)(79102001)(50986001)(49866001)(77982001)(56816002)(47736001)(5343635001)(6806001)(46102001)(16676001)(51856001)(23726001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB035;H:TK5EX14HUBC103.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0730093765
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, January 17, 2013 7:24 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de
> Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
> hypervisor interrupts
> 
> On Thu, Jan 17, 2013 at 04:39:37PM -0800, K. Y. Srinivasan wrote:
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> No changelog entry describing the patch?

I sent the wrong version of the patch by mistake. I will send the one with the changelog shortly.
> 
> > ---
> >  arch/x86/include/asm/irq_vectors.h |    2 +
> >  arch/x86/include/asm/mshyperv.h    |    4 +++
> >  arch/x86/kernel/cpu/mshyperv.c     |   39
> ++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/entry_32.S         |    7 ++++++
> >  arch/x86/kernel/entry_64.S         |    5 ++++
> >  5 files changed, 57 insertions(+), 0 deletions(-)
> 
> This patch needs to go through the x86 maintainers, which you didn't
> include all of on the To: line, any reason why?
I have included Thomas as this was an interrupt related patch. I will however include x86 maintainers
when I resend with the change log.

Thank you,

K. Y
 


