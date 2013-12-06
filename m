Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab3LFARR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:17:17 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64251 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3LFARN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:17:13 -0500
MIME-Version: 1.0
In-Reply-To: <52A031EE.1040301@ti.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1386171888-28190-1-git-send-email-sebastian.hesselbarth@gmail.com> <52A031EE.1040301@ti.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 5 Dec 2013 16:16:32 -0800
Message-ID: <CAGVrzcYjcXfbYR7uyL1fAc2bdNhCUA9wAjZk4nsF2K0FRL2_pA@mail.gmail.com>
Subject: Re: [PATCH RFCv2 0/6] net: phy: Ethernet PHY powerdown optimization
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/4 Mugunthan V N <mugunthanvnm@ti.com>:
> On Wednesday 04 December 2013 09:14 PM, Sebastian Hesselbarth wrote:
>> This is v2 of an RFC sent earlier [1] to reduce power consumption of network
>> PHYs with link that are either unused or the corresponding netdev is down.
>>
>> In contrast to RFCv1, this now integrates phy_suspend/phy_resume transparent
>> to the netdev drivers. Also, phy_suspend now only suspends the PHY if WOL is
>> disabled. Moreover, the phy state machine calls phy_suspend on entering
>> HALTED state.
>>
>> Again, a branch with RFCv2 applied to v3.13-rc2 can also be found at
>> https://github.com/shesselba/linux-dove.git topic/ethphy-power-rfc-v2
>>
>> [1] http://lwn.net/Articles/574426/
>>
>> Sebastian Hesselbarth (6):
>>   net: mv643xx_eth: properly start/stop phy device
>>   net: phy: marvell: provide genphy suspend/resume
>>   net: phy: provide phy_resume/phy_suspend helpers
>>   net: phy: resume/suspend PHYs on attach/detach
>>   net: phy: suspend unused PHYs on mdio_bus in late_initcall
>>   net: phy: suspend phydev when going to HALTED
>>
>>  drivers/net/ethernet/marvell/mv643xx_eth.c |    4 +++-
>>  drivers/net/phy/marvell.c                  |   22 ++++++++++++++++++++++
>>  drivers/net/phy/mdio_bus.c                 |   25 +++++++++++++++++++++++++
>>  drivers/net/phy/phy.c                      |    6 +++++-
>>  drivers/net/phy/phy_device.c               |   27 +++++++++++++++++++++++++++
>>  include/linux/phy.h                        |    2 ++
>>  6 files changed, 84 insertions(+), 2 deletions(-)
>>
>> ---
>> Cc: David Miller <davem@davemloft.net>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Mugunthan V N <mugunthanvnm@ti.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
> Apart form Sergei's comment the patch series looks good to me.
>
> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Looks good to me as well:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Sebastian!
-- 
Florian
