Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3EUSXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:23:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab3EUSXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:23:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Christian Daudt" <csd@broadcom.com>
Subject: Re: [PATCH V2 1/2] ARM: mmc: bcm281xx SDHCI driver
Date: Tue, 21 May 2013 20:23:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Rob Landley" <rob@landley.net>,
        "Russell King" <linux@arm.linux.org.uk>, "Chris Ball" <cjb@laptop.org>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Olof Johansson" <olof@lixom.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Wei WANG" <wei_wang@realsil.com.cn>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, csd_b@daudt.org
References: <1368200883-15668-1-git-send-email-csd@broadcom.com> <201305170009.46244.arnd@arndb.de> <519B2EAD.4000208@broadcom.com>
In-Reply-To: <519B2EAD.4000208@broadcom.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305212023.03272.arnd@arndb.de>
X-Provags-ID: V02:K0:HQtH5E1DOxgQoln3C3G+reZJOc6JMffqMcMHwAz2JoD
 DduaLalwFu8q5eY8B3qb54S2lxDz115bndyQNF88bZVRUGRPQe
 3s5Ru3B7wMp99ZtK40xPVxWto66/jxKVdwYCLFYLTqEv4eF9EU
 lWBtal9hckvHLyNNEGAYAU/5Idg0ItIYdBcR2OROgA6BpD3BXa
 KOEBSwdsK8kYOga2MvCbRT9J5j7AC95Wyr/tOtx5jIOmBzv5fH
 obzm6HyDQsH50DJKWjPvvdhJ1MhmPQ3QNC6fvITqEw5SrXEPGy
 Ck2lc+6szvKmNbPsEy12KNnGU495ZUcxtsgISSBLen0ZzqpLuI
 XVE6pVrmgasehmSV2NAs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 May 2013, Christian Daudt wrote:
> >> +    cfg = devm_kzalloc(&pdev->dev, sizeof(*cfg), GFP_KERNEL);
> >> +    if (!cfg) {
> >> +            dev_err(&pdev->dev, "Can't allocate platform cfg\n");
> >> +            return NULL;
> >> +    }
> > Not needed
> what is not needed ?

The allocation, it can be part of the sdhci_pltfm_host data.

> >> +    const struct sdhci_pltfm_data *plat_data;
> > make it global.
> why make this global ?

Sorry for being unclear. I mean you can just use &sdhci_pltfm_data_kona
in the probe function, since the data is constant anyway, no need to have
a local variable for pulling this out of the device id.

	Arnd
