Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212Ab3BJUUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 15:20:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49830 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761108Ab3BJUUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 15:20:51 -0500
Message-ID: <51180121.6040803@wwwdotorg.org>
Date: Sun, 10 Feb 2013 13:20:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        arnd@arndb.de, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: tegra: Unify tegra{20,30,114}_init_early()
References: <1360308574-19658-1-git-send-email-hdoyu@nvidia.com> <340098510.UosBEPkrGv@fb07-iapwap2> <51153136.7010705@wwwdotorg.org> <2499199.srlLvkihNZ@ax5200p>
In-Reply-To: <2499199.srlLvkihNZ@ax5200p>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1On 02/10/2013 10:28 AM, Marc Dietrich wrote:
> On Friday 08 February 2013 10:09:10 Stephen Warren wrote:
>> On 02/08/2013 05:29 AM, Marc Dietrich wrote:
>>> Hiroshi,
>>>
>>> Am Freitag, 8. Februar 2013, 09:29:31 schrieb Hiroshi Doyu:
>>>> Refactored tegra{20,30,114}_init_early() so that we have the unified
>>>> tegra_init_early().
...
>>> are these ifdefs really needed? Multisoc kernels will enable them all
>>> anyway and there is a case structure which protects the assignments. Also
>>> the hotplug functions are very tiny, so there shouldn't be a big loss.
>>
>> The files that contain/implement those functions are separate for each
>> SoC and only included in the build when the individual SoCs are enabled.
>>
>> While multi-platform SoCs do make sense for distros, we also very
>> specifically want to support the case where only Tegra, and only a
>> single Tegra SoC, is enabled, hence this separation.
> 
> Huh? so tegra_defconfig is not supported?
> 
> grep "TEGRA_.*_SOC" tegra_defconfig:
> 
> CONFIG_ARCH_TEGRA_2x_SOC=y
> CONFIG_ARCH_TEGRA_3x_SOC=y

I don't understand the question.

But to be clear. There are now 3 variants of Tegra supported. (Tegra20,
Tegra30, Tegra114). We want to be able to build a minimal-size kernel
(e.g. for embedded applications) that supports just one, any combination
of two, or all three Tegra variants.
