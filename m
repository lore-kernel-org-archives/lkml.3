Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675Ab3GaTZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab3GaTZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:25:37 -0400
Date: Wed, 31 Jul 2013 12:25:34 -0700 (PDT)
Message-Id: <20130731.122534.774117327230299927.davem@redhat.com>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/12] tile: support TSO for IPv6 in tilegx network
 driver
From: David Miller <davem@redhat.com>
In-Reply-To: <799eca39dc7f85ba12e1d8c5b072f8b6740fda1c.1375283106.git.cmetcalf@tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
	<cover.1375283104.git.cmetcalf@tilera.com>
	<799eca39dc7f85ba12e1d8c5b072f8b6740fda1c.1375283106.git.cmetcalf@tilera.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 31 Jul 2013 11:05:04 -0400

> @@ -1950,6 +1963,7 @@ static void tile_net_setup(struct net_device *dev)
>  	dev->features |= NETIF_F_HW_CSUM;
>  	dev->features |= NETIF_F_SG;
>  	dev->features |= NETIF_F_TSO;
> +	dev->features |= NETIF_F_TSO6;
>  	dev->mtu = 1500;

This driver is severely out of date wrt. how to properly advertise
device features, and you really need to fix this _before_ adding
support for new capabilities.

dev->hw_features specifies what the device is capable of, whereas
dev->features specifies what features are currently enabled.

Using these two values we determine what feature bits the user
can configure on and off using generic code which checks
dev->hw_features when the user makes a request.

You'll also want to have a look at netdev_ops->ndo_fix_features
and netdev_ops->ndo_set_features which allow a driver to handle
attempts to install illegal combinations of features.

You can look at other well maintained drivers to see how this
works.

Thanks.
