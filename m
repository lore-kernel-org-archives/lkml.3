Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbaGQMyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:54:45 -0400
Received: from mx0.aculab.com ([213.249.233.131]:45656 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756598AbaGQMyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:54:43 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mugunthan V N'" <mugunthanvnm@ti.com>,
        David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [net-next PATCH v2 0/3] Broadcast/Multicast rate limit via
 Ethtool Coalesce
Thread-Topic: [net-next PATCH v2 0/3] Broadcast/Multicast rate limit via
 Ethtool Coalesce
Thread-Index: AQHPoYY9UvFwPwDojUudrRwQY6wBHpuj9NlQ
Date: Thu, 17 Jul 2014 12:53:41 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D172768B0@AcuExch.aculab.com>
References: <1404890050-4020-1-git-send-email-mugunthanvnm@ti.com>
 <20140709.164420.157865201153845876.davem@davemloft.net>
 <53C76990.3000304@ti.com>
In-Reply-To: <53C76990.3000304@ti.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mugunthan V N
> On Thursday 10 July 2014 05:14 AM, David Miller wrote:
> > From: Mugunthan V N <mugunthanvnm@ti.com>
> > Date: Wed, 9 Jul 2014 12:44:07 +0530
> >
> >> A system/cpu can be loaded by a hacker with flooding of broadcast or
> >> multicast packets, to prevent this some Ethernet controllers like CPSW
> >> provide a mechanism to limit the broadcast/multicast packet rate via
> >> hardware limiters. This patch series enables this feature via
> >> Ethtool Coalesce.
> > This is pretty bogus if you ask me.
> >
> > What is the difference from accepting a high rate of unicast packets?
> > I say it is no different.
> >
> > Therefore, this feature makes no sense to me at all.
> 
> Any packet storm can cause an endpoint some issues. Typically packet
> storms will cause the system CPU to thrash resulting is very low system
> performance.
> 
> Unicast storms only target a single destination end station, it can be
> easily mitigated by the host adding a blocking entry in the LUT for each
> aggressor.
> 
> Broadcast and multicast target multiple end stations, or an entire
> network, not only can it cause CPU thrashing, it can result in loss of
> other broadcast and multicast services. The rate limiting feature allow
> the broadcast and or multicast traffic to be dropped if the rates are
> too high. This eliminates the CPU thrashing issue. It also allows the
> system to analyze the aggressors and block them for future transgressions.

Rate limiting multicast traffic will definitely cause the loss of multicast
services.

My experience of broadcast storms is that many of the ethernet switches
(probably especially the cheap ones) end up using a much slower software?
path for broadcasts. In a broadcast storm they start discarding normal
traffic - to point where a single ssh session becomes unusable.
This is true even when isolated from the storm by a 10M hub.

Broadcast storms are probably mostly caused by network topology issues.
Especially is switches are sending traffic to 'all ports' while resetting
the spanning tree tables.

	David




