Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3GGLtC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 07:49:02 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:33922 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab3GGLs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 07:48:58 -0400
Date: Sun, 7 Jul 2013 13:48:53 +0200
From: Jonas Gorski <jogo@openwrt.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: Re: Second ethernet on kirkwood does not work when probed through
 DT
Message-ID: <20130707134853.00003b9d@unknown>
In-Reply-To: <51D952D3.8070401@gmail.com>
References: <20130706215426.6e666d6af0dc6c9ea5fe32cd@openwrt.org>
	<51D88A8E.1060104@gmail.com>
	<20130706233912.00004044@unknown>
	<51D94884.4000204@gmail.com>
	<20130707132607.00007188@unknown>
	<51D952D3.8070401@gmail.com>
Organization: OpenWrt
X-Mailer: Claws Mail 3.9.0cvs12 (GTK+ 2.16.6; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Jul 2013 13:36:51 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> On 07/07/2013 01:26 PM, Jonas Gorski wrote:
> > On Sun, 07 Jul 2013 12:52:52 +0200
> > Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>  wrote:
> >> Anyway, can you please try to have both ports reg properties set
> >> to<0>, with nodes named ethernet0-port@0 and ethernet1-port@0,
> >> and the platform_device_alloc in mv643xx_eth modified?
> >
> > In addition I added a static counter for the allocated devs (to not
> > overwrite the pointers in port_platdev[]).
> 
> Ok, but that is not required to make it work, is it? IMHO we should
> honor what is passed by reg property, even it will be always zero
> for KW and the other Orion SoCs. Otherwise, we would implicitly put
> the numbering in the order of port nodes.

No, picking the next free "slot" should work, too - it was just the
easiest to fix the name for the alloc to what seems to be expected by
other parts.

> > That seems to work, as now eth1 comes up and works (successfully got a
> > IP through DHCP).
> 
> Ok, great. Will prepare a fix for mv643xx_eth on top of net-next. And
> an update of the kirkwood conversion patches.


Thanks,
Jonas
