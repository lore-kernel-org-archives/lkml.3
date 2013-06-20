Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161085Ab3FTVX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:23:59 -0400
Received: from stator.leun.net ([85.214.203.199]:45547 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150Ab3FTVX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:23:57 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2013 17:23:57 EDT
Date: Thu, 20 Jun 2013 23:17:13 +0200
From: Michael Leun <lkml20130126@newton.leun.net>
To: kaber@trash.net, shemminger@linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Missing iproute2 support for 802.1ad
Message-ID: <20130620231713.4f6a3c1f@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2013-04-19 12:04:31 GMT kaber@trash.net wrote:

> Add support for 802.1ad VLAN devices. This mainly consists of checking
> for
> ETH_P_8021AD in addition to ETH_P_8021Q in a couple of places and check
> offloading capabilities based on the used protocol.

> Configuration is done using "ip link":

> # ip link add link eth0 eth0.1000 \
> 	type vlan proto 802.1ad id 1000
> # ip link add link eth0.1000 eth0.1000.1000 \
>	type vlan proto 802.1q id 1000

I fear, that does not work:

lara:/home/ml # ip link add link eth0 eth0.1000 type vlan proto 802.1ad id 1000
vlan: what is "proto"?
Usage: ... vlan id VLANID [ FLAG-LIST ]
                          [ ingress-qos-map QOS-MAP ] [ egress-qos-map QOS-MAP ]
[...]

ip does not seem to know about proto. This does not  have changed in
git either.

I've seen there was an patch to add this around somewhen in 2011, but
it does not seem to have made it.

Or did I miss something?

-- 
MfG,

Michael Leun

