Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab3BNKv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:51:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7949 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab3BNKvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:51:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Feb 2013 02:47:29 -0800
Message-ID: <511CC194.8010206@nvidia.com>
Date: Thu, 14 Feb 2013 16:21:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] clk: tegra: initialise parent of uart clocks
References: <1360682279-23051-1-git-send-email-ldewangan@nvidia.com> <511A7FF1.1030009@wwwdotorg.org> <511B3AA0.7020403@nvidia.com> <511BC0AC.2010101@wwwdotorg.org>
In-Reply-To: <511BC0AC.2010101@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2013 10:04 PM, Stephen Warren wrote:
> On 02/13/2013 12:02 AM, Laxman Dewangan wrote:
>> On Tuesday 12 February 2013 11:16 PM, Stephen Warren wrote:
>>> On 02/12/2013 08:17 AM, Laxman Dewangan wrote:
>>>> Initialise the parent of UARTs to PLLP and disabling clock by
>>>> default.
>>> This patch wasn't tested, was it? Without the patch I just sent titled
>>> "ARM: tegra: remove clock-frequency properties from serial nodes", the
>>> UART clocks get turned off and the console breaks.
>> I tested this in next-20130212 where "clock-frequency" is there in
>> tegra30.dtsi file.
> I tested on Cardhu/Tegra30 (I'd previously only tested on
> Harmony/Tegra20), and I see the exact same problem; the clock core turns
> off the UART clock and the system hangs.
>
> Are you sure you don't have any other local patches that somehow keep
> the UART clock on (e.g. disabling clk_disable_unused, calling clk_get()
> on the UART clock somewhere else, have the Tegra HS UART driver enabled
> on the console port for testing which perhaps does an unconditional
> clk_get). Are you sure you're testing with U-Boot rather than our binary
> bootloader; who knows what kind of voodoo that does to clocks.
>
> Note: I tested: a merge of arm-soc/for-next and Tegra's for-next branch,
> with my patch to remove the clock-frequency properties reverted, plus a
> fix for the boot crash ("clockevents: fix generic broadcast for
> FEAT_C3STOP").
>
>> If you remove this from dts file at all then it will not work as there
>> is no execution path to call the clk_prepare_enable().
>>
>> of_serial.c file:
>>          if (of_property_read_u32(np, "clock-frequency", &clk)) {
> That returns 0 if the property is present (so doesn't get/enable the
> clock), and an error code if the property is missing (so does get/enable
> the clock).

Ahha..Yes, got it. I tested this in next-20130212 with the maintainer's 
patch for broadcast, reverting one change "OF: convert devtree lock from 
rw_lock to raw spinlock" and
uart clock change. The system was booting but not reaching to login. I 
was assumign that it may be the issue with other reason as I saw the 
uart log.

After taking your patch for removing clock-freq and this patch, the 
system booted to login prompt means it is working fine.


So I was wrong when telling clock-frequency is required. Actually it 
should not be to work properly.

