Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030696AbaLLQCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:02:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35829 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030544AbaLLQCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:02:25 -0500
Date: Fri, 12 Dec 2014 11:02:23 -0500 (EST)
Message-Id: <20141212.110223.1096319955510441330.davem@davemloft.net>
To: f.fainelli@gmail.com
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: randconfig build error with next-20141210, in
 drivers/net/ethernet/broadcom/genet
From: David Miller <davem@davemloft.net>
In-Reply-To: <548A786D.2060201@gmail.com>
References: <CA+r1ZhjxtK8BtF16Mr9jXjqvFVV7KAAFjWqfVFUibNreZwZxTw@mail.gmail.com>
	<20141211.142220.610076934853342634.davem@davemloft.net>
	<548A786D.2060201@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Dec 2014 08:02:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 11 Dec 2014 21:09:01 -0800

> Le 11/12/2014 11:22, David Miller a écrit :
>> From: Jim Davis <jim.epost@gmail.com> Date: Wed, 10 Dec 2014
>> 09:10:45 -0700
>> 
>>> Building with the attached random configuration file,
>>> 
>>> ERROR: "fixed_phy_register" 
>>> [drivers/net/ethernet/broadcom/genet/genet.ko] undefined!
>> 
>> Florian, I don't understand why FIXED_PHY is only selected in
>> Kconfig if the driver is statically built into the kernel.
>> 
>> That makes no sense at all, you should need that module regardless
>> of how the driver itself is enabled.
> 
> AFAIR this was introduced to silence a warning you reported:
> 
> "I think you need to work on the Kconfig dependencies a little bit more.
> I have BCMGENET specified as modular, which absolutely should work.  Yet
> Kconfig complains.
> 
> warning: (BCMGENET) selects FIXED_PHY which has unmet direct
> dependencies (NETDEVICES && PHYLIB=y)"
> 
> but I agree, this makes no sense, we should select FIXED_PHY
> unconditionnally, will send you patches tomorrow to fix that.

What's really perplexing is that FIXED_PHY is only enable'able
when PHYLIB=y.  I think that's the core of the problems here.

All of these drivers shouldn't lose fixed phy support simply
because they, or PHYLIB itself, is built modular.
