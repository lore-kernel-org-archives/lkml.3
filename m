Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaGHEUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:20:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48742 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaGHEUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:20:35 -0400
Date: Mon, 07 Jul 2014 21:20:34 -0700 (PDT)
Message-Id: <20140707.212034.2224956636540078311.davem@davemloft.net>
To: loicp@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, timo.teras@iki.fi,
        jiri@resnulli.us
Subject: Re: [PATCH] net: Fix NETDEV_CHANGE notifier usage causing spurious
 arp flush
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404275983-7908-1-git-send-email-loicp@google.com>
References: <1404275983-7908-1-git-send-email-loicp@google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Jul 2014 21:20:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Prylli <loicp@google.com>
Date: Tue,  1 Jul 2014 21:39:43 -0700

> A bug was introduced in NETDEV_CHANGE notifier sequence causing the
> arp table to be sometimes spuriously cleared (including manual arp
> entries marked permanent), upon network link carrier changes.
> 
> The changed argument for the notifier was applied only to a single
> caller of NETDEV_CHANGE, missing among others netdev_state_change().
> So upon net_carrier events induced by the network, which are
> triggering a call to netdev_state_change(), arp_netdev_event() would
> decide whether to clear or not arp cache based on random/junk stack
> values (a kind of read buffer overflow).
> 
> Fixes: be9efd365328 ("net: pass changed flags along with NETDEV_CHANGE event")
> Fixes: 6c8b4e3ff81b ("arp: flush arp cache on IFF_NOARP change")
> Signed-off-by: Loic Prylli <loicp@google.com>

Applied, thanks.

We should probably make plain call_netdevice_notifiers() BUG if it is
invoked for NETDEV_CHANGE.
