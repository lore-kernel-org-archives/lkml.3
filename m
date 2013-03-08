Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574Ab3CHSHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:07:45 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18041 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934551Ab3CHSHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:07:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Mar 2013 10:07:40 -0800
Message-ID: <513A2888.5020402@nvidia.com>
Date: Fri, 8 Mar 2013 23:36:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH 1/5] ARM: DT: tegra114: add APB DMA controller DT entry
References: <1362750782-15174-1-git-send-email-ldewangan@nvidia.com> <1362750782-15174-2-git-send-email-ldewangan@nvidia.com> <513A250C.1000202@wwwdotorg.org>
In-Reply-To: <513A250C.1000202@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 March 2013 11:21 PM, Stephen Warren wrote:
> On 03/08/2013 06:52 AM, Laxman Dewangan wrote:
>> NVIDIA's Tegra114 has 32 channels APB DMA controller. Add DT entry for
>> APB DMA controllers and make it compatible with "nvidia,tegra114-apbdma".
>> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
>> +	apbdma: dma {
>> +		compatible = "nvidia,tegra114-apbdma";
> So I know that the Tegra114 HW has a new channel-pause feature, which
> the driver /can/ use. However, if the driver didn't know about that
> feature, and continued to use the global-pause feature, would it still
> work fine?
>
> In other words, is the Tegra114 HW 100% backwards-compatible with the
> Tegra30 HW, it's just that there are new features that SW could
> optionally use?
>
> If that is true, then we should also include "nvidia,tegra30-apbdma" in
> the compatible value.

Tegra114 HW is not compatible with the tegra30 as with global pause, it 
is not able to write into the dma register in T114. On t114, the dma 
register is clock gated with global enable/disable.



