Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365Ab3BLPXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:23:08 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17730 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab3BLPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:23:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Feb 2013 07:19:22 -0800
Message-ID: <511A5E48.8090101@nvidia.com>
Date: Tue, 12 Feb 2013 20:52:48 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: initialise parent of uart clocks
References: <1360147661-5435-1-git-send-email-ldewangan@nvidia.com> <5112964D.50707@wwwdotorg.org>
In-Reply-To: <5112964D.50707@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013 11:13 PM, Stephen Warren wrote:
> On 02/06/2013 03:47 AM, Laxman Dewangan wrote:
>> Initialise the parent of UARTs to PLLP
> OK
>
>> and disabling clock by default.
> Hmm. Only the clocks initialized by the new entries you added are marked
> disabled (or rather, not actively enabled; if they're enabled already,
> they won't be disabled). We should treat all UARTs equally. Historically
> we've needed to enable the serial clocks forcibly since the regular
> serial driver didn't call clk_get() or clk_prepare_enable() on any
> clocks, but I notice that it does now, since sometime in kernel 3.8. As
> such, I think you can modify all the UART entries in these tables to
> have the enable/state field set to false (0). Can you try that and check
> that it works for the serial console ports? Thanks.

Yes, this work even if I make state to 0 (disabled) in clock init table. 
The of_serial driver call the clk_prepare_enable() if property 
"clock_frequency" is there in dt node and in our dts file, we have 
already this property.

I sent V2 patch.

