Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3C1U1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:27:00 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:36527
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752039Ab3C1U06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:26:58 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I936eI542I1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Michal Hocko <mhocko@suse.cz>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "yinghan@google.com" <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>
Subject: RE: [PATCH V2 1/3]  mm: Export split_page()
Thread-Topic: [PATCH V2 1/3]  mm: Export split_page()
Thread-Index: AQHOJBZDnHfz24Hs5E6pg/ppxgF85pitD6GAgAB8eHCACOFsoIAFLlOA
Date: Thu, 28 Mar 2013 20:25:20 +0000
Message-ID: <2035005597ff4e27ad2eb82bedca6dcc@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363639873-1576-1-git-send-email-kys@microsoft.com>
 <1363639898-1615-1-git-send-email-kys@microsoft.com>
 <20130319141317.GI7869@dhcp22.suse.cz>
 <3c47db9f28b944f985e8050d41334193@SN2PR03MB061.namprd03.prod.outlook.com>
 <d81345b0dd4b4f509ef7206f58876afc@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <d81345b0dd4b4f509ef7206f58876afc@SN2PR03MB061.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CMPXCHG.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(199002)(189002)(377424002)(377454001)(24454001)(13464002)(56776001)(4396001)(54316002)(65816001)(15202345001)(63696002)(5343635001)(74502001)(47776003)(69226001)(44976002)(74662001)(56816002)(33646001)(6806001)(5343655001)(53806001)(66066001)(51856001)(47446002)(47736001)(80022001)(76482001)(20776003)(46102001)(47976001)(50986001)(79102001)(31966008)(49866001)(50466001)(16676001)(81342001)(77982001)(23726001)(59766001)(46406002)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB040;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0799B1B2D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> Sent: Monday, March 25, 2013 9:18 AM
> To: KY Srinivasan; Michal Hocko
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> linux-mm@kvack.org; andi@firstfloor.org; yinghan@google.com;
> hannes@cmpxchg.org; apw@canonical.com; devel@linuxdriverproject.org;
> akpm@linux-foundation.org; kamezawa.hiroyuki@gmail.com
> Subject: RE: [PATCH V2 1/3] mm: Export split_page()
> 
> 
> 
> > -----Original Message-----
> > From: devel [mailto:devel-bounces@linuxdriverproject.org] On Behalf Of KY
> > Srinivasan
> > Sent: Tuesday, March 19, 2013 5:40 PM
> > To: Michal Hocko
> > Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org;
> > linux-mm@kvack.org; andi@firstfloor.org; yinghan@google.com;
> > hannes@cmpxchg.org; apw@canonical.com; devel@linuxdriverproject.org;
> > akpm@linux-foundation.org; kamezawa.hiroyuki@gmail.com
> > Subject: RE: [PATCH V2 1/3] mm: Export split_page()
> >
> >
> >
> > > -----Original Message-----
> > > From: Michal Hocko [mailto:mhocko@suse.cz]
> > > Sent: Tuesday, March 19, 2013 10:13 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> > > kamezawa.hiroyuki@gmail.com; hannes@cmpxchg.org;
> yinghan@google.com
> > > Subject: Re: [PATCH V2 1/3] mm: Export split_page()
> > >
> > > On Mon 18-03-13 13:51:36, K. Y. Srinivasan wrote:
> > > > This symbol would be used in the Hyper-V balloon driver to support 2M
> > > > allocations.
> > > >
> > > > In this version of the patch, based on feedback from Michal Hocko
> > > > <mhocko@suse.cz>, I have updated the patch description.
> > >
> > > I guess this part is not necessary ;)
> > >
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > >
> > > Anyway
> > > Acked-by: Michal Hocko <mhocko@suse.cz>
> >
> > Greg,
> >
> > Would you be taking this patch through your tree?
> >
> > Regards,
> 
> Andrew,
> 
> Could you take this patch through your tree.
> 
> Regards,
> 
> K. Y

Greg,

Now that Andrew has checked in this patch, do you want me to resend the remaining two patches here.

Regards,

K. Y
> >
> > K. Y
> > >
> > > > ---
> > > >  mm/page_alloc.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index 6cacfee..7e0ead6 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -1404,6 +1404,7 @@ void split_page(struct page *page, unsigned int
> > order)
> > > >  	for (i = 1; i < (1 << order); i++)
> > > >  		set_page_refcounted(page + i);
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(split_page);
> > > >
> > > >  static int __isolate_free_page(struct page *page, unsigned int order)
> > > >  {
> > > > --
> > > > 1.7.4.1
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> > > --
> > > Michal Hocko
> > > SUSE Labs
> > >
> >
> >
> > _______________________________________________
> > devel mailing list
> > devel@linuxdriverproject.org
> > http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
> >


