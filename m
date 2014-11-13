Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaKMMCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:02:38 -0500
Received: from down.free-electrons.com ([37.187.137.238]:39445 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932573AbaKMMCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:02:37 -0500
Message-ID: <54649DCC.3000900@free-electrons.com>
Date: Thu, 13 Nov 2014 13:02:20 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Hot plug support for the Armada 38x SoCs
References: <1414669184-16785-1-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1414669184-16785-1-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On 30/10/2014 12:39, Gregory CLEMENT wrote:
> Hi,
> 
> This patch set is the second version of the series adding the hot plug
> and also kexec support for the Armada 38x Socs.
> 
> If nobody object we could push them in linux-next.
> 
> The first patch was done in order to have the same code between Armada
> XP and the Cortex A9 based mvebu SoCs. In order to ensure the the
> backward compatibility for the device tree, it is only a preliminary
> work for it.
> 
> The second patch moves the SCU power up sequence in a dedicated
> assembly function. It was done in order to reuse it in the 3rd patch.
> 
> The third patch fixes the secondary startup for the cortex A9 mvebu
> SoC. Indeed, the initial code was written with the assumption the SCU
> will be always power on, which is not only true especially in the
> kexec case.
> 
> These 2 patches may worth to be pushed to the stable kernel.
> 
> Then the last patch adds the CPU hotplug support for Armada 38x. I
> tested the hotplug using the /sys/devices/system/cpu/cpu1/online
> virtual file.  I also tested the kexec feature and managed to switch
> to a new kernel using kexec.
> 
> Thanks,
> 
> Gregory
> 

This second series have been sent 2 weeks ago and it didn't receive more
comments. The biggest part of this series is similar to what have been
done for the Armada XP. Unless you have any comments, what about applying it
on the mvebu branches?

Thanks,

Gregory


> Changelog:
> 
> v1 -> v2:
> 
> - Fix typo and improve the comment explaining why we need to keep the
>   .smp filed in the 1st patch.
> 
> - Add a prefix to the function power_up_scu function to keep it
>   private and not "pollute" the global namespace.
> 
> Gregory CLEMENT (4):
>   ARM: mvebu: Clean-up the Armada XP support
>   ARM: mvebu: Move SCU power up in a function
>   ARM: mvebu: Fix the secondary startup for Cortex A9 SoC
>   ARM: mvebu: Implement the CPU hotplug support for the Armada 38x SoCs
> 
>  arch/arm/mach-mvebu/armada-370-xp.h |  6 -----
>  arch/arm/mach-mvebu/board-v7.c      |  5 ++++
>  arch/arm/mach-mvebu/coherency.c     |  1 -
>  arch/arm/mach-mvebu/cpu-reset.c     |  1 -
>  arch/arm/mach-mvebu/headsmp-a9.S    |  1 +
>  arch/arm/mach-mvebu/platsmp-a9.c    | 53 +++++++++++++++++++++++++++++++++++--
>  arch/arm/mach-mvebu/platsmp.c       |  2 ++
>  arch/arm/mach-mvebu/pmsu.c          |  3 +--
>  arch/arm/mach-mvebu/pmsu.h          |  2 ++
>  arch/arm/mach-mvebu/pmsu_ll.S       | 20 +++++++++-----
>  10 files changed, 75 insertions(+), 19 deletions(-)
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
