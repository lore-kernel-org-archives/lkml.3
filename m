Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaB0Vsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:48:38 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55632 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaB0Vsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:48:36 -0500
Message-ID: <530FB2AE.8020204@gmail.com>
Date: Thu, 27 Feb 2014 22:48:30 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ARM: dove: move Dove DT to MVEBU
References: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140227214543.GK1872@titan.lakedaemon.net>
In-Reply-To: <20140227214543.GK1872@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 10:45 PM, Jason Cooper wrote:
> On Thu, Feb 27, 2014 at 10:28:01PM +0100, Sebastian Hesselbarth wrote:
>> Thanks to DT conversion effort, Marvell Dove with DT support is now
>> ready to leave mach-dove and hop into mach-mvebu. As discussed with
>> MVEBU maintainers, we first add dove.c now and keep on migrating
>> it with Armada 3xx SoCs the next cycle.
>>
>> Patch 1 adds a DT node for the system controller found on Marvell
>> MVEBU SoCs.
>>
>> Patch 2 copies an approach taken by Andrew Lunn for Kirkwood-to-MVEBU
>> patches, that add MACH_DOVE for Dove in mach-mvebu to distinguish it
>> from ARCH_DOVE in mach-dove, where drivers still support both non-DT
>> and DT.
>>
>> Patch 3 then moves mach-dove/board-dt.c to mach-mvebu/dove.c with
>> minor cleanups and converts drivers/phy/Kconfig to MACH_DOVE for
>> a DT-only driver.
>>
>> Patch 4 finally adds MACH_DOVE and some of its drivers to multi_v7
>> defconfig.
>>
>> The patches are based on v3.14-rc4, recently posted mvebu/pinctrl-cleanup
>> and mvebu/pinctrl-dove branches: v3.14-rc4 is required for a irqchip
>> driver fix when SPARSE_IRQ is set, the pinctrl branches remove hard-coded
>> addresses from Dove's pinctrl driver.
>
> If I were to base this series on v3.14-rc1, I would need to pull in
>
>    mvebu/pinctrl-dove (which draws in mvebu/pinctrl-cleanup)
>    mvebu/irqchip-fixes
>
> and that should be all.  iiuc, these are boot-time requirements, not
> build or merge requirements, correct?

Yes, all are boot-time requirements only.

Sebastian
