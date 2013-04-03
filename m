Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743Ab3DCB4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:56:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51282 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab3DCB4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:56:31 -0400
Date: Tue, 02 Apr 2013 21:56:25 -0400 (EDT)
Message-Id: <20130402.215625.1555279506975246223.davem@davemloft.net>
To: alan@signal11.us
Cc: werner@almesberger.net, netdev@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-zigbee-devel] [PATCH 1/6] mac802154: Immediately retry
 sending failed packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <515B84EB.8020006@signal11.us>
References: <515B4D79.40805@signal11.us>
	<20130402231319.GD28141@ws>
	<515B84EB.8020006@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 02 Apr 2013 18:56:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Tue, 02 Apr 2013 21:24:59 -0400

> I like it for a couple of reasons.
> 1. Most supported devices have only single packet output buffer, so
> blocking in the driver is the most straight-forward way to handle it.
> The alternative is to make each driver have a workqueue for xmit() (to
> lift the blocking out from atomic context). This makes each driver simpler.
> 
> 2. All of the flow control can be handled one time in the mac802154 layer.

We have a perfectly working flow control mechanism in the generic
networking queuing layer.  Please use it instead of inventing things.

If it does not meet your needs, fix it, rather than go off and do
your own thing.  That way everyone benfits, not just you.
