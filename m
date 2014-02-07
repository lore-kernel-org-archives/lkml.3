Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaBGDpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 22:45:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39703 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaBGDpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 22:45:04 -0500
Date: Thu, 06 Feb 2014 19:45:03 -0800 (PST)
Message-Id: <20140206.194503.1975815381717889886.davem@davemloft.net>
To: tj@kernel.org
Cc: yogeshgaur.83@gmail.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Suspected Copy Paste error in rtnl_bridge_notify
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140131114712.GB26148@htj.dyndns.org>
References: <CAG6enPwAfm8YDrGmEEitv_fHeF5rVVN2nXujh=u4kVy0sKx4ag@mail.gmail.com>
	<CAG6enPyV9bvYSwDrMp6X1LY6PXrmrP5MtjNk0N+7qs1LDY5pRg@mail.gmail.com>
	<20140131114712.GB26148@htj.dyndns.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri, 31 Jan 2014 06:47:12 -0500

>> In above code isn't code line:
>> err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, dev, 0);
>> should be
>> err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, br_dev, 0);
>> 
>> If this needs to be changed then please review attached patch adding this
>> change.

It's not a typo, we want the actual underlying physical device.

Look at the implementations such as drivers/net/ethernet/emulex/be_main.c:
be_ndo_bridge_netlink().  It's doing things like:

	struct be_adapter *adapter = netdev_priv(dev);
