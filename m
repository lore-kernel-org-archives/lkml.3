Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3LBQQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:16:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51481 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3LBQQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:16:02 -0500
Date: Mon, 02 Dec 2013 11:16:00 -0500 (EST)
Message-Id: <20131202.111600.1622488165507147936.davem@davemloft.net>
To: David.Laight@ACULAB.COM
Cc: puzman@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pch_gbe: Fix transmit queue management
From: David Miller <davem@davemloft.net>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B744F@saturn3.aculab.com>
References: <1385631882-12827-2-git-send-email-puzman@gmail.com>
	<20131129.164229.2292905485668904870.davem@davemloft.net>
	<AE90C24D6B3A694183C094C60CF0A2F6026B744F@saturn3.aculab.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 02 Dec 2013 08:16:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David Laight" <David.Laight@ACULAB.COM>
Date: Mon, 2 Dec 2013 10:04:49 -0000

> I know you like ethernet drivers to work this way, but requiring enough
> descriptors for a maximally fragmented packet requires a difficult
> calculation and will cause the tx queue to be stopped unnecessarily.
 ...
> Isn't there also a new skb structure that allows lists of fragments?
> That might need even more descriptors for a worst case transmit.

Fragment lists are not to be found in the transmit function of the
driver.  Any such SKBs will be linearized or similar first.  We do
want to support them in some capacity in the future, but right now
we don't.

And here we're not talking about a USB driver, so using the rather
extreme example of the USB segmentation restrictions is not really
appropriate.

This is a pretty standard ethernet driver, which can use a one to
one correspondance between the segmentation count of the SKB and
the number of TX descriptors that will be used.

There is a large precedence for doing things this way and in this
particular case it's straightforward.
