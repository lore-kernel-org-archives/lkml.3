Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBXTQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:16:48 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:34501 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbaBXTQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:16:46 -0500
Date: Mon, 24 Feb 2014 20:15:54 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: add suspend_halted module param
Message-ID: <20140224191554.GC29288@lunn.ch>
References: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 05:58:39PM +0100, Sebastian Hesselbarth wrote:
> commit 1211ce53077164e0d34641d0ca5fb4d4a7574498
>   ("net: phy: resume/suspend PHYs on attach/detach")
> introduced a feature to suspend PHYs when entering halted state.
> 
> Unfortunately, not all bootloaders properly power-up PHYs on reset
> and fail to access ethernet because the PHY is still powered down.
> 
> Therefore, we add a boolean module parameter suspend_halted with
> default value of true. Disabling that parameter prevents PHYs from
> being suspended when entering halted state.

Hi Sebastian

Am i doing something silly here?

root@qnap:/sys/module/libphy/parameters# cat suspend_halted 
Y
root@qnap:/sys/module/libphy/parameters# echo N > suspend_halted 
root@qnap:/sys/module/libphy/parameters# cat suspend_halted 
N
root@qnap:/sys/module/libphy/parameters# reboot
...
...

Net:   egiga0 [PRIME]
Hit any key to stop autoboot:  0 
Send Cmd : 0x68 to UART1
egiga0 no link
Using egiga0 device
TFTP from server 10.0.0.1; our IP address is 10.0.0.2
Filename 'uImage-qnap'.
Load address: 0x800000
Loading: T T 

Does not seem to work.

     Andrew
