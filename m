Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064Ab3CSVl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:41:57 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:12556
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933741Ab3CSVlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:41:55 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I936eI542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Michal Hocko <mhocko@suse.cz>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>
Subject: RE: [PATCH V2 1/3]  mm: Export split_page()
Thread-Topic: [PATCH V2 1/3]  mm: Export split_page()
Thread-Index: AQHOJBZDnHfz24Hs5E6pg/ppxgF85pitD6GAgAB8eHA=
Date: Tue, 19 Mar 2013 21:39:46 +0000
Message-ID: <3c47db9f28b944f985e8050d41334193@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363639873-1576-1-git-send-email-kys@microsoft.com>
 <1363639898-1615-1-git-send-email-kys@microsoft.com>
 <20130319141317.GI7869@dhcp22.suse.cz>
In-Reply-To: <20130319141317.GI7869@dhcp22.suse.cz>
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
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CMPXCHG.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377424002)(377454001)(51704002)(13464002)(189002)(199002)(24454001)(5343655001)(15202345001)(47446002)(46406002)(54316002)(33646001)(65816001)(69226001)(80022001)(6806001)(23726001)(47776003)(47976001)(74662001)(4396001)(46102001)(31966008)(56776001)(50466001)(5343635001)(50986001)(47736001)(54356001)(51856001)(20776003)(74502001)(79102001)(76482001)(77982001)(59766001)(53806001)(66066001)(49866001)(56816002)(16676001)(63696002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB018;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0790FB1F33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michal Hocko [mailto:mhocko@suse.cz]
> Sent: Tuesday, March 19, 2013 10:13 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; hannes@cmpxchg.org; yinghan@google.com
> Subject: Re: [PATCH V2 1/3] mm: Export split_page()
> 
> On Mon 18-03-13 13:51:36, K. Y. Srinivasan wrote:
> > This symbol would be used in the Hyper-V balloon driver to support 2M
> > allocations.
> >
> > In this version of the patch, based on feedback from Michal Hocko
> > <mhocko@suse.cz>, I have updated the patch description.
> 
> I guess this part is not necessary ;)
> 
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.cz>

Greg,

Would you be taking this patch through your tree?

Regards,

K. Y
> 
> > ---
> >  mm/page_alloc.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 6cacfee..7e0ead6 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1404,6 +1404,7 @@ void split_page(struct page *page, unsigned int order)
> >  	for (i = 1; i < (1 << order); i++)
> >  		set_page_refcounted(page + i);
> >  }
> > +EXPORT_SYMBOL_GPL(split_page);
> >
> >  static int __isolate_free_page(struct page *page, unsigned int order)
> >  {
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> Michal Hocko
> SUSE Labs
> 


