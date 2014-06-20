Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079AbaFTQKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:10:45 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.25]:38170 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbaFTQKn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:10:43 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>, Olaf Hering <olaf@aepfle.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Topic: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Index: AQHPjB+WQKkwvkUXekGWoyJ+QmEz5Zt55UEAgAAEPICAADyUMA==
Date: Fri, 20 Jun 2014 16:09:49 +0000
Message-ID: <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de> <20140620051213.GA9960@kroah.com>
In-Reply-To: <20140620051213.GA9960@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(377454003)(189002)(199002)(51704005)(24454002)(164054003)(21056001)(77982001)(79102001)(64706001)(76482001)(33646001)(47776003)(20776003)(92566001)(97756001)(97736001)(46102001)(46406003)(85326001)(2009001)(31966008)(81542001)(2656002)(74662001)(99396002)(74502001)(87936001)(86612001)(80022001)(66066001)(83072002)(85852003)(106116001)(6806004)(76176999)(50986999)(77096999)(54356999)(50466002)(81342001)(68736004)(23726002)(83322001)(19580405001)(4396001)(19580395003)(84676001)(44976005)(24736002)(106276001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB596;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 024847EE92
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Friday, June 20, 2014 1:12 AM
> To: Olaf Hering
> Cc: Haiyang Zhang; netdev@vger.kernel.org; jasowang@redhat.com;
> driverdev-devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net
> Subject: Re: [PATCH net-next] hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event
> 
> On Fri, Jun 20, 2014 at 06:57:04AM +0200, Olaf Hering wrote:
> > On Thu, Jun 19, Haiyang Zhang wrote:
> >
> > > The RNDIS_STATUS_NETWORK_CHANGE event is received after the Hyper-V
> host
> > > sleep or hibernation. We refresh network at this time.
> >
> > > +	char *argv[] = { "/etc/init.d/network", "restart", NULL };
> >
> > What happens if that file does not exist? Dead network in the guest?
> > I tend to think if a VM with PV drivers goes to sleep it has to go
> > through the whole suspend/resume cycle, very much like the "LID
> closed"
> > event. So I think this and the other fbdev change that is floating
> > around is wrong.
> 
> Ah, and what about systems with no /etc/init.d/ at all (like
> systemd-based ones)?  You can't have a kernel driver ask userspace to
> restart all networking connections, that seems really wrong.

Olaf and Greg,

Thanks for your reviews. 
On Server Hyper-V, the host sleep/hibernation is not supported. So this 
event won't happen on most deployment of Hyper-V.

On Client Hyper-V (e.g. Windows 8+ on a laptop), the host sleep/hibernation
is supported. If the laptop is moved to another network during sleep, we 
previously need to manually refresh the network (network restart) to renew 
DHCP. With this patch, the network is refreshed on the event.

This command ("/etc/init.d/network restart") exists on our supported distros
currently. We will also look into some better ways to refresh the network for
the distros without this command. I have tried setting IF_OPER_DORMANT then 
IF_OPER_UP, but not working. I will look into the suspend/resume cycle as
well.

Thanks,
- Haiyang


