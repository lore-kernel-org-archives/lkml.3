Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3CNTdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:33:05 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49117 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3CNTdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:33:02 -0400
Message-ID: <514225E9.9060902@openwrt.org>
Date: Thu, 14 Mar 2013 20:32:57 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: davem@davemloft.net,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-doc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] mv643xx_eth: convert to use the Marvell Orion MDIO driver
References: <1359473048-26551-1-git-send-email-florian@openwrt.org> <1363284515-9865-1-git-send-email-florian@openwrt.org> <1363284515-9865-2-git-send-email-florian@openwrt.org> <20130314190235.GW12700@titan.lakedaemon.net>
In-Reply-To: <20130314190235.GW12700@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

Le 14/03/2013 20:02, Jason Cooper a écrit :
> Florian,
>
> On Thu, Mar 14, 2013 at 07:08:32PM +0100, Florian Fainelli wrote:
>> This patch converts the Marvell MV643XX ethernet driver to use the
>> Marvell Orion MDIO driver. As a result, PowerPC and ARM platforms
>> registering the Marvell MV643XX ethernet driver are also updated to
>> register a Marvell Orion MDIO driver. This driver voluntarily overlaps
>> with the Marvell Ethernet shared registers because it will use a subset
>> of this shared register (shared_base + 0x4 - shared_base + 0x84). The
>> Ethernet driver is also updated to look up for a PHY device using the
>> Orion MDIO bus driver.
>>
>> Signed-off-by: Florian Fainelli <florian@openwrt.org>
>> ---
>>   arch/arm/plat-orion/common.c               |   97 +++++++++++----
>>   arch/powerpc/platforms/chrp/pegasos_eth.c  |   20 +++
>>   arch/powerpc/sysdev/mv64x60_dev.c          |   14 ++-
>>   drivers/net/ethernet/marvell/Kconfig       |    1 +
>>   drivers/net/ethernet/marvell/mv643xx_eth.c |  186 ++--------------------------
>>   include/linux/mv643xx_eth.h                |    1 -
>>   6 files changed, 117 insertions(+), 202 deletions(-)
>
> Isn't this the old version of 4/4 ?

No this really is v2, but I reformatted just that one and sent it 
without the v2 changelog, you should have received the proper version a 
couple minutes later once I realized my mistake.
--
Florian
