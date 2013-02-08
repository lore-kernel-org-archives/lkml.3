Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab3BHIKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:10:19 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3220 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab3BHIKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:10:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 08 Feb 2013 00:10:08 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Feb 2013 09:09:42 +0100
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Thread-Topic: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
Thread-Index: Ac4F06qKQ6zWVLrkQk679nufXV/uAQ==
Message-ID: <20130208.100942.592982910310763762.hdoyu@nvidia.com>
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com><1360308574-19658-2-git-send-email-hdoyu@nvidia.com><20130208074720.GB21879@arwen.pp.htv.fi>
In-Reply-To: <20130208074720.GB21879@arwen.pp.htv.fi>
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

Hi Felipe,

Felipe Balbi <balbi@ti.com> wrote @ Fri, 8 Feb 2013 08:47:20 +0100:

> > +#if defined(CONFIG_ARCH_TEGRA_3x_SOC)
>
> how about using:
>
> #if IS_BUILTIN(CONFIG_ARCH_TEGRA_3x_SOC)
>
> instead ?

Why is IS_BUILTIN() prefered?

> > -void tegra20_hotplug_init(void);
> > -void tegra30_hotplug_init(void);
> > +void tegra20_hotplug_shutdown(void);
> > +void tegra30_hotplug_shutdown(void);
>
> aren't these two called only by tegra_hotplug_init() now ?

Yes

> That means they don't need to be exposed.

tegra{20,30}_hotplug_shutdown are defined in sleep-tegra{20,30}.S and
used in hotplug.c So I think that the above are necessary here.
