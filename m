Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbaFPKq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:46:29 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42122 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaFPKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:46:27 -0400
Message-ID: <539ECAFE.3000508@gmail.com>
Date: Mon, 16 Jun 2014 12:46:22 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org, kishon@ti.com
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/7] ARM: berlin: add AHCI support
References: <1402914392-6028-1-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1402914392-6028-1-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 12:26 PM, Antoine Ténart wrote:
> This series adds the support for Berlin SoC AHCI controller. The
> controller allows to use the SATA host interface and, for example, the
> eSATA port on the BG2Q.
>
> The series adds a PHY driver to control the two SATA ports available,
> and adds a generic compatible to use the existing ahci_platform driver.

Besides the comment about adding SATA clock to SATA PHY node and driver,

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

for patches 1-5.

> Also enable the eSATA interface on the BG2Q DMP.
>
> Changes sinve v5:
> 	- rebased on top of v3.16-rc1
> 	- added the clocks property in the sata node
>
> Changes since v4:
>          - updated PHY driver as tristate
>          - handled the case were no SATA port is enabled
>          - updated the compatible to a generic one
>          - cosmetic fixups
>
> Changes since v3:
>          - moved all PHY operations to the PHY driver
>          - removed PHY sub-nodes
>          - removed the custom Berlin AHCI driver and switched to
>            ahci_platform
>          - added multiple PHYs support to the libahci_platform
>
> Changes since v2:
>          - modeled each PHY as a sub-node
>          - cosmetic fixups
>
> Changes since v1:
>          - added a PHY driver, allowing to enable each port
>            individually and removed the 'force-port-map' property
>          - made the drivers a bit less magic :)
>          - wrote a function to select and configure registers in the
>            AHCI driver
>          - removed BG2 / BG2CD nodes
>
> Antoine Ténart (7):
>    phy: add a driver for the Berlin SATA PHY
>    Documentation: bindings: add the Berlin SATA PHY
>    ata: libahci: allow to use multiple PHYs
>    ata: ahci_platform: add a generic AHCI compatible
>    Documentation: bindings: document the sub-nodes AHCI bindings
>    ARM: berlin: add the AHCI node for the BG2Q
>    ARM: berlin: enable the eSATA interface on the BG2Q DMP
>
>   .../devicetree/bindings/ata/ahci-platform.txt      |  37 ++++
>   .../devicetree/bindings/phy/berlin-sata-phy.txt    |  14 ++
>   arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |   8 +
>   arch/arm/boot/dts/berlin2q.dtsi                    |  28 +++
>   drivers/ata/ahci.h                                 |   3 +-
>   drivers/ata/ahci_platform.c                        |   2 +
>   drivers/ata/libahci.c                              |   7 +
>   drivers/ata/libahci_platform.c                     | 170 +++++++++++----
>   drivers/phy/Kconfig                                |   7 +
>   drivers/phy/Makefile                               |   1 +
>   drivers/phy/phy-berlin-sata.c                      | 232 +++++++++++++++++++++
>   11 files changed, 473 insertions(+), 36 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
>   create mode 100644 drivers/phy/phy-berlin-sata.c
>

