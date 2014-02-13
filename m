Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaBMQgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:36:18 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60589 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaBMQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:36:11 -0500
Message-ID: <52FCF476.4010908@wwwdotorg.org>
Date: Thu, 13 Feb 2014 09:36:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Marc Dietrich <marvin24@gmx.de>
CC: Stefan Agner <stefan@agner.ch>, josephl@nvidia.com, dev@lynxeye.de,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: don't timeout if CPU is powergated
References: <1d5ea6b7df4573d866779857922ac650fe59af60.1392078805.git.stefan@agner.ch> <52FBC97D.8040809@wwwdotorg.org> <4050206.sG2EzXyfMN@fb07-iapwap2> <20140213084907.GA11795@ulmo.nvidia.com>
In-Reply-To: <20140213084907.GA11795@ulmo.nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 01:49 AM, Thierry Reding wrote:
> On Thu, Feb 13, 2014 at 09:28:52AM +0100, Marc Dietrich wrote:
>> Am Mittwoch, 12. Februar 2014, 12:20:29 schrieb Stephen Warren:
>>> On 02/10/2014 05:44 PM, Stefan Agner wrote:
>>>> When booting secondary CPU(s) which are not yet powergated, a wrong
>>>> check lead to a timeout after 100 jiffies. With this patch, we only
>>>> delay powergating if CPUs are still not powered yet.
>>>
>>> I've applied this to Tegra's for-3.15/soc branch.
>>
>> also for 3.14 and maybe lower versioned kernels? Since this seems to fix a bug 
>> where some core doesn't come up.
> 
> Yeah, this bug has been there for pretty much forever it seems. Commit
> 86e51a2ee471 "ARM: tegra: support for secondary cores on Tegra30" added
> tegra30_boot_secondary() (named tegra30_power_up_cpu() back then, which
> was renamed to tegra30_boot_secondary() in commit 0d1f79b033bb "ARM:
> tegra: refactor tegra{20,30}_boot_secondary". The latter was introduced
> in v3.10, so I guess backporting it to stable releases all the way back
> to v3.10 would be good.
> 
> Backporting to earlier versions (86e51a2ee471 went into v3.4) will be a
> lot more difficult since some of the APIs were renamed since then.

I'm actually uninclined to backport this; I've never once seen an issue
because of this problem, and nobody has reported it in older kernels.
