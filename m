Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3HAAkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:40:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37036 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3HAAki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:40:38 -0400
Date: Wed, 31 Jul 2013 17:40:37 -0700 (PDT)
Message-Id: <20130731.174037.1794753574143053874.davem@davemloft.net>
To: linus.luessing@web.de
Cc: bridge@lists.linux-foundation.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, amwang@redhat.com,
        linux@baker-net.org.uk
Subject: Re: [PATCHv3] bridge: disable snooping if there is no querier
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375311980-25575-1-git-send-email-linus.luessing@web.de>
References: <20130730.161035.1646022729333223847.davem@davemloft.net>
	<1375311980-25575-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 31 Jul 2013 17:40:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Thu,  1 Aug 2013 01:06:20 +0200

> If there is no querier on a link then we won't get periodic reports and
> therefore won't be able to learn about multicast listeners behind ports,
> potentially leading to lost multicast packets, especially for multicast
> listeners that joined before the creation of the bridge.
> 
> These lost multicast packets can appear since c5c23260594
> ("bridge: Add multicast_querier toggle and disable queries by default")
> in particular.
> 
> With this patch we are flooding multicast packets if our querier is
> disabled and if we didn't detect any other querier.
> 
> A grace period of the Maximum Response Delay of the querier is added to
> give multicast responses enough time to arrive and to be learned from
> before disabling the flooding behaviour again.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Looks good, applied, thanks Linus.

