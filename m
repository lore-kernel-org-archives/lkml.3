Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaKZUhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:37:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50538 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaKZUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:37:39 -0500
Date: Wed, 26 Nov 2014 15:37:36 -0500 (EST)
Message-Id: <20141126.153736.1815789848350571029.davem@davemloft.net>
To: jasowang@redhat.com
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, vyasevic@redhat.com
Subject: Re: [PATCH net-next] macvlan: delay the header check for dodgy
 packets into lower device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416993674-11177-1-git-send-email-jasowang@redhat.com>
References: <1416993674-11177-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Nov 2014 12:37:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 26 Nov 2014 17:21:14 +0800

> We do header check twice for a dodgy packet. One is done before
> macvlan_start_xmit(), another is done before lower device's
> ndo_start_xmit(). The first one seems redundant so this patch tries to
> delay header check until a packet reaches its lower device (or macvtap)
> through always enabling NETIF_F_GSO_ROBUST for macvlan device.
> 
> Cc: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Hmmm, it's the idea that if we have a dodgy packet, we want to
notice that as early as possible in the packet processing path?
