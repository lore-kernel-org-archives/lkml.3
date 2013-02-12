Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3BLFFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:05:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6548 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3BLFFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:05:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 11 Feb 2013 21:04:07 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "arnd@arndb.de" <arnd@arndb.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "marvin24@gmx.de" <marvin24@gmx.de>, "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Feb 2013 06:04:56 +0100
Subject: Re: [v2 3/3] ARM: tegra: Unify Device tree board files
Thread-Topic: [v2 3/3] ARM: tegra: Unify Device tree board files
Thread-Index: Ac4I3oGQ4Lrq5Z4NQyum6KEhKmUs8Q==
Message-ID: <20130212.070456.532657136988541923.hdoyu@nvidia.com>
References: <5119849B.1070300@wwwdotorg.org><20130212.061240.2083183700176617607.hdoyu@nvidia.com><5119C958.1030304@wwwdotorg.org>
In-Reply-To: <5119C958.1030304@wwwdotorg.org>
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

Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 12 Feb 2013 05:47:20 +0100:

> >>>  static void __init harmony_init(void)
> >>>  {
> >>> -#ifdef CONFIG_TEGRA_PCI
> >>>  	int ret;
> >>>  
> >>>  	ret = harmony_pcie_init();
> >>>  	if (ret)
> >>>  		pr_err("harmony_pcie_init() failed: %d\n", ret);
> >>> -#endif
> >>>  }
> >>
> >> Why drop those ifdefs? Does the code still compile (link) if built for
> >> Tegra30-only or Tegra114-only, where the Tegra PCI driver won't be
> >> enabled, and hence those functions don't exist?
> > 
> > This function itself will be dropped by the following IS_ENABLED().
> > 
> >>>  static void __init paz00_init(void)
> >>> @@ -129,6 +128,9 @@ static void __init tegra_dt_init_late(void)
> >>>  
> >>>  	tegra_init_late();
> >>>  
> >>> +	if (IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
> >>> +		return;
> >>
> >> I don't think that's going to help any link issues, so I'd drop it and
> >> keep this function simple.
> > 
> > As explained in the above, a complier will drop unnecessary functions
> > automatically with this IS_ENABLED(), which could save many ifdefs.
> 
> That sounds extremely brittle. Have you validated this on a wide variety
> of compiler versions?

I verified with gcc-4.6.
IIRC, that's the point of IS_ENABLED() being introduced. Arnd?
