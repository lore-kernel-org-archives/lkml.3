Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaFXFoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:44:12 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7925 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaFXFoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:44:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Jun 2014 22:38:07 -0700
Message-ID: <53A91026.7040506@nvidia.com>
Date: Tue, 24 Jun 2014 14:44:06 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 2/2] ARM: tegra: roth: enable input on mmc clock pins
References: <1403508779-25896-1-git-send-email-acourbot@nvidia.com> <1403508779-25896-3-git-send-email-acourbot@nvidia.com> <53A87979.6000104@wwwdotorg.org>
In-Reply-To: <53A87979.6000104@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 04:01 AM, Stephen Warren wrote:
> On 06/23/2014 01:32 AM, Alexandre Courbot wrote:
>> Input had been disabled by mistake on these pins, leading to issues with
>> SDIO devices like the Wifi module not being probed or random errors
>> occuring on the SD card.
>
> I thought the host controller always drove the clock, so there should be
> no need for the pin's input path to be enabled. Perhaps it depends on
> the transfer mode (e.g. UHS)?

That's what I thought too, so I went against what was done downstream 
and disabled input mode. Eventually noticed various issues with MMC 
devices, reverted to the downstream settings and noticed my problems 
were solved by this single change.

>
> If this fix is valid, perhaps Jetson TK1's sdmmc3_clk and Venice2's
> sdmmc1_clk need the same fix, although we'll need to file bugs against
> their pinmux spreadsheets first if that's the case.
>

Are we having MMC issues with Jetson? I haven't noticed anything 
recently, and I have been using both eMMC and SD card.

Anyway, at least for SHIELD, this change seems to be valid.
