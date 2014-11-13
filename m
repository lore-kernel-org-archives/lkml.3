Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaKMTte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:49:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58871 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933146AbaKMTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:49:32 -0500
Date: Thu, 13 Nov 2014 14:49:28 -0500 (EST)
Message-Id: <20141113.144928.993194909814299360.davem@davemloft.net>
To: mkubecek@suse.cz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us
Subject: Re: [PATCH net-next v2] net: generic dev_disable_lro() stacked
 device handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141113065450.1645FA0BEF@unicorn.suse.cz>
References: <20141111.214752.266800170368088905.davem@davemloft.net>
	<20141113065450.1645FA0BEF@unicorn.suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Nov 2014 11:49:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Thu, 13 Nov 2014 07:54:50 +0100 (CET)

> Large receive offloading is known to cause problems if received packets
> are passed to other host. Therefore the kernel disables it by calling
> dev_disable_lro() whenever a network device is enslaved in a bridge or
> forwarding is enabled for it (or globally). For virtual devices we need
> to disable LRO on the underlying physical device (which is actually
> receiving the packets).
> 
> Current dev_disable_lro() code handles this  propagation for a vlan
> (including 802.1ad nested vlan), macvlan or a vlan on top of a macvlan.
> It doesn't handle other stacked devices and their combinations, in
> particular propagation from a bond to its slaves which often causes
> problems in virtualization setups.
> 
> As we now have generic data structures describing the upper-lower device
> relationship, dev_disable_lro() can be generalized to disable LRO also
> for all lower devices (if any) once it is disabled for the device
> itself.
> 
> For bonding and teaming devices, it is necessary to disable LRO not only
> on current slaves at the moment when dev_disable_lro() is called but
> also on any slave (port) added later.
> 
> v2: use lower device links for all devices (including vlan and macvlan)
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks a lot.
