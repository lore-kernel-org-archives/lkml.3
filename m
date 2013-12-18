Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3LRQ1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:27:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36778 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3LRQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:27:35 -0500
Message-ID: <52B1CCF1.2040907@wwwdotorg.org>
Date: Wed, 18 Dec 2013 09:27:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        swarren@nvidia.com, will.deacon@arm.com, grant.likely@linaro.org,
        thierry.reding@gmail.com, robherring2@gmail.com, joro@8bytes.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, galak@codeaurora.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 06/12] ARM: tegra: create a DT header defining SWGROUP
 ID
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-7-git-send-email-hdoyu@nvidia.com> <52B1568F.1050305@gmail.com>
In-Reply-To: <52B1568F.1050305@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 01:02 AM, Mark Zhang wrote:
> On 12/12/2013 03:57 PM, Hiroshi Doyu wrote:
>> Create a header file to define the swgroup IDs used by the IOMMU(SMMU)
>> binding. "swgroup" is a group of H/W clients which a Tegra SoC
>> supports. This unique ID can be used to calculate MC_SMMU_<swgroup
>> name>_ASID_0 register offset and MC_<swgroup name>_HOTRESET_*_0
>> register bit. This will allow the same header to be used by both
>> device tree files, and drivers implementing this binding, which
>> guarantees that the two stay in sync. This also makes device trees
>> more readable by using names instead of magic numbers. For HOTRESET
>> bit shifting we need another conversion table, which will come later.

>> diff --git a/include/dt-bindings/memory/tegra-swgroup.h b/include/dt-bindings/memory/tegra-swgroup.h

>> +#define TEGRA_SWGROUP_MPE	11	/* 0x264 */
>> +#define TEGRA_SWGROUP_MSENC	SWGROUP_MPE
> 
> Need to change this to:
> 
> #define TEGRA_SWGROUP_MSENC	11
> 
> The reason is that, this makes "TEGRA_SWGROUP_BIT" doesn't work. So if I
> write "TEGRA_SWGROUP_CELLS(MSENC)" in dt, that causes a dt compiling error.

I guess it's because TEGRA_SWGROUP_BIT needs to expand its argument
twice, which can be done.

That all said, just defining all the names directly to constants is
probably the most direct fix.
