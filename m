Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3KNWFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:05:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53343 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab3KNWFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:05:32 -0500
Date: Thu, 14 Nov 2013 17:05:29 -0500 (EST)
Message-Id: <20131114.170529.1627250972818871118.davem@davemloft.net>
To: nicolas.dichtel@6wind.com
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, williams@redhat.com,
        linux-rt-users@vger.kernel.org, lclaudio@uudg.org,
        netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH net] ip6tnl: fix use after free of fb_tnl_dev
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384440423-4275-1-git-send-email-nicolas.dichtel@6wind.com>
References: <20131113211430.1ad3bb7d@gandalf.local.home>
	<1384440423-4275-1-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 14 Nov 2013 14:05:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 14 Nov 2013 15:47:03 +0100

> Bug has been introduced by commit bb8140947a24 ("ip6tnl: allow to use rtnl ops
> on fb tunnel").
> 
> When ip6_tunnel.ko is unloaded, FB device is delete by rtnl_link_unregister()
> and then we try to use the pointer in ip6_tnl_destroy_tunnels().
> 
> Let's add an handler for dellink, which will never remove the FB tunnel. With
> this patch it will no more be possible to remove it via 'ip link del ip6tnl0',
> but it's safer.
> 
> The same fix was already proposed by Willem de Bruijn <willemb@google.com> for
> sit interfaces.
> 
> CC: Willem de Bruijn <willemb@google.com>
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied and queued up for -stable, thanks for being so proactive about this
Nicolas.
