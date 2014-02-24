Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaBXTiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:38:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBXTh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:37:57 -0500
MIME-Version: 1.0
In-Reply-To: <20140224191554.GC29288@lunn.ch>
References: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224191554.GC29288@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 24 Feb 2014 11:37:15 -0800
Message-ID: <CAGVrzcaOSMQWJ69KHJ7TH0_BN9D-O4uoL=fLWDoE=xFdV4RJ4w@mail.gmail.com>
Subject: Re: [PATCH] net: phy: add suspend_halted module param
To: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-24 11:15 GMT-08:00 Andrew Lunn <andrew@lunn.ch>:
> On Sun, Feb 23, 2014 at 05:58:39PM +0100, Sebastian Hesselbarth wrote:
>> commit 1211ce53077164e0d34641d0ca5fb4d4a7574498
>>   ("net: phy: resume/suspend PHYs on attach/detach")
>> introduced a feature to suspend PHYs when entering halted state.
>>
>> Unfortunately, not all bootloaders properly power-up PHYs on reset
>> and fail to access ethernet because the PHY is still powered down.
>>
>> Therefore, we add a boolean module parameter suspend_halted with
>> default value of true. Disabling that parameter prevents PHYs from
>> being suspended when entering halted state.
>
> Hi Sebastian
>
> Am i doing something silly here?

Could the PHY be already suspended during your initial boot? If that
is the case, the first time we all phy_suspend() the flag is true, we
suspend it, and we never wake it again despite changing
suspend_halted. Does it work better if you specify this module
parameter on the initial kernel boot command-line?

>
> root@qnap:/sys/module/libphy/parameters# cat suspend_halted
> Y
> root@qnap:/sys/module/libphy/parameters# echo N > suspend_halted
> root@qnap:/sys/module/libphy/parameters# cat suspend_halted
> N
> root@qnap:/sys/module/libphy/parameters# reboot
> ...
> ...
>
> Net:   egiga0 [PRIME]
> Hit any key to stop autoboot:  0
> Send Cmd : 0x68 to UART1
> egiga0 no link
> Using egiga0 device
> TFTP from server 10.0.0.1; our IP address is 10.0.0.2
> Filename 'uImage-qnap'.
> Load address: 0x800000
> Loading: T T
>
> Does not seem to work.
>
>      Andrew



-- 
Florian
