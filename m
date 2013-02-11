Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3BKES6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 23:18:58 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17680 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3BKES4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 23:18:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 10 Feb 2013 20:18:13 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "marvin24@gmx.de" <marvin24@gmx.de>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 11 Feb 2013 05:18:40 +0100
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Thread-Topic: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Thread-Index: Ac4IDt/LgZh41qQRQjWhXkSEWoPnmQ==
Message-ID: <20130211.061840.516448986332629268.hdoyu@nvidia.com>
References: <2499199.srlLvkihNZ@ax5200p><51180121.6040803@wwwdotorg.org><1828614.u7HcYf891a@ax5200p>
In-Reply-To: <1828614.u7HcYf891a@ax5200p>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

Marc Dietrich <marvin24@gmx.de> wrote @ Sun, 10 Feb 2013 22:16:14 +0100:

> ah, ok - I just skipped the "also" in your sentence above. But still, the 
> #ifdefs look strange to me and save only a few byte of code. Just me few 
> cents.

What about the following as Arnd suggested[1]?

void __init tegra_hotplug_init(void)
{
	if (!IS_ENABLED(CONFIG_HOTPLUG_CPU))
	   return;
	   
	   if (IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC)) && tegra_chip_id == TEGRA20)
	      tegra_hotplug_shutdown = tegra20_hotplug_shutdown;
	      if (IS_ENABLED(CONFIG_ARCH_TEGRA_3x_SOC)) && tegra_chip_id == TEGRA30)
	      	 tegra_hotplug_shutdown = tegra30_hotplug_shutdown;
}

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/148632.html
