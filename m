Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaFWUGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:06:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34743 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:06:09 -0400
Date: Mon, 23 Jun 2014 13:06:08 -0700 (PDT)
Message-Id: <20140623.130608.499310171187852386.davem@davemloft.net>
To: olaf@aepfle.de
Cc: haiyangz@microsoft.com, greg@kroah.com, netdev@vger.kernel.org,
        jasowang@redhat.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140623131723.GA7026@aepfle.de>
References: <20140623080242.GA16924@aepfle.de>
	<06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<20140623131723.GA7026@aepfle.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Jun 2014 13:06:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>
Date: Mon, 23 Jun 2014 15:17:23 +0200

> On Mon, Jun 23, Haiyang Zhang wrote:
> 
>> > I think its reasonable to expect guest config changes on this new kind
>> > of host. Would a link-down/link-up event work? I'm sure it will, there
>> > is enough code floating around in the guests which handles cable unplug.
>> 
>> Do you mean netif_carrier_off() / netif_carrier_on()? They are already 
>> called in the code before this patch, but DHCP renew is not triggered by
>> them.
> 
> I do not know how to simulate a cable unplug. The point is that calling
> /etc/init.d/network will fail, at least in SLES12.
> Maybe some sort of "DHCP refresh required" event is required?
> Maybe the DHCP clients need to renew on cable unplug?
> No idea what the solution to the issue really is.

What's in the driver right now is definitely not it, and I want this
network restart code removed immediately.
