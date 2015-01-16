Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbbAPH7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:59:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbbAPH7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:59:02 -0500
Message-ID: <54B8C49A.9070302@redhat.com>
Date: Fri, 16 Jan 2015 08:58:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/4] ata: libahci: Allow using a regulator for each
 port
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 15-01-15 15:09, Gregory CLEMENT wrote:
> The current implementation of the libahci allows using one PHY per
> port but we still have one single regulator for the whole
> controller. This series adds the support of multiple regulators.
>
> This is the forth version of the series.
>
> The improvement of this version is the use of
> ahci_platform_put_resources to put the reference to the regulators.
>
> Thanks,
>
> Grégory

Thanks, patches 1 - 3 look good and are:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Tejun, can you please queue up 1 - 3 ?

I still have some remarks wrt patch 4 (*), and it should probably go
upstream through another tree anyways.

Regards,

Hans


*) I didn't look closely at patch 4 as it seemed trivial, until now
that is ...



>
> Changelog:
>
>   v3 -> v4
> - Moved putting the reference to the regulators into the
>    ahci_platform_put_resources function.
> - Tested the port_dev pointer before dereferencing.
>
>   v2 -> v3:
> - put back the regulator inside the sub-node ports
> - made the ports platform devices when the device tree is used
> - released the regulator in case of error in the probe function
>
>   v1 -> v2:
> - Kept the case when no child node are present under the ahci node
> - Fix the test done under the label disable_target_pwrs
> - No more use an of_ version of the regulator framework and instead
>    associate each regulator of a port with an unique name.
> - Added the acked-by on the clean-up patch
>
> Gregory CLEMENT (4):
>    ata: libahci: Clean-up the ahci_platform_en/disable_phys functions
>    Documentation: bindings: Add the regulator property to the sub-nodes
>      AHCI bindings
>    ata: libahci: Allow using multiple regulators
>    ARM: mvebu: Armada 385 GP: Add regulators to the SATA port
>
>   .../devicetree/bindings/ata/ahci-platform.txt      |   9 +-
>   arch/arm/boot/dts/armada-388-gp.dts                | 126 +++++++++++
>   drivers/ata/ahci.h                                 |   2 +-
>   drivers/ata/ahci_imx.c                             |  14 +-
>   drivers/ata/libahci_platform.c                     | 236 ++++++++++++++-------
>   include/linux/ahci_platform.h                      |   2 +
>   6 files changed, 305 insertions(+), 84 deletions(-)
>
