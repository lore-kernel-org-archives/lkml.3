Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaA0IgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:36:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56787 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbaA0IgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:36:00 -0500
Date: Mon, 27 Jan 2014 00:35:59 -0800 (PST)
Message-Id: <20140127.003559.2290408024387922847.davem@davemloft.net>
To: jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: hyperv: initialize link status correctly
From: David Miller <davem@davemloft.net>
In-Reply-To: <1390807854-4469-1-git-send-email-jasowang@redhat.com>
References: <1390807854-4469-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 27 Jan 2014 15:30:54 +0800

> Call netif_carrier_on() after register_device(). Otherwise it won't work since
> the device was still in NETREG_UNINITIALIZED state.
> 
> Fixes a68f9614614749727286f675d15f1e09d13cb54a
> (hyperv: Fix race between probe and open calls)
> 
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Reported-by: Di Nie <dnie@redhat.com>
> Tested-by: Di Nie <dnie@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

A device up can occur at the moment you call register_netdevice(),
therefore that up call can see the carrier as down and fail or
similar.  So you really cannot resolve the carrier to be on in this
way.
