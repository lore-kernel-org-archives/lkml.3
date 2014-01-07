Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaAGUlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 15:41:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56361 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaAGUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 15:41:24 -0500
Message-ID: <52CC666F.1010501@wwwdotorg.org>
Date: Tue, 07 Jan 2014 13:41:19 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Danny Huang <dahuang@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] misc: fuse: Add efuse driver for Tegra
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com> <1387891931-9854-3-git-send-email-pdeschrijver@nvidia.com> <52CB12D8.7000203@wwwdotorg.org> <20140107140502.GE26588@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140107140502.GE26588@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 07:05 AM, Peter De Schrijver wrote:
> On Mon, Jan 06, 2014 at 09:32:24PM +0100, Stephen Warren wrote:
>> On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
>>> Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.

>>> diff --git a/drivers/misc/fuse/tegra/fuse-tegra20.c b/drivers/misc/fuse/tegra/fuse-tegra20.c
>>
>>> +static int fuse_size;
>>
>> I don't think that's used.
>>
>>> +static u32 tegra20_fuse_readl(const unsigned int offset)
>> ...
>>> +	ret = tegra_apb_readl_using_dma(fuse_phys + FUSE_BEGIN + offset, &val);
>>
>> Shouldn't this use the generic tegra_apb_readl(), so that it works
>> irrespective of whether the Tegra20 APB DMA driver is available?
>
> tegra_apb_readl() doesn't work reliably on Tegra20 for reading the fuses.
> So if the Tegra20 APB DMA, this driver should also be unavailable.

There's no "depends TEGRA20_APB_DMA" in the Kconfig. Perhaps
ARCH_TEGRA_2x_SOC or FUSE_TEGRA should "select TEGRA20_APB_DMA"?

>>> +static int tegra_fuse_probe(struct platform_device *pdev)
>> ...
>>> +	fuse_randomness();
>>
>> If this is a driver, and particularly if this could be in a module, is
>> there any guarantee at all that fuse_randomness() gets called early
>> enough to be useful?
> 
> For a module this might be true yes... Should we disallow this making a
> module?

That would simplify things, I expect...

