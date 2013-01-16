Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3APGEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:04:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19132 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3APGEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:04:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 15 Jan 2013 22:03:20 -0800
Message-ID: <50F64432.4030809@nvidia.com>
Date: Wed, 16 Jan 2013 08:09:54 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 7/8] ARM: tegra: Add board data and 2D clocks
References: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com> <1358249182-17486-8-git-send-email-tbergstrom@nvidia.com> <50F5A3A6.7000801@wwwdotorg.org>
In-Reply-To: <50F5A3A6.7000801@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.01.2013 20:44, Stephen Warren wrote:
>> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
> 
>> +	OF_DEV_AUXDATA("nvidia,tegra20-gr2d", 0x54140000, "gr2d", NULL),
> 
> I assume the only reason to add AUXDATA is to give the device a specific
> name, which will then match the driver name in the clock driver:
> 
>> -	CLK_DUPLICATE("2d",	"tegra_grhost",	"gr2d"),
>> +	CLK_DUPLICATE("2d",	"gr2d",	"gr2d"),
> 
> If so, this shouldn't be needed once the common clock framework patches
> are applied, since all device clocks will be retrieved from device tree,
> and hence the device name will be irrelevant; the phandle in device tree
> is all that will matter.

Yes, clock binding is the only reason for the OF_DEV_AUXDATA line. I'll
need to look into Prashant's clock changes, but I assume it's going to
be a trivial change to host1x patches.

Thanks for the heads-up.

Terje

