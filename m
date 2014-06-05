Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaFESJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:09:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52494 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaFESJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:09:40 -0400
Message-ID: <5390B260.2010801@wwwdotorg.org>
Date: Thu, 05 Jun 2014 12:09:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/5] misc: fuse: Add efuse driver for Tegra
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com> <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 07:09 AM, Peter De Schrijver wrote:
> Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.

This series isn't bisectable; building at either patch 3 or patch 4 yields:

> In file included from arch/arm/mach-tegra/fuse.c:28:0:
> arch/arm/mach-tegra/fuse.h:40:5: error: conflicting types for ‘tegra_fuse_readl’
> In file included from arch/arm/mach-tegra/fuse.c:26:0:
> include/linux/tegra-soc.h:43:5: note: previous declaration of ‘tegra_fuse_readl’ was here
> arch/arm/mach-tegra/fuse.c:98:5: error: conflicting types for ‘tegra_fuse_readl’
> In file included from arch/arm/mach-tegra/fuse.c:26:0:
> include/linux/tegra-soc.h:43:5: note: previous declaration of ‘tegra_fuse_readl’ was here
> make[1]: *** [arch/arm/mach-tegra/fuse.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [arch/arm/mach-tegra] Error 2
> make: *** Waiting for unfinished jobs....

