Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaFESG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:06:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39576 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaFESG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:06:26 -0400
Message-ID: <5390B19F.7090008@wwwdotorg.org>
Date: Thu, 05 Jun 2014 12:06:23 -0600
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
Subject: Re: [PATCH v7 1/5] ARM: tegra: export apb dma readl/writel
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com> <1401973754-19701-2-git-send-email-pdeschrijver@nvidia.com> <5390AF88.9050007@wwwdotorg.org>
In-Reply-To: <5390AF88.9050007@wwwdotorg.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 11:57 AM, Stephen Warren wrote:
> On 06/05/2014 07:09 AM, Peter De Schrijver wrote:
>> Export APB DMA readl and writel. These are needed because we can't access
>> the fuses directly on Tegra20 without potentially causing a system hang.
>> Also have the APB DMA readl and writel return an error in case of a read
>> failure instead of just returning zero or ignore write failures.
> 
>> diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
> 
>> +int tegra_apb_readl_using_dma(unsigned long offset, u32 *value);
>> +int tegra_apb_writel_using_dma(u32 value, unsigned long offset);
> 
> Hmm. I wonder why we're exporting those low-level internal functions
> rather than the higher-level tegra_apb_readl()/writel() wrappers that
> "clients" are supposed to be using.

Oh, I suppose this is just for rivers/misc/fuse/tegra/fuse-tegra20.c to
use it, not for arbitrary clients, so this is probably OK.

Any reason not to move all the DMA-related fuse-reading code into
fuse-tegra20.c instead? After this series, is there code left in
arch/arm/mach-tegra which will still need to call into the fuse-reading
code and hence requires tegra_apb_readl_using_dma() to exist?
