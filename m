Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3A3EBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 23:01:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59742 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab3A3EBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 23:01:31 -0500
Message-ID: <51089B19.8060204@wwwdotorg.org>
Date: Tue, 29 Jan 2013 21:01:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] ARM: DT: tegra114: add APB DMA controller DT entry
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com> <1359464183-6255-4-git-send-email-ldewangan@nvidia.com> <510809FC.2080806@wwwdotorg.org> <5108998B.4040809@nvidia.com>
In-Reply-To: <5108998B.4040809@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 08:54 PM, Laxman Dewangan wrote:
> On Tuesday 29 January 2013 11:12 PM, Stephen Warren wrote:
>> On 01/29/2013 05:56 AM, Laxman Dewangan wrote:
>>> NVIDIA's Tegra114 has 32 channels APB DMA controller. Add DT entry for
>>> APB DMA controllers and make it compatible with
>>> "nvidia,tegra114-apbdma".
>> The APB DMA controller node needs a clocks property. The same goes for
>> I2C and KBC. I'd like to avoid merging those 3 patches until the
>> Tegra114 clock patches are present, since the nodes won't be useful
>> until then anyway. I expect the clock patches will be merged in 3.10.
> 
> I think clock patches can be posted on top of this as Peter is working.
> Although, the driver will fail in clk_get() but still I think this can
> be apply to populate the dts file with controller specific information.

While it would be physically possible for me to apply these patches now
and rely on Peter to add the clocks properties later, there's no point
in doing so, since as you say the drivers won't work with just these
patches. There will be less churn if we simply wait for the Tegra114
clock driver first, and then apply patches to add complete and working
DT nodes for all the devices.
