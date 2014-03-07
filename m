Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaCGPvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:51:48 -0500
Received: from [207.46.163.212] ([207.46.163.212]:8783 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752019AbaCGPvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:51:47 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
 of pfns we can handle
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the
 number of pfns we can handle
Thread-Index: AQHPOc2oQ3eOFqZTbkO5srnGB9wLTZrVR3eAgAAMhPCAAAVqAIAATzpQ
Date: Fri, 7 Mar 2014 15:50:31 +0000
Message-ID: <5cb13ca16d8b42f098cd057b4b391a88@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394176508-1439-1-git-send-email-kys@microsoft.com>
 <20140307081627.GC29018@mwanda>
 <9037d4ef9c174fb280f00f22912c3d12@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140307092038.GG4774@mwanda>
In-Reply-To: <20140307092038.GG4774@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.216.134.63]
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(129404003)(189002)(24454002)(199002)(13464003)(377454003)(51704005)(81686001)(81816001)(79102001)(74316001)(76576001)(66066001)(95666003)(65816001)(80022001)(76786001)(81542001)(19580405001)(74706001)(83322001)(80976001)(63696002)(76796001)(2656002)(93136001)(83072002)(74662001)(97186001)(81342001)(74502001)(85852003)(33646001)(50986001)(19580395003)(90146001)(69226001)(4396001)(53806001)(86362001)(93516002)(77982001)(51856001)(46102001)(47446002)(59766001)(76482001)(54316002)(87266001)(56816005)(47976001)(74876001)(94946001)(56776001)(87936001)(31966008)(74366001)(92566001)(85306002)(95416001)(49866001)(86612001)(54356001)(94316002)(47736001)(97336001)(29543002)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB597;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:117.216.134.63;FPR:BAFE4572.9CF39FE9.737121B7.C4A1A9C1.202A6;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, March 7, 2014 2:51 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
> of pfns we can handle
> 
> On Fri, Mar 07, 2014 at 09:07:42AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > > Sent: Friday, March 7, 2014 1:46 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com
> > > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on
> > > the number of pfns we can handle
> > >
> > > On Thu, Mar 06, 2014 at 11:15:08PM -0800, K. Y. Srinivasan wrote:
> > > > Increase the maximum number of pfns we can handle is a single
> > > > vmbus
> > > packet.
> > >                                                     ^^ in
> >
> > Thanks Dan. I am traveling in India and it shows. I have already sent a
> corrected patch.
> >
> 
> Yeah.  I saw that.  Thanks.
> 
> > > >
> > >
> > > What are the user visible effects of this patch?
> > The current code will drop these packets that have more PFNs than the
> limit.
> > Upping the limit will mitigate this problem.
> >
> 
> Meanwhile, the revised patch says that it is not a bugfix.  It sort of sounds like
> upping the limit does improve performance for some people?
> 
> I am confused now.

With the current network code this condition cannot occur since we neither support scatter/gather I/O
nor segmentation offload. I have submitted patches that enable these features for our network driver.
Once TSO is turned on, the network stack can send packets that may need more than the current limit of
PFNs in a packet.

Hope this helps,

K. Y
> 
> regards,
> dan carpenter

