Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab3CSO42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:56:28 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:27766
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932126Ab3CSO4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:56:23 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371I936eI542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
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
Subject: RE: [PATCH V2 2/3] Drivers: hv: balloon: Support 2M page
 allocations for ballooning
Thread-Topic: [PATCH V2 2/3] Drivers: hv: balloon: Support 2M page
 allocations for ballooning
Thread-Index: AQHOJBZNDxGyL1SarE+eyzA96WZzlpitGM4AgAAAblA=
Date: Tue, 19 Mar 2013 14:53:57 +0000
Message-ID: <27dcec9842584d5f8e162e8e25d9e0a9@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363639873-1576-1-git-send-email-kys@microsoft.com>
 <1363639898-1615-1-git-send-email-kys@microsoft.com>
 <1363639898-1615-2-git-send-email-kys@microsoft.com>
 <20130319144608.GJ7869@dhcp22.suse.cz>
In-Reply-To: <20130319144608.GJ7869@dhcp22.suse.cz>
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
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(189002)(13464002)(24454001)(51704002)(377454001)(377424002)(5343635001)(6806001)(77982001)(50986001)(33646001)(53806001)(20776003)(47776003)(76482001)(47736001)(49866001)(31966008)(5343655001)(54356001)(47446002)(74502001)(74662001)(56816002)(50466001)(44976002)(46102001)(23726001)(63696002)(65816001)(47976001)(4396001)(69226001)(56776001)(79102001)(59766001)(66066001)(46406002)(16676001)(51856001)(80022001)(54316002)(15202345001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB035;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0790FB1F33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michal Hocko [mailto:mhocko@suse.cz]
> Sent: Tuesday, March 19, 2013 10:46 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; hannes@cmpxchg.org; yinghan@google.com
> Subject: Re: [PATCH V2 2/3] Drivers: hv: balloon: Support 2M page allocations for
> ballooning
> 
> On Mon 18-03-13 13:51:37, K. Y. Srinivasan wrote:
> > On Hyper-V it will be very efficient to use 2M allocations in the guest as this
> > makes the ballooning protocol with the host that much more efficient. Hyper-V
> > uses page ranges (start pfn : number of pages) to specify memory being moved
> > around and with 2M pages this encoding can be very efficient. However, when
> > memory is returned to the guest, the host does not guarantee any granularity.
> > To deal with this issue, split the page soon after a successful 2M allocation
> > so that this memory can potentially be freed as 4K pages.
> 
> How many pages are requested usually?

This depends entirely on how many pages the guest has, the pressure reported by the guest and
the overall memory demand as perceived by the host. On idling guests that have been configured with
several Giga bytes of memory, I have seen several Giga bytes being ballooned out of the guest as soon
as new VMs are started or pressure goes up in an existing VM. In these cases, if 2M allocations succeed,
the ballooning operation can be done very efficiently.
> 
> > If 2M allocations fail, we revert to 4K allocations.
> >
> > In this version of the patch, based on the feedback from Michal Hocko
> > <mhocko@suse.cz>, I have added some additional commentary to the patch
> > description.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> I am not going to ack the patch because I am still not entirely
> convinced that big allocations are worth it. But that is up to you and
> hyper-V users.

As I said, Hyper-V has chosen 2M unit as the unit that will be most efficient in moving memory
around. All I am doing is making Linux participate in this protocol just as efficiently as Windows 
guests do.

Regards,

K. Y
> 
> > ---
> >  drivers/hv/hv_balloon.c |   18 ++++++++++++++++--
> >  1 files changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> > index 2cf7d4e..71655b4 100644
> > --- a/drivers/hv/hv_balloon.c
> > +++ b/drivers/hv/hv_balloon.c
> > @@ -997,6 +997,14 @@ static int  alloc_balloon_pages(struct
> hv_dynmem_device *dm, int num_pages,
> >
> >  		dm->num_pages_ballooned += alloc_unit;
> >
> > +		/*
> > +		 * If we allocatted 2M pages; split them so we
> > +		 * can free them in any order we get.
> > +		 */
> > +
> > +		if (alloc_unit != 1)
> > +			split_page(pg, get_order(alloc_unit << PAGE_SHIFT));
> > +
> >  		bl_resp->range_count++;
> >  		bl_resp->range_array[i].finfo.start_page =
> >  			page_to_pfn(pg);
> 
> I would suggest also using __GFP_NO_KSWAPD (or basically use
> GFP_TRANSHUGE for alloc_unit>0) for the allocation to be as least
> disruptive as possible.
> 
> > @@ -1023,9 +1031,10 @@ static void balloon_up(struct work_struct *dummy)
> >
> >
> >  	/*
> > -	 * Currently, we only support 4k allocations.
> > +	 * We will attempt 2M allocations. However, if we fail to
> > +	 * allocate 2M chunks, we will go back to 4k allocations.
> >  	 */
> > -	alloc_unit = 1;
> > +	alloc_unit = 512;
> >
> >  	while (!done) {
> >  		bl_resp = (struct dm_balloon_response *)send_buffer;
> > @@ -1041,6 +1050,11 @@ static void balloon_up(struct work_struct *dummy)
> >  						bl_resp, alloc_unit,
> >  						 &alloc_error);
> >
> 
> You should handle alloc_balloon_pages returns 0 && !alloc_error which
> happens when num_pages < alloc_unit.
> 
> > +		if ((alloc_error) && (alloc_unit != 1)) {
> > +			alloc_unit = 1;
> > +			continue;
> > +		}
> > +
> >  		if ((alloc_error) || (num_ballooned == num_pages)) {
> >  			bl_resp->more_pages = 0;
> >  			done = true;
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


