Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438Ab3EWR20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:28:26 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:35362
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757758Ab3EWR2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:28:24 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 0
X-BigFish: PS0(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d07h1d0ch1d2eh1d3fh17ej9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V1 1/7] Drivers: hv: vmbus: Implement multi-channel
 support
Thread-Topic: [PATCH V1 1/7] Drivers: hv: vmbus: Implement multi-channel
 support
Thread-Index: AQHOUiteQf4jxeL22k+ONbA1O5yKHJkH10+AgAs4D9A=
Date: Thu, 23 May 2013 17:26:14 +0000
Message-ID: <ad436d7ee6d64ddfb45f0b31e4e142fc@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
 <20130516140113.GB2629@kroah.com>
In-Reply-To: <20130516140113.GB2629@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:e0:2027:a1ed:29e5:3607:2062]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(51704005)(13464003)(377454002)(189002)(24454002)(69226001)(54316002)(76482001)(51856001)(74706001)(56776001)(50466002)(16676001)(49866001)(65816001)(47976001)(20776003)(74876001)(47776003)(4396001)(74366001)(74662001)(56816002)(80022001)(77982001)(74316001)(47736001)(53806001)(54356001)(81542001)(81342001)(79102001)(74502001)(6806003)(63696002)(47446002)(31966008)(46406003)(33646001)(59766001)(23726002)(46102001)(50986001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB009;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 085551F5A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, May 16, 2013 10:01 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V1 1/7] Drivers: hv: vmbus: Implement multi-channel
> support
> 
> On Thu, May 16, 2013 at 05:21:13AM -0700, K. Y. Srinivasan wrote:
> > Starting with Win8, the host supports multiple sub-channels for a given
> > device. As in the past, the initial channel offer specifies the device and
> > is associated with both the type and the instance GUIDs. For performance
> > critical devices, the host may support multiple sub-channels. The sub-channels
> > share the same type and instance GUID as the primary channel. The number of
> > sub-channels offerrred to the guest depends on the number of virtual CPUs
> > assigned to the guest. The guest can request the creation of these sub-
> channels
> > and once created and opened, the guest can distribute the traffic across all
> > the channels (the primary and the sub-channels). A request sent on a sub-
> channel
> > will have the response delivered on the same sub-channel.
> >
> > At channel (sub-channel) creation we bind the channel interrupt to a CPU and
> > with this sub-channel support we will be able to spread the interrupt load
> > of a given device across all available CPUs.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

James,

Please drop this patch-set. I fixed a couple of bugs in the vmbus support for multi-channel and I would need to resubmit this. Greg, I think it may make sense to first get the vmbus support checked in before I submit the storage related patches. There are networking related patches for multi-channel support that we will be submitting shortly. Getting the vmbus support in first would allow us to decouple network and storage patches. Greg, I will shortly submit the next version of the vmbus related patches for your consideration.

Regards,

K. Y

