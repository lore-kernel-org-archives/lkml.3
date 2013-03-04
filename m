Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3CDSNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:13:16 -0500
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:46565
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757694Ab3CDSNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:13:14 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 1/1] mm: Export split_page().
Thread-Topic: [PATCH 1/1] mm: Export split_page().
Thread-Index: AQHOGHvemlZPo/qvy0iTzgXsO5BJg5iUySmAgAAASkCAAASPAIAAAE8ggAD1ywCAAA0eYA==
Date: Mon, 4 Mar 2013 18:10:56 +0000
Message-ID: <7c3247b488834be19a155df40c61523f@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1362364075-14564-1-git-send-email-kys@microsoft.com>
 <20130304020747.GA8265@kroah.com>
 <3a362e994ab64efda79ae3c80342db95@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130304022508.GA8638@kroah.com>
 <b863089d05f442fb9dfc90faa158a001@SN2PR03MB061.namprd03.prod.outlook.com>
 <5134D476.3040302@linux.vnet.ibm.com>
In-Reply-To: <5134D476.3040302@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.217]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX.VNET.IBM.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(479174001)(51704002)(377454001)(13464002)(199002)(24454001)(54356001)(33646001)(66066001)(6806001)(79102001)(50466001)(59766001)(53806001)(65816001)(31966008)(69226001)(49866001)(80022001)(51856001)(56776001)(46102001)(16676001)(74502001)(47736001)(46406002)(76482001)(47446002)(23726001)(56816002)(63696002)(47976001)(77982001)(50986001)(47776003)(20776003)(5343655001)(4396001)(44976002)(74662001)(54316002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB039;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0775716B9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dave Hansen [mailto:dave@linux.vnet.ibm.com]
> Sent: Monday, March 04, 2013 12:06 PM
> To: KY Srinivasan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; andi@firstfloor.org; akpm@linux-
> foundation.org; linux-mm@kvack.org
> Subject: Re: [PATCH 1/1] mm: Export split_page().
> 
> On 03/03/2013 06:36 PM, KY Srinivasan wrote:
> >> I guess the most obvious question about exporting this symbol is, "Why
> >> doesn't any of the other hypervisor balloon drivers need this?  What is
> >> so special about hyper-v?"
> >
> > The balloon protocol that Hyper-V has specified is designed around the ability
> to
> > move 2M pages. While the protocol can handle 4k allocations, it is going to be
> very chatty
> > with 4K allocations.
> 
> What does "very chatty" mean?  Do you think that there will be a
> noticeable performance difference ballooning 2M pages vs 4k?

The balloon protocol that Hyper-V host specified allows you to specify page
ranges - start_pfn: num_pfn. With 2M pages the number of messages that need
to be exchanges is significantly fewer than with 4K page allocations.
> 
> > Furthermore, the Memory Balancer on the host is also designed to work
> > best with memory moving around in 2M chunks. While I have not seen the
> code on the Windows
> > host that does this memory balancing, looking at how Windows guests behave
> in this environment,
> > (relative to Linux) I have to assume that the 2M allocations that Windows
> guests do are a big part of
> > the difference we see.
> 
> You've been talking about differences.  Could you elaborate on what the
> differences in behavior are that you are trying to rectify here?

As I look at how smoothly memory is balanced on Windows guests with changing load conditions
in the guest relative to what I see with Linux, I see Linux taking more time to reach the steady state
during a balancing operation.  I will experiment with 2M allocations and report if this issue is addressed.

> 
> >> Or can those other drivers also need/use it as well, and they were just
> >> too chicken to be asking for the export?  :)
> >
> > The 2M balloon allocations would make sense if the host is designed
> accordingly.
> 
> How does the guest decide which size pages to allocate?  It seems like a
> relatively bad idea to be inflating the balloon with 2M pages from the
> guest in the case where the guest is under memory pressure _and_
> fragmented.

I want to start with 2M allocations and if they fail, fall back onto lower order allocations.
As I said, the host can support 4K allocations and that will be the final fallback position
(that is what I have currently implemented). If the guest memory is fragmented, then
obviously we will go in for lower order allocations.

Regards,

K. Y 


