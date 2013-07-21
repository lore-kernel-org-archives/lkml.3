Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3GUOpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 10:45:49 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:50606 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519Ab3GUOps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 10:45:48 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jonas Gorski <jogo@openwrt.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH 1/2] arm: ixp4xx: set cohorent_dma_mask for ethernet platform devices
References: <1374315339-31469-1-git-send-email-jogo@openwrt.org>
	<1374315339-31469-2-git-send-email-jogo@openwrt.org>
Date: Sun, 21 Jul 2013 16:45:45 +0200
In-Reply-To: <1374315339-31469-2-git-send-email-jogo@openwrt.org> (Jonas
	Gorski's message of "Sat, 20 Jul 2013 12:15:38 +0200")
Message-ID: <m3ip04ezty.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas Gorski <jogo@openwrt.org> writes:

> ARM requires the cohorent_dma_mask set, so set it for the platform
> devices so that the ethernet driver has access to it.

I recognize the need to fix this issue and I appreciate your efforts,
but... I think this patch tries to make the driver functional again at
all costs and this a very bad idea. The IXP4xx Ethernet MACs are not
normal platform devices, they are in fact built-in CPU resources. The
platform device structs are only used to set parameters. What the patch
does is unneeded and IMHO harmful code duplication. It makes completely
no sense to set DMA masks in code for individual platforms as it's not
something platforms can decide, or *even should know of*. It's simply
a CPU attribute, a value that is shared by all IXP4xx CPUs and thus all
platforms and systems using it.

This is against the "line of code" count rules (or "rules").

Also the dev->dev.parent is IMHO a bad idea. The queue numbers and MAC
addresses are in no way "parents" of Ethernet controllers, and even if
they somehow were, I find it rather hard to believe they can have DMA
masks.

I think the previous patch (which sets the masks in one place, in
Ethernet driver code) was better, though not perfect.

My fault is I haven't fixed it yet. Will try to invent something.
-- 
Krzysztof Halasa
