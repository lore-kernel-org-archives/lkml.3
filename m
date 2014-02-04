Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaBDTid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:38:33 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64020 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaBDTia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:38:30 -0500
Message-ID: <52F141AE.8010402@gmail.com>
Date: Tue, 04 Feb 2014 20:38:22 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: David Miller <davem@davemloft.net>
CC: f.fainelli@gmail.com, mugunthanvnm@ti.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 0/5] net: phy: Ethernet PHY powerdown optimization
References: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com> <1386926429-28818-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131217.144313.1563516273987934449.davem@davemloft.net>
In-Reply-To: <20131217.144313.1563516273987934449.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 08:43 PM, David Miller wrote:
> From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Date: Fri, 13 Dec 2013 10:20:24 +0100
>
>> This is v2 of the ethernet PHY power optimization patches to reduce
>> power consumption of network PHYs with link that are either unused or
>> the corresponding netdev is down.
>>
>> Compared to the last version, this patch set drops a patch to disable
>> unused PHYs after late initcall, as it is not compatible with a modular
>> mdio bus [1]. I'll investigate different ways to have a modular mdio bus
>> driver get notified when driver loading is done.
>>
>> Again, a branch with v2 applied to v3.13-rc2 can also be found at
>> https://github.com/shesselba/linux-dove.git topic/ethphy-power-v2
>>
>> [1] http://www.spinics.net/lists/arm-kernel/msg293028.html
>
> Series applied, thanks.
>

David, Mungunthan, Florian,

as expected the above patches create a Linux to bootloader dependency
that surfaces dumb bootloaders not initializing PHYs correctly.

Andrew has a Kirkwood based board that does not power-up and restart
auto-negotiation on the powered down PHY after a warm restart. While
this specific bootloader allows a soft-workaround by issuing the
required PHY writes before accessing the interface, others may not.

I think we should allow the user to soft-disable the automatic
power-down of PHYs, i.e. by exploiting a kernel parameter.

Do you have any preference for naming it? My call would be something
like libphy.suspend_halted = [0,1] with 1 being the default.

Sebastian

