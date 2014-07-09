Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbaGIXrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:47:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34633 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaGIXq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:46:59 -0400
Date: Wed, 09 Jul 2014 16:46:58 -0700 (PDT)
Message-Id: <20140709.164658.447780441521030859.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: support jumbo frame for RTL8153
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-8-Taiwan-albertk@realtek.com>
References: <1394712342-15778-8-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 09 Jul 2014 16:46:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 9 Jul 2014 16:07:02 +0800

> +static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +	struct r8152 *tp = netdev_priv(dev);
> +
> +	if (dev->mtu == new_mtu)
> +		return 0;

This method will never be invoked if the MTU is actually not changing.

Please remove this test.
