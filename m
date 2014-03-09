Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaCIXMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 19:12:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36937 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaCIXMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 19:12:37 -0400
Date: Sun, 09 Mar 2014 19:12:35 -0400 (EDT)
Message-Id: <20140309.191235.1047481546773873653.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: rob@landley.net, andrew@lunn.ch, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Add sysfs attribute to prevent PHY suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394192092-27461-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1394192092-27461-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Mar 2014 16:12:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Fri,  7 Mar 2014 12:34:52 +0100

> commit 1211ce53077164e0d34641d0ca5fb4d4a7574498
>   ("net: phy: resume/suspend PHYs on attach/detach")
> introduced a feature to suspend PHYs when entering halted state.
> 
> Unfortunately, not all bootloaders properly power-up PHYs on reset
> and fail to access ethernet because the PHY is still powered down.
> 
> Therefore, this adds code and documentation for a sysfs attribute to
> allow/deny PHYs to be suspended on a per-PHY basis. Disabling that
> attribute prevents PHYs from being suspended when entering halted state.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reported-by: Andrew Lunn <andrew@lunn.ch>

I know you won't like what I have to say, but I want to see a solution
without this sysfs knob.

First of all, you obviously have a way to end up having the sysfs knob
get set on the appropriate systems.

Therefore, you obviously have some way to propagate the same piece of
information into the kernel somehow during boot time.

For example, via a device tree property or similar.

Please pursue an avenue such as that.  This sysfs thing, it's a user
facing interface we'd have to live with forever.
