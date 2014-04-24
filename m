Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaDXUm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:42:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34298 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaDXUmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:42:23 -0400
Date: Thu, 24 Apr 2014 16:42:21 -0400 (EDT)
Message-Id: <20140424.164221.1323078752352256197.davem@davemloft.net>
To: slash@ac.auone-net.jp
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] veth: Allow a peer to be up at creation time
From: David Miller <davem@davemloft.net>
In-Reply-To: <5358d1a70002df7a00005df100005bf3a00002a40d3b@amlmta037.auone-net.jp>
References: <5358d1a70002df7a00005df100005bf3a00002a40d3b@amlmta037.auone-net.jp>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Apr 2014 13:42:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kusanagi Kouichi <slash@ac.auone-net.jp>
Date: Thu, 24 Apr 2014 17:56:06 +0900

> Currently, a veth peer cannot be up at creation time.
> 
> # ip link add type veth peer up
> RTNETLINK answers: Transport endpoint is not connected
> 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>

I do not think this is sufficient.

There are many problems if you signal an error after we do:

	err = register_netdevice(dev);

For one thing, you aren't unregistering 'dev' in that error path,
furthermore, priv->peer points to the netdevice you are unregistering.

I think this cannot be done, what you aim to achieve, and we just
simply have to live with the current semantics.  Bring the device
up after you have created it.
