Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbbAHJkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:40:08 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17113 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbbAHJkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:40:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Jan 2015 01:32:40 -0800
Date: Thu, 8 Jan 2015 11:39:57 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Vince Hsu <vinceh@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        <swarren@wwwdotorg.org>, <gnurou@gmail.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <samuel.pitoiset@gmail.com>, <nouveau@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
Message-ID: <20150108093957.GW10073@tbergstrom-lnx.Nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-2-git-send-email-vinceh@nvidia.com>
 <1419426990.2179.7.camel@lynxeye.de>
 <549B7638.2010405@nvidia.com>
 <20150105150932.GG12010@ulmo.nvidia.com>
 <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com>
 <54AD0F37.5080609@nvidia.com>
 <20150107141254.GS10073@tbergstrom-lnx.Nvidia.com>
 <20150107141938.GA7392@nvidia.com>
 <20150107151206.GG1621@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150107151206.GG1621@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.21.24.170]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And specify the dependencies between domains in DT?
> 
> I think the dependencies could be in the driver. Of course the power
> domains are per-SoC data, so really shouldn't be in the DTS either (the
> data is all implied by the compatible value) but there's no good way to

The clock references could also be retrieved via clk_get_sys(). We could add
some more clkdev entries. If we use the domain name as the dev_id and the
module names as the con_id's, the domain code could then retrieve the
clocks by iterating over the module names and performing a
clk_get_sys(domain_name, module_name) for each module. Unfortunately no such
mechanism exists for resets.

Cheers,

Peter.
