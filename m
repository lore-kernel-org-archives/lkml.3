Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3A2Rmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:42:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54652 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3A2Rmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:42:31 -0500
Message-ID: <510809FC.2080806@wwwdotorg.org>
Date: Tue, 29 Jan 2013 10:42:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] ARM: DT: tegra114: add APB DMA controller DT entry
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com> <1359464183-6255-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1359464183-6255-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 05:56 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has 32 channels APB DMA controller. Add DT entry for
> APB DMA controllers and make it compatible with "nvidia,tegra114-apbdma".

The APB DMA controller node needs a clocks property. The same goes for
I2C and KBC. I'd like to avoid merging those 3 patches until the
Tegra114 clock patches are present, since the nodes won't be useful
until then anyway. I expect the clock patches will be merged in 3.10.

Related, the I2C driver appears to need updates since the HW isn't 100%
backwards-compatible. I would prefer not to apply the patch adding DT
nodes for I2C until the relevant driver patches are also posted and
checked in. That said, Wolfram said he applied the Tegra114 I2C patch on
1/24, although I don't see it in next-20130128; perhaps he simply didn't
push out his next branch to the git server yet?

I think the other patches are all OK, so I'll apply them to Tegra's
for-3.9/soc-t114 branch.
