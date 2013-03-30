Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3C3V30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 17:29:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39971 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3C3V3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 17:29:25 -0400
Date: Sat, 30 Mar 2013 17:29:23 -0400 (EDT)
Message-Id: <20130330.172923.359158542815044103.davem@davemloft.net>
To: ordex@autistici.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, pshelar@nicira.com
Subject: Re: [PATCH] ip_gre: don't overwrite iflink during net_dev init
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364663257-14717-1-git-send-email-ordex@autistici.org>
References: <20130330115245.GA4024@ritirata.org>
	<1364663257-14717-1-git-send-email-ordex@autistici.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 30 Mar 2013 14:29:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonio Quartulli <ordex@autistici.org>
Date: Sat, 30 Mar 2013 18:07:37 +0100

> iflink is currently set to 0 in __gre_tunnel_init(). This
> function is invoked in gre_tap_init() and
> ipgre_tunnel_init() which are both used to initialise the
> ndo_init field of the respective net_device_ops structs
> (ipgre.. and gre_tap..) used by GRE interfaces.
> 
> However, in netdevice_register() iflink is first set to -1,
> then ndo_init is invoked and then iflink is assigned to a
> proper value if and only if it still was -1.
> 
> Assigning 0 to iflink in ndo_init is therefore first
> preventing netdev_register() to correctly assign it a proper
> value and then breaking iflink at all since 0 has not
> correct meaning.
> 
> Fix this by removing the iflink assignment in
> __gre_tunnel_init().
> 
> Introduced by c54419321455631079c7d6e60bc732dd0c5914c5
> ("GRE: Refactor GRE tunneling code.")
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>

Please always indicate, in the subject line inside of the [] brackets,
what tree the patch is targetted at.

I can use "git describe" on the guilty commit, but why take a chance?

Applied to net-next, thanks.
