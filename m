Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3BELSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:18:12 -0500
Received: from na01-by2-obe.ptr.protection.outlook.com ([207.46.100.28]:44393
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3BELSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:18:07 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 2
X-BigFish: PS2(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz97h70kzz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BLUPR03MB050;H:BLUPR03MB050.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH  0/3] X86: Deliver Hyper-V interrupts on a seperate IDT
 vector 
Thread-Topic: [PATCH  0/3] X86: Deliver Hyper-V interrupts on a seperate IDT
 vector 
Thread-Index: AQHOAnJBGGxC5Ad/tUONpmGdgW0BEphrHpqA
Date: Tue, 5 Feb 2013 11:16:45 +0000
Message-ID: <d4f935c8e6e945c593f88639c6a7d199@BLUPR03MB050.namprd03.prod.outlook.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1359940910-32114-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.124.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BLUPR03MB050.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(51704002)(189002)(199002)(377454001)(53806001)(33646001)(4396001)(54316002)(1511001)(20776003)(6806001)(56776001)(51856001)(63696002)(47776003)(46406002)(23726001)(16676001)(56816002)(74502001)(46102001)(44976002)(31966008)(47736001)(47976001)(50986001)(49866001)(59766001)(50466001)(54356001)(79102001)(47446002)(76482001)(77982001)(74662001)(921001)(1121002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB035;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0748FF9A04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Sunday, February 03, 2013 8:22 PM
> To: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> JBeulich@suse.com; bp@alien8.de
> Cc: KY Srinivasan
> Subject: [PATCH 0/3] X86: Deliver Hyper-V interrupts on a seperate IDT vector
> 
> This patch-set implements the functionality to deliver Hyper-V VMBUS interrupts
> via
> a special IDT entry. Xen emulates Hyper-V and I have added code in this patch-set
> to
> properly manage this emulation when Linux is running on Hyper-V.
> 
> K. Y. Srinivasan (2):
>   X86: Add a check to catch Xen emulation of Hyper-V
>   X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
> 
> Olaf Hering (1):
>   x86: Hyper-V: register clocksource only if its advertised
> 
>  arch/x86/include/asm/irq_vectors.h |    4 +-
>  arch/x86/include/asm/mshyperv.h    |    4 ++
>  arch/x86/kernel/cpu/mshyperv.c     |   54
> +++++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/entry_32.S         |    9 +++++-
>  arch/x86/kernel/entry_64.S         |    7 ++++-
>  drivers/xen/events.c               |    7 ++--
>  6 files changed, 77 insertions(+), 8 deletions(-)
> 
> --
> 1.7.4.1
> 
> 

Peter,

I have addressed all the comments I have received on these patches. Let me know if there is
something you want me to address before these patches can be checked in.

Regards,

K. Y

