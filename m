Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaFWSYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:24:06 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.87]:3888 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbaFWSYD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:24:03 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Topic: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Index: AQHPjB+WQKkwvkUXekGWoyJ+QmEz5Zt55UEAgAAEPICAADyUMIAEqgwA///ZfgCAAH5ugP//tltAgAB/PID//6n3QA==
Date: Mon, 23 Jun 2014 18:23:34 +0000
Message-ID: <7fd6ae806627412da08b51200230b0ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de> <20140620051213.GA9960@kroah.com>
 <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623080242.GA16924@aepfle.de>
 <06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623131723.GA7026@aepfle.de>
 <5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623162911.GA20715@kroah.com>
In-Reply-To: <20140623162911.GA20715@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(189002)(24454002)(51704005)(199002)(377454003)(164054003)(92566001)(81342001)(97756001)(2009001)(84676001)(97736001)(81542001)(86612001)(79102001)(68736004)(54356999)(19580405001)(74662001)(74502001)(99396002)(31966008)(33646001)(50986999)(21056001)(106466001)(77096999)(85326001)(47776003)(20776003)(85852003)(77982001)(44976005)(19580395003)(83072002)(83322001)(6806004)(2656002)(87936001)(64706001)(93886003)(76176999)(46102001)(46406003)(106116001)(50466002)(66066001)(80022001)(4396001)(23726002)(76482001)(24736002)(106276001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB597;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, June 23, 2014 12:29 PM
> To: Haiyang Zhang
> Cc: Olaf Hering; netdev@vger.kernel.org; jasowang@redhat.com; driverdev-
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net
> Subject: Re: [PATCH net-next] hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event
> 
> On Mon, Jun 23, 2014 at 04:09:59PM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Olaf Hering [mailto:olaf@aepfle.de]
> > > Sent: Monday, June 23, 2014 9:17 AM
> > > To: Haiyang Zhang
> > > Cc: Greg KH; netdev@vger.kernel.org; jasowang@redhat.com; driverdev-
> > > devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> > > davem@davemloft.net
> > > Subject: Re: [PATCH net-next] hyperv: Add handler for
> > > RNDIS_STATUS_NETWORK_CHANGE event
> > >
> > > On Mon, Jun 23, Haiyang Zhang wrote:
> > >
> > > > > I think its reasonable to expect guest config changes on this
> > > > > new kind of host. Would a link-down/link-up event work? I'm sure
> > > > > it will, there is enough code floating around in the guests
> > > > > which handles cable
> > > unplug.
> > > >
> > > > Do you mean netif_carrier_off() / netif_carrier_on()? They are
> > > > already called in the code before this patch, but DHCP renew is
> > > > not triggered by them.
> > >
> > > I do not know how to simulate a cable unplug. The point is that
> > > calling /etc/init.d/network will fail, at least in SLES12.
> > > Maybe some sort of "DHCP refresh required" event is required?
> > > Maybe the DHCP clients need to renew on cable unplug?
> > > No idea what the solution to the issue really is.
> >
> > Yes, it will be great if there is such a "DHCP refresh required"
> > event, or DHCP clients are triggered when netif_carrier_off() then
> netif_carrier_on().
> >
> > I have tried some possibilities, like IF_OPER_DORMANT then IF_OPER_UP
> > with
> > netdev_state_change() etc. but not able to trigger DHCP review. I will
> > look at this further...
> >
> > So, what's the equivalent or similar command to "network restart" on
> > SLES12? Could you update the command line for the usermodehelper when
> > porting this patch to SLES 12?
> 
> Given that this change will fail on all future distro releases, and almost all of
> the community distros today, I don't see how this is acceptable at all.  Nor
> would it be any better if you switch to a systemd command line script as well.
> You should just work like any other network device works in this situation when
> it comes to enabling/disabling the device.  Worse case, just tear down the
> whole network device at suspend time, and recreate it at resume.

I will look into these options.

Thanks,
- Haiyang


