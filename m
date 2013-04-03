Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355Ab3DCCak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:30:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51692 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761280Ab3DCCai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:30:38 -0400
Date: Tue, 02 Apr 2013 22:30:36 -0400 (EDT)
Message-Id: <20130402.223036.1483788180825619960.davem@davemloft.net>
To: alan@signal11.us
Cc: werner@almesberger.net, netdev@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-zigbee-devel] [PATCH 1/6] mac802154: Immediately retry
 sending failed packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <515B9318.8090101@signal11.us>
References: <515B8D09.9050304@signal11.us>
	<20130402.220315.1782012687105065631.davem@davemloft.net>
	<515B9318.8090101@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 02 Apr 2013 19:30:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Tue, 02 Apr 2013 22:25:28 -0400

> The workqueue in mac802154 is only needed because the current mac802154
> xmit() function is designed to be blocking and synchronous.
> 
> Prior to my patch (#3/6), that very same workqueue would actually queue
> up packets (without bound). That's what my patch fixes.
> 
> The workqueue in mac802154 also serializes the access to the device for
> other functions like setting the channel, ensuring that in the driver
> code, one doesn't have to mutex everything. I'm not sure if that's the
> "right" way to do it, but that's the way it was when I got here.

This is entirely duplicating existing facilities.

Your desire to allow blockability during xmit() on the basis of mutual
exclusion is not well founded.
