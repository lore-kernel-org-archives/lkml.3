Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3JRRoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:44:07 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:39734 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3JRRoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:44:03 -0400
Message-ID: <5261735A.1000504@gmail.com>
Date: Fri, 18 Oct 2013 19:43:54 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: kirkwood: remove lagacy clk workarounds
References: <1382097253-15624-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131018144741.GL22434@titan.lakedaemon.net> <20131018161743.GA29595@localhost> <52616F81.8060504@gmail.com>
In-Reply-To: <52616F81.8060504@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 07:27 PM, Sebastian Hesselbarth wrote:
> On 10/18/2013 06:17 PM, Ezequiel Garcia wrote:
>> On Fri, Oct 18, 2013 at 10:47:41AM -0400, Jason Cooper wrote:
>>> On Fri, Oct 18, 2013 at 01:54:13PM +0200, Sebastian Hesselbarth wrote:
>>>> With legacy devices converted to DT and a proper ethernet MAC
>>>> workaround, we can now remove the clk workarounds for legacy
>>>> devices. While at it, also cleanup the list of includes.
>>>>
>>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>>> ---
>>>> As a follow-up patch for latest mvebu PRs, this patch is based on
>>>>   git://git.infradead.org/linux-mvebu.git tags/soc-3.13-2
>>>>
>>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: Kevin Hilman <khilman@linaro.org>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> ---
>>>>   arch/arm/mach-kirkwood/board-dt.c |   42
>>>> ++----------------------------------
>>>>   1 files changed, 3 insertions(+), 39 deletions(-)
>>>
>>> Applied to mvebu/soc
>>>
>>
>> Weird: I've tried to do this clean-up myself and my usual tests with
>> network
>> built as a module failed somehow. Maybe I missed something and did
>> something
>> stupid?
>
> Ezequiel,
>
> you need commits
> b5d82db net: mv643xx_eth: fix missing device_node for port devices
> f564412 net: mv643xx_eth: fix orphaned statistics timer crash
> 041b4dd net: mv643xx_eth: update statistics timer from timer context only
>
> from git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
>
> Those are the three net driver fixes and have not yet been pulled into
> mainline linux.
>
> Can you re-test with those three applied (or you can just merge in
> above master)? I am compiling right now and will report.

With mvebu/for-next and net/master merged in,
modular mvmdio and mv643xx_eth on Kirkwood Dockstar:

Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail>

IOW, works. I hope you can confirm this, too.

Sebastian

Log follows:
---
Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.12.0-rc3-00388-g863cf23 (hesselba@nijin) 
(gcc version 4.3.5 (Debian 4.3.5-4) ) #26 PREEMPT Fri Oct 18 19:30:40 
CEST 2013
[    0.000000] CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), 
cr=00053977
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: Marvell Kirkwood (Flattened Device Tree), model: 
Seagate FreeAgent Dockstar
...
[    0.165779] [Firmware Info]: 
/ocp@f1000000/ethernet-controller@72000/ethernet0-port@0: 
local-mac-address is not set
...
root@cosmo:~# insmod mvmdio.ko
[  206.994283] libphy: orion_mdio_bus: probed
root@cosmo:~# insmod mv643xx_eth.ko
[  210.725345] mv643xx_eth: MV-643xx 10/100/1000 ethernet driver version 1.4
[  211.748687] mv643xx_eth_port mv643xx_eth_port.0 eth0: port 0 with MAC 
address 02:50:43:19:fd:e2
[  214.599588] mv643xx_eth_port mv643xx_eth_port.0 eth0: link up, 1000 
Mb/s, full duplex, flow control disabled
...
root@cosmo:~# dhclient eth0
...
RTNETLINK answers: File exists 

root@cosmo:~# ifconfig 

eth0      Link encap:Ethernet  HWaddr 02:50:43:19:fd:e2 

           inet addr:192.168.1.54  Bcast:192.168.1.255  Mask:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:17 errors:0 dropped:0 overruns:0 frame:0
           TX packets:30 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:2822 (2.7 KiB)  TX bytes:4049 (3.9 KiB)
           Interrupt:29

