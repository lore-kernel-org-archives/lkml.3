Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733Ab3CZQpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:45:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41007 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934186Ab3CZQpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:45:38 -0400
Date: Tue, 26 Mar 2013 12:45:35 -0400 (EDT)
Message-Id: <20130326.124535.2213486098970156228.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [net-next 0/5] set transport header for untrusted packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364278799-37285-1-git-send-email-jasowang@redhat.com>
References: <1364278799-37285-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 26 Mar 2013 09:45:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 26 Mar 2013 14:19:54 +0800

> We don't set transport header for untrusted packets in the past, but for the
> follwoing reasons, we need to do it now.
> 
> - Better packet length estimation (introduced in 1def9238) needs l4 header for
>   gso packets to compute the header length.
> - Some driver needs l4 header (e.g. ixgbe needs tcp header to do atr).
> 
> So this patches tries to set transport header for packets from untrusted source
> (netback, packet, tuntap, macvtap). Plus a fix for better estimation on packet
> length for DODGY packet.
> 
> Tested on tun/macvtap/packet, compile test on netback.

Looks good to me, series applied, thanks Jason.
