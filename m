Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab3LKHGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:06:48 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40764 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3LKHGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:06:43 -0500
Message-ID: <52A80EFC.8070806@gmail.com>
Date: Wed, 11 Dec 2013 08:06:36 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
To: David Miller <davem@davemloft.net>
CC: f.fainelli@gmail.com, mugunthanvnm@ti.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/6] net: mv643xx_eth: properly start/stop phy device
References: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com> <1386513631-11284-2-git-send-email-sebastian.hesselbarth@gmail.com> <20131210.215253.2121948728095674632.davem@davemloft.net> <20131210.215654.1165181423931409066.davem@davemloft.net>
In-Reply-To: <20131210.215654.1165181423931409066.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 03:56 AM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 10 Dec 2013 21:52:53 -0500 (EST)
>
>>
>> This series looks good, applied to net-next, thanks.
>
> Actually, I had to revert.
>
> You cannot use late_initcall_sync() from code that is potentially
> built modular, this caused my build to fail at the mdio_bus code.
>
> drivers/net/phy/mdio_bus.c:344:1: warning: data definition has no type or storage class [enabled by default]
> drivers/net/phy/mdio_bus.c:344:1: error: type defaults to ¡int¢ in declaration of ¡late_initcall_sync¢ [-Werror=implicit-int]
> drivers/net/phy/mdio_bus.c:344:1: warning: parameter names (without types) in function declaration [enabled by default]
> drivers/net/phy/mdio_bus.c:339:12: warning: ¡mdio_bus_class_suspend_unused¢ defined but not used [-Wunused-function]
>

Hmm, I see. What about you drop patch 5 ("net: phy: suspend unused PHYs
on mdio_bus in late_initcall"), take the rest, and I'll have look at
suspending unused PHYs later?

Sebastian
