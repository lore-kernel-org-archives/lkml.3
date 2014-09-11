Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaIKGcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:32:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52917 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaIKGcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:32:04 -0400
Message-ID: <541141DB.9010908@ti.com>
Date: Thu, 11 Sep 2014 12:01:55 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Add DRA7xx CPSW Ethernet support in Device Tree
References: <1410356247-25925-1-git-send-email-mugunthanvnm@ti.com> <541059B4.50205@ti.com>
In-Reply-To: <541059B4.50205@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2014 07:31 PM, Nishanth Menon wrote:
> On 09/10/2014 08:37 AM, Mugunthan V N wrote:
>> Adding device tree entry for CPSW to make it work in Dual EMAC mode.
>> These patches were tested with DRA7 hwmod patches on top of linux-next.
>> Patches are tested on top of Nishanth's PM tree for v3.17 [1] and pushed
>> my tree to [2].
>>
>> Did a boot test with CPSW and ping test with suspend/resume, the boot logs
>> on DRA7xx EVM are posted at [3]
>>
>> [1] git://github.com/nmenon/linux-2.6-playground.git testing/v3.17/cpu-idle-suspend-dra7-omap5-framework
>> [2] git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git v3.17/dra7-evm-cpsw
>> [3] http://pastebin.ubuntu.com/8309289/
>>
>> Changes from initial version:
>> * Dropped patch for pinoff states
>> * Changed pinoff state to mode15
>>
>> Mugunthan V N (2):
>>   ARM: dts: dra7: Add CPSW and MDIO module nodes for dra7
>>   ARM: dts: dra7-evm: Enable CPSW and MDIO for dra7xx EVM
>>
>>  arch/arm/boot/dts/dra7-evm.dts | 107 +++++++++++++++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/dra7.dtsi    |  59 +++++++++++++++++++++++
>>  2 files changed, 166 insertions(+)
>>
> I did apply these on Tony's
> "omap-for-v3.18/dt 6e55426 Merge branch .."
> they do apply.
> 
> However: why are we not sending dra72-evm.dts changes in the same
> series since we claim it to be dra7xx support?

Will add dra72x support and submit the next version.

> 
> Also, in your tests (http://pastebin.ubuntu.com/8309289/)
> echo -n "20">/sys/kernel/debug/pm_debug/wakeup_timer_seconds
> ping 172.24.188.1  & (or even better do a transfer of large file in
> background)
> echo mem > /sys/power/state
> 
> transfer/ping should resume seamlessly. (only thing you should be
> careful is that the server should not timeout for 20 second inactivity)..

ping will resume seamlessly will try tftp and update on my next version
submission. Will add ping test across suspend resume with both ports
while posting my next version

Regards
Mugunthan V N

> 
> It is a valid test to verify peripheral activity after resume, BUT,
> equally important is to verify suspend-resume in the middle of activity.
> 

