Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaH2Qr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:47:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42611 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaH2QrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:47:24 -0400
Message-ID: <5400AE95.2040308@gmail.com>
Date: Fri, 29 Aug 2014 18:47:17 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ARM: Berlin: Ethernet support
References: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 03:50 PM, Antoine Tenart wrote:
> This series introduce the Marvell Berlin Ethernet driver, allowing to
> handle the fast Ethernet port. This driver is based on the mv643xx_eth
> driver and reuse some of its functions. While I wanted to make these
> functions common to the two drivers at first, I finally do think this
> is not a great idea:
> - Registers are very different.
> - The mv643xx_eth supports up to 1000Mbps interfaces and performance
>   issues may occur, whereas the mvberlin_eth is only for fast Ethernet.
> - The mvberlin_eth driver uses a hash table to filter incoming packets.
> - A few other differences.
> 
> I tried to stay close to the mv643xx_eth implementation, so that the
> discussion is still open, but I still ended up with lots of tiny
> differences that can be hard to manage for both cases. In the end I do
> think having two separate drivers is a good choice.

Antoine,

first of all, thanks a lot for providing this driver! I checked the
usual Marvell datasheets to see where the ethernet IP in Berlin comes
from and I hate to say it but it very much looks like PXA168, see [1]
A.22. Also, there is already a driver for pxa168_eth available.

I'll test and review you current driver on BG2 asap, but I guess it
should be merged with pxa168_eth _if_ the registers are really
compatible.

Sebastian

[1]
http://www.marvell.com/application-processors/armada-100/assets/armada_16x_software_manual.pdf

> That being said, I tested the Ethernet communication with ICMP pings,
> netcat, tried to use some network related softwares (such as ssh). Here
> is an iperf output:
> 
>  ------------------------------------------------------------
>  Client connecting to 192.168.0.11, TCP port 5001
>  TCP window size: 85.0 KByte (default)
>  ------------------------------------------------------------
>  [  3] local 192.168.0.20 port 44183 connected with 192.168.0.11 port 5001
>  [ ID] Interval       Transfer     Bandwidth
>  [  3]  0.0-10.0 sec   113 MBytes  94.8 Mbits/sec
> 
> Tests were done on a BG2Q DMP, and this series currently does not add
> other device tree nodes than the ones for this board.
> 
> Thanks!
> 
> Antoine
> 
> 
> Antoine Tenart (5):
>   net: mvberlin_eth: add an Ethernet driver for Marvell Berlin
>   Documentation: bindings: net: add the Marvell Berlin Ethernet
>     controller
>   Documentation: devicetree: net: mention Marvell Berlin
>   ARM: dts: berlin: add ethernet and mdio nodes
>   ARM: dts: berlin: enable the Ethernet port on the BG2Q DMP
> 
>  .../devicetree/bindings/net/marvell-berlin.txt     |   23 +
>  .../devicetree/bindings/net/marvell-orion-mdio.txt |    6 +-
>  arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |   13 +
>  arch/arm/boot/dts/berlin2q.dtsi                    |   19 +
>  drivers/net/ethernet/marvell/Kconfig               |    9 +
>  drivers/net/ethernet/marvell/Makefile              |    1 +
>  drivers/net/ethernet/marvell/mvberlin_eth.c        | 2081 ++++++++++++++++++++
>  7 files changed, 2149 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell-berlin.txt
>  create mode 100644 drivers/net/ethernet/marvell/mvberlin_eth.c
> 

