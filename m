Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbbAGPYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:24:54 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:48941 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbbAGPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:24:52 -0500
Message-ID: <54AD4FB7.20600@gmail.com>
Date: Wed, 07 Jan 2015 18:24:39 +0300
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Paul Walmsley <paul@pwsan.com>
CC: linux-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] soc: tegra: pmc: restrict compilation of suspend-related
 support to ARM
References: <alpine.DEB.2.02.1412092224050.31750@utopia.booyaka.com> <20150107143354.GD1621@ulmo>
In-Reply-To: <20150107143354.GD1621@ulmo>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.01.2015 17:33, Thierry Reding пишет:
> On Tue, Dec 09, 2014 at 10:36:50PM +0000, Paul Walmsley wrote:
>>
>> Tegra SoCs with 64-bit ARM support don't currently support deep CPU
>> low-power states in mainline Linux.  When this support is added in the
>> future, it will probably look rather different from the existing
>> 32-bit ARM support, since the ARM64 maintainers' strong preference is
>> to use PSCI to implement it.
>>
>> So, for the time being, prevent the CPU suspend-related code and data
>> in the Tegra PMC driver from compiling on ARM64.
>>
>> Signed-off-by: Paul Walmsley <paul@pwsan.com>
>> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
>> Cc: Thierry Reding <treding@nvidia.com>
>> Cc: Allen Martin <amartin@nvidia.com>
>> Cc: Stephen Warren <swarren@nvidia.com>
>> Cc: Alexandre Courbot <gnurou@gmail.com>
>> ---
>> Applies on next-20141209.
>> Intended for v3.20.
>> Boot-tested on Tegra124 Jetson TK1 on next-20141209.
>> Also boot-tested on Tegra132 Norrin FFD on next-20141209 + some unrelated 
>> patches.
>>
>>  drivers/soc/tegra/pmc.c | 7 +++++--
>>  include/soc/tegra/pm.h  | 2 +-
>>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> On second thought, I decided to apply this as-is.
> 
> Thanks,
> Thierry
> 

Oh, I haven't noticed this patch before...

I sent patch fixing tegra20 suspend bug [
http://patchwork.ozlabs.org/patch/423778/ ] and it will obviously conflict with
this one.
For now there is no feedback for my suspend bug patch (other than for V1), but,
if it's fine, I think it would be easier to rebase Paul's patch on top of it.
Any other suggestions?

-- 
Dmitry
