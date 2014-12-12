Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaLLFJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:09:07 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:48478 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaLLFJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:09:05 -0500
Message-ID: <548A786D.2060201@gmail.com>
Date: Thu, 11 Dec 2014 21:09:01 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, jim.epost@gmail.com
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: randconfig build error with next-20141210, in drivers/net/ethernet/broadcom/genet
References: <CA+r1ZhjxtK8BtF16Mr9jXjqvFVV7KAAFjWqfVFUibNreZwZxTw@mail.gmail.com> <20141211.142220.610076934853342634.davem@davemloft.net>
In-Reply-To: <20141211.142220.610076934853342634.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/12/2014 11:22, David Miller a écrit :
> From: Jim Davis <jim.epost@gmail.com> Date: Wed, 10 Dec 2014
> 09:10:45 -0700
> 
>> Building with the attached random configuration file,
>> 
>> ERROR: "fixed_phy_register" 
>> [drivers/net/ethernet/broadcom/genet/genet.ko] undefined!
> 
> Florian, I don't understand why FIXED_PHY is only selected in
> Kconfig if the driver is statically built into the kernel.
> 
> That makes no sense at all, you should need that module regardless
> of how the driver itself is enabled.

AFAIR this was introduced to silence a warning you reported:

"I think you need to work on the Kconfig dependencies a little bit more.
I have BCMGENET specified as modular, which absolutely should work.  Yet
Kconfig complains.

warning: (BCMGENET) selects FIXED_PHY which has unmet direct
dependencies (NETDEVICES && PHYLIB=y)"

but I agree, this makes no sense, we should select FIXED_PHY
unconditionnally, will send you patches tomorrow to fix that.

> 
> Can't we just remove the "XXX=y" in all of those silly:
> 
> select FIXED_PHY if XXX=y
> 
> expressions?
> 
> There are three such cases right now:
> 
> drivers/net/dsa/Kconfig:	select FIXED_PHY if NET_DSA_BCM_SF2=y 
> drivers/net/ethernet/broadcom/Kconfig:	select FIXED_PHY if
> BCMGENET=y drivers/net/ethernet/broadcom/Kconfig:	select FIXED_PHY
> if SYSTEMPORT=y
> 


-- 
Florian
