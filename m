Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaFKMrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:47:39 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17770 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaFKMrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:47:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Jun 2014 05:38:47 -0700
Message-ID: <53984FE3.6010509@nvidia.com>
Date: Wed, 11 Jun 2014 15:47:31 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 3/5] misc: fuse: Add efuse driver for Tegra
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com> <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/14 16:09, Peter De Schrijver wrote:
...
> +int tegra_fuse_readl(u32 offset, u32 *val)
> +{
> +       if (!fuse_readl)
> +               return -ENXIO;
> +
> +       *val = fuse_readl(offset);
> +
> +       return 0;
> +}
> +

-EPROBE_DEFER would be a better error value, so that drivers can work 
even if they are initially probed before the fuse driver. Of course, if 
the fuse initialization is moved into machine init then this is a non-issue.
