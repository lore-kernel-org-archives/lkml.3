Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3GXVMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:12:09 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:9830
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab3GXVMG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:12:06 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(24454002)(377454003)(479174003)(199002)(13464003)(189002)(51704005)(46102001)(76576001)(76796001)(49866001)(74502001)(79102001)(33646001)(56816003)(74662001)(47736001)(81342001)(47446002)(76786001)(4396001)(83072001)(81542001)(59766001)(76482001)(74316001)(51856001)(83322001)(19580405001)(74366001)(74706001)(54316002)(54356001)(77982001)(63696002)(19580395003)(53806001)(80022001)(77096001)(50986001)(31966008)(66066001)(47976001)(16406001)(69226001)(56776001)(74876001)(65816001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB052;H:BLUPR03MB050.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Dave Hansen <dave@sr71.net>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>
Subject: RE: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory
 "in context"
Thread-Topic: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory
 "in context"
Thread-Index: AQHOiK+yQ/v5brutgUmjn/xbdgT575l0UVWAgAAAcvA=
Date: Wed, 24 Jul 2013 21:10:03 +0000
Message-ID: <330d6f16f1a341dbaf5028797bcad305@BLUPR03MB050.namprd03.prod.outlook.com>
References: <1374701355-30799-1-git-send-email-kys@microsoft.com>
 <1374701399-30842-1-git-send-email-kys@microsoft.com>
 <1374701399-30842-2-git-send-email-kys@microsoft.com>
 <51F0414F.3060600@sr71.net>
In-Reply-To: <51F0414F.3060600@sr71.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0917DFAC67
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: BLUPR03MB052.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CMPXCHG.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SR71.NET$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dave Hansen [mailto:dave@sr71.net]
> Sent: Wednesday, July 24, 2013 5:04 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; mhocko@suse.cz; hannes@cmpxchg.org;
> yinghan@google.com
> Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in
> context"
> 
> On 07/24/2013 02:29 PM, K. Y. Srinivasan wrote:
> >  		/*
> > -		 * Wait for the memory block to be onlined.
> > -		 * Since the hot add has succeeded, it is ok to
> > -		 * proceed even if the pages in the hot added region
> > -		 * have not been "onlined" within the allowed time.
> > +		 * Before proceeding to hot add the next segment,
> > +		 * online the segment that has been hot added.
> >  		 */
> > -		wait_for_completion_timeout(&dm_device.ol_waitevent,
> 5*HZ);
> > +		online_memory_block(start_pfn);
> 
> Ahhhhh....  You've got a timeout in the code in order to tell the
> hypervisor that you were successfully able to add the memory?  The
> userspace addition code probably wasn't running within this timeout
> period.  right?

As I have always said, the onlining would not occur within a specified amount
of time (under some conditions). The timeout here is to ensure that we are able 
to online the memory before attempting to hot-add more memory. With the ability
to online memory from within the kernel, we don't need this timeout and the code is
much more predictable.

Regards,

K. Y



