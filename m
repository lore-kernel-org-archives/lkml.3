Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946755Ab3BHRJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:09:14 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46666 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946596Ab3BHRJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:09:13 -0500
Message-ID: <51153136.7010705@wwwdotorg.org>
Date: Fri, 08 Feb 2013 10:09:10 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        arnd@arndb.de, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com> <1360308574-19658-2-git-send-email-hdoyu@nvidia.com> <340098510.UosBEPkrGv@fb07-iapwap2>
In-Reply-To: <340098510.UosBEPkrGv@fb07-iapwap2>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 05:29 AM, Marc Dietrich wrote:
> Hiroshi,
> 
> Am Freitag, 8. Februar 2013, 09:29:31 schrieb Hiroshi Doyu:
>> Refactored tegra{20,30,114}_init_early() so that we have the unified
>> tegra_init_early().

>> diff --git a/arch/arm/mach-tegra/hotplug.c b/arch/arm/mach-tegra/hotplug.c

>> +void __init tegra_hotplug_init(void)
>>  {
>> +	switch (tegra_chip_id) {
>> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
>> +	case TEGRA20:
>> +		tegra_hotplug_shutdown = tegra20_hotplug_shutdown;
>> +		break;
>>  #endif
>> +#if defined(CONFIG_ARCH_TEGRA_3x_SOC)
>> +	case TEGRA30:
>> +		tegra_hotplug_shutdown = tegra30_hotplug_shutdown;
>> +		break;
>>  #endif
>> +	default:
>> +		BUG_ON(IS_ENABLED(CONFIG_HOTPLUG_CPU));
>> +		break;
>> +	}
>> +}
> 
> are these ifdefs really needed? Multisoc kernels will enable them all anyway 
> and there is a case structure which protects the assignments. Also the hotplug 
> functions are very tiny, so there shouldn't be a big loss.

The files that contain/implement those functions are separate for each
SoC and only included in the build when the individual SoCs are enabled.

While multi-platform SoCs do make sense for distros, we also very
specifically want to support the case where only Tegra, and only a
single Tegra SoC, is enabled, hence this separation.

(and Tegra doesn't support multi-platform yet; maybe in another kernel
release or two)

